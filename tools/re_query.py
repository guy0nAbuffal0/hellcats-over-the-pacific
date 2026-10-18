#!/usr/bin/env python3
"""Retrieve narrow, source-backed reverse-engineering evidence."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
INVENTORY = ROOT / "docs" / "DECOMPILATION_INVENTORY.json"
SYMBOLS = ROOT / "docs" / "DECOMPILATION_SYMBOLS.md"
STRICT_MAP = ROOT / "godot" / "strict_port" / "mappings" / "functions.json"
CONTROL_WORDS = {"if", "for", "while", "switch", "return", "sizeof"}
ADDRESS_RE = re.compile(r"^(?:0x|\$)?([0-9A-Fa-f]+)$")
GLOBAL_RE = re.compile(r"\b_?DAT_[0-9A-Fa-f]+\b")
CALL_RE = re.compile(r"\b([A-Za-z_]\w*)\s*\(")


def relative(path: Path) -> str:
    return str(path.resolve().relative_to(ROOT))


def normalize_segment(value: str) -> str:
    name = Path(value).name
    for suffix in (".decomp.c", ".c"):
        if name.endswith(suffix):
            name = name.removesuffix(suffix)
    return name


def mask_comments(text: str) -> str:
    return re.sub(
        r"/\*.*?\*/|//[^\n]*",
        lambda match: re.sub(r"[^\n]", " ", match.group()),
        text,
        flags=re.DOTALL,
    )


class Registry:
    def __init__(self) -> None:
        data = json.loads(INVENTORY.read_text(encoding="utf-8"))
        if data.get("schema_version") != 3:
            raise ValueError("decompilation inventory is not canonical schema v3; regenerate it")
        self.rows: list[dict[str, Any]] = data["functions"]

    def resolve(self, query: str, segment: str | None = None) -> dict[str, Any]:
        if "::" in query:
            embedded_segment, query = query.split("::", 1)
            if segment and normalize_segment(segment) != normalize_segment(embedded_segment):
                raise LookupError("segment option conflicts with segment-qualified query")
            segment = embedded_segment
        normalized_segment = normalize_segment(segment) if segment else None
        address_match = ADDRESS_RE.fullmatch(query)
        normalized_address = f"0x{int(address_match.group(1), 16):x}" if address_match else None
        matches = []
        for row in self.rows:
            if normalized_segment and row["segment"].casefold() != normalized_segment.casefold():
                continue
            if query.casefold() in {
                row["original_function"].casefold(),
                (row.get("semantic_name") or "").casefold(),
            } or normalized_address == row["original_address"].casefold():
                matches.append(row)
        if not matches:
            if normalized_address:
                qualifier = f" in segment {normalized_segment!r}" if normalized_segment else ""
                raise LookupError(f"unsupported address mapping: {normalized_address}{qualifier}")
            raise LookupError(f"function not found: {query}")
        if len(matches) != 1:
            identities = ", ".join(row["identity"] for row in matches)
            raise LookupError(f"ambiguous function query {query!r}; qualify --segment ({identities})")
        return matches[0]


REGISTRY: Registry | None = None


def registry() -> Registry:
    global REGISTRY
    if REGISTRY is None:
        REGISTRY = Registry()
    return REGISTRY


def source_lines(row: dict[str, Any]) -> tuple[Path, list[str], int, int]:
    source = row["semantic_source"]
    path = ROOT / source["path"]
    all_lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    start, end = int(source["line_start"]), int(source["line_end"])
    if not (1 <= start <= end <= len(all_lines)):
        raise ValueError(f"invalid canonical source range for {row['identity']}: {start}-{end}")
    return path, all_lines[start - 1:end], start, end


def print_slice(path: Path, lines: list[str], start: int, end: int, label: str | None = None) -> None:
    heading = f"// {relative(path)}:{start}-{end}"
    if label:
        heading += f" [{label}]"
    print(heading)
    print("\n".join(lines))


def correspondence(row: dict[str, Any], detail: bool = False) -> dict[str, Any]:
    result: dict[str, Any] = {
        "identity": row["identity"],
        "original": {
            "function": row["original_function"],
            "address": row["original_address"],
            **row["original_source"],
        },
        "reconstructed": {
            "name": row["semantic_name"],
            **row["semantic_source"],
        },
        "renaming_confidence": row["renaming_confidence"],
        "reconstruction_status": row["reconstruction_status"],
        "behavioral_verification_status": row["behavioral_verification_status"],
        "strict_port": row.get("strict_port"),
    }
    if detail:
        result["evidence_references"] = row["evidence_references"]
        result["known_blockers"] = row["known_blockers"]
        result["technical_evidence"] = row.get("technical_evidence", {})
        result["source_revision"] = row.get("source_revision")
    return result


def cmd_function(args: argparse.Namespace) -> int:
    row = registry().resolve(args.query, args.segment)
    if args.detail:
        print(json.dumps(correspondence(row, True), indent=2, ensure_ascii=False))
    path, lines, start, end = source_lines(row)
    print_slice(path, lines, start, end, row["identity"])
    return 0


def cmd_correspondence(args: argparse.Namespace) -> int:
    row = registry().resolve(args.query, args.segment)
    print(json.dumps(correspondence(row, args.detail), indent=2, ensure_ascii=False))
    return 0


def cmd_excerpt(args: argparse.Namespace) -> int:
    row = registry().resolve(args.query, args.segment)
    path, body, absolute_start, _ = source_lines(row)
    if args.lines:
        match = re.fullmatch(r"(\d+):(\d+)", args.lines)
        if not match:
            raise ValueError("--lines must be a relative START:END range")
        start, end = map(int, match.groups())
        if not (1 <= start <= end <= len(body)):
            raise ValueError(f"relative range {start}:{end} exceeds function lines 1:{len(body)}")
        label = f"{row['identity']} relative {start}:{end}"
    elif args.address:
        address_match = ADDRESS_RE.fullmatch(args.address)
        if not address_match:
            raise ValueError("--address must be hexadecimal")
        address = int(address_match.group(1), 16)
        if address == int(row["original_address"], 16):
            start = 1
        else:
            label_re = re.compile(rf"^\s*(?:LAB_|loc_)0*{address:x}\s*:", re.IGNORECASE)
            hits = [index for index, line in enumerate(body, 1) if label_re.search(line)]
            if len(hits) != 1:
                reason = "ambiguous" if hits else "unsupported"
                raise LookupError(f"{reason} address-to-source mapping {args.address} within {row['identity']}")
            start = hits[0]
        end = min(len(body), start + args.limit - 1)
        label = f"{row['identity']} address 0x{address:x}"
    else:
        needle = args.block.casefold()
        label_pattern = re.compile(r"^\s*(?:LAB_[0-9A-Fa-f]+|[A-Za-z_]\w*):")
        hits = [
            index for index, line in enumerate(body, 1)
            if needle in line.casefold() and (label_pattern.search(line) or "block" in line.casefold())
        ]
        if len(hits) != 1:
            reason = "ambiguous" if hits else "not found"
            raise LookupError(f"named block {args.block!r} {reason} in {row['identity']}")
        start = hits[0]
        next_labels = [
            index for index, line in enumerate(body[start:], start + 1)
            if label_pattern.search(line)
        ]
        end = min(next_labels[0] - 1 if next_labels else len(body), start + args.limit - 1)
        label = f"{row['identity']} block {args.block}"
    selected = body[start - 1:end]
    actual_start = absolute_start + start - 1
    print_slice(path, selected, actual_start, actual_start + len(selected) - 1, label)
    return 0


def call_names(row: dict[str, Any]) -> set[str]:
    return {row["original_function"], row["semantic_name"]}


def cmd_callers(args: argparse.Namespace) -> int:
    target = registry().resolve(args.query, args.segment)
    names = call_names(target)
    hits: list[str] = []
    for caller in registry().rows:
        path, body, start, _ = source_lines(caller)
        masked = mask_comments("\n".join(body)).splitlines()
        for offset, line in enumerate(masked):
            if any(re.search(rf"\b{re.escape(name)}\s*\(", line) for name in names):
                if caller["identity"] == target["identity"] and offset == 0:
                    continue
                hits.append(
                    f"{relative(path)}:{start + offset}:DIRECT_TEXTUAL_CALL:{caller['identity']}"
                    f"/{caller['semantic_name']}: {body[offset].strip()}"
                )
    for hit in hits[:args.limit]:
        print(hit)
    if len(hits) > args.limit:
        print(f"... {len(hits) - args.limit} more; rerun with --limit {len(hits)}")
    return 0


def cmd_callees(args: argparse.Namespace) -> int:
    caller = registry().resolve(args.query, args.segment)
    path, body, start, _ = source_lines(caller)
    masked = mask_comments("\n".join(body))
    by_name: dict[str, list[dict[str, Any]]] = {}
    for row in registry().rows:
        for name in call_names(row):
            by_name.setdefault(name, []).append(row)
    hits: list[tuple[int, str, str]] = []
    for offset, line in enumerate(masked.splitlines()):
        for name in CALL_RE.findall(line):
            if name in CONTROL_WORDS or name == caller["semantic_name"] and offset == 0:
                continue
            matches = by_name.get(name, [])
            if len(matches) > 1:
                identities = ", ".join(row["identity"] for row in matches)
                raise LookupError(f"ambiguous callee {name!r} at {relative(path)}:{start + offset}: {identities}")
            if matches:
                hits.append((start + offset, matches[0]["identity"], body[offset].strip()))
    seen: set[tuple[int, str]] = set()
    for line, identity, source in hits:
        key = (line, identity)
        if key not in seen:
            print(f"{relative(path)}:{line}:DIRECT_TEXTUAL_CALL:{identity}: {source}")
            seen.add(key)
    return 0


def access_for(line: str, name: str) -> str:
    stripped = line.strip()
    if re.search(rf"(?:\+\+|--)\s*{re.escape(name)}|{re.escape(name)}\s*(?:\+\+|--)", stripped):
        return "READ_WRITE"
    assignment = re.search(r"(?<![=!<>])([+\-*/%&|^]?=)(?!=)", stripped)
    if assignment:
        lhs, rhs = stripped[:assignment.start()], stripped[assignment.end():]
        in_lhs, in_rhs = name in lhs, name in rhs
        if in_lhs and (assignment.group(1) != "=" or in_rhs):
            return "READ_WRITE"
        if in_lhs:
            return "WRITE"
        if in_rhs:
            return "READ"
    return "UNKNOWN_ACCESS"


def cmd_globals(args: argparse.Namespace) -> int:
    row = registry().resolve(args.query, args.segment)
    path, body, start, _ = source_lines(row)
    accesses: dict[str, set[str]] = {}
    evidence: dict[str, list[str]] = {}
    masked = mask_comments("\n".join(body)).splitlines()
    for offset, line in enumerate(masked):
        for name in set(GLOBAL_RE.findall(line)):
            access = access_for(line, name)
            accesses.setdefault(name, set()).add(access)
            evidence.setdefault(name, []).append(f"{relative(path)}:{start + offset}")
    selected = []
    for name in sorted(accesses):
        values = sorted(accesses[name])
        if args.access != "all":
            wanted = {"reads": {"READ", "READ_WRITE"}, "writes": {"WRITE", "READ_WRITE"}, "unknown": {"UNKNOWN_ACCESS"}}[args.access]
            if not wanted.intersection(values):
                continue
        selected.append({"name": name, "access": values, "evidence": evidence[name]})
    print(json.dumps({"identity": row["identity"], "source": relative(path), "globals": selected}, indent=2))
    return 0


def cmd_status(args: argparse.Namespace) -> int:
    row = registry().resolve(args.query, args.segment)
    print(json.dumps(correspondence(row, args.detail), indent=2, ensure_ascii=False))
    return 0


def cmd_symbol(args: argparse.Namespace) -> int:
    lines = SYMBOLS.read_text(encoding="utf-8", errors="replace").splitlines()
    hits = [index for index, line in enumerate(lines) if args.query.casefold() in line.casefold()]
    if not hits:
        raise LookupError(f"no symbol record found: {args.query}")
    shown: set[int] = set()
    for hit in hits[:args.limit]:
        for index in range(max(0, hit - args.context), min(len(lines), hit + args.context + 1)):
            if index not in shown:
                print(f"{relative(SYMBOLS)}:{index + 1}:{lines[index]}")
                shown.add(index)
    return 0


def cmd_source_map(args: argparse.Namespace) -> int:
    row = registry().resolve(args.query, args.segment)
    mapping = row.get("strict_port")
    if not mapping:
        print(f"{row['identity']}: no strict-port translation")
        return 1
    print(json.dumps(mapping, indent=2, sort_keys=True))
    return 0


def gdscript_functions(path: Path) -> tuple[list[str], list[dict[str, Any]]]:
    lines = path.read_text(encoding="utf-8", errors="strict").splitlines()
    starts: list[tuple[int, str]] = []
    pattern = re.compile(r"^(?:static\s+)?func\s+([A-Za-z_]\w*)\s*\(")
    for number, line in enumerate(lines, 1):
        match = pattern.match(line)
        if match:
            starts.append((number, match.group(1)))
    if not starts:
        raise ValueError(f"no top-level GDScript functions in {relative(path)}")
    functions = []
    for index, (start, name) in enumerate(starts):
        end = starts[index + 1][0] - 1 if index + 1 < len(starts) else len(lines)
        while end > start and (not lines[end - 1].strip() or lines[end - 1].startswith("#")):
            end -= 1
        if end == start or not any(line.startswith(("\t", " ")) and line.strip() for line in lines[start:end]):
            raise ValueError(f"ambiguous/empty GDScript body at {relative(path)}:{start}")
        functions.append({"name": name, "start": start, "end": end, "lines": lines[start - 1:end]})
    return lines, functions


def find_test_file(query: str) -> Path:
    normalized = query.removesuffix(".gd")
    matches = [path for path in sorted((ROOT / "godot" / "tests").rglob("*.gd")) if path.stem == normalized]
    if not matches:
        raise LookupError(f"canonical GDScript test file not found: {query}")
    if len(matches) > 1:
        paths = ", ".join(relative(path) for path in matches)
        raise LookupError(f"ambiguous test file {query!r}: {paths}")
    return matches[0]


def cmd_tests(args: argparse.Namespace) -> int:
    path = find_test_file(args.query)
    lines, functions = gdscript_functions(path)
    by_name = {function["name"]: function for function in functions}
    if args.case not in by_name:
        candidates = [name for name in by_name if args.case.casefold() in name.casefold()]
        suffix = f"; partial matches: {', '.join(candidates)}" if candidates else ""
        raise LookupError(f"test case {args.case!r} not found in {relative(path)}{suffix}")
    selected = by_name[args.case]
    masked = mask_comments("\n".join(selected["lines"]))
    dependencies = []
    for name in dict.fromkeys(CALL_RE.findall(masked)):
        if name in by_name and name != args.case:
            dependencies.append(by_name[name])
    preamble_end = functions[0]["start"] - 1
    while preamble_end and not lines[preamble_end - 1].strip():
        preamble_end -= 1
    chunks: list[tuple[str, int, int, list[str]]] = []
    if preamble_end:
        chunks.append(("module setup", 1, preamble_end, lines[:preamble_end]))
    chunks.append(("selected test", selected["start"], selected["end"], selected["lines"]))
    for dependency in dependencies:
        chunks.append(("direct helper", dependency["start"], dependency["end"], dependency["lines"]))
    fixture_pattern = re.compile(r"res://[^\"']+")
    fixtures = sorted({match for _, _, _, chunk in chunks for match in fixture_pattern.findall("\n".join(chunk))})
    print(f"// test file: {relative(path)}; case: {args.case}; direct helpers: {len(dependencies)}")
    if fixtures:
        print("// fixtures: " + ", ".join(fixtures))
    for label, start, end, chunk in chunks:
        print_slice(path, chunk, start, end, label)
    return 0


def add_function_query(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("query")
    parser.add_argument("--segment")


def parser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__)
    sub = ap.add_subparsers(dest="command", required=True)
    command = sub.add_parser("function", help="print one reconstructed C function")
    add_function_query(command); command.add_argument("--detail", action="store_true"); command.set_defaults(func=cmd_function)
    command = sub.add_parser("correspondence", help="show original/reconstruction/strict-port correspondence")
    add_function_query(command); command.add_argument("--detail", action="store_true"); command.set_defaults(func=cmd_correspondence)
    command = sub.add_parser("excerpt", help="print a bounded relative line, address, or named-block excerpt")
    add_function_query(command)
    group = command.add_mutually_exclusive_group(required=True)
    group.add_argument("--lines"); group.add_argument("--address"); group.add_argument("--block")
    command.add_argument("--limit", type=int, default=40); command.set_defaults(func=cmd_excerpt)
    command = sub.add_parser("callers", help="print direct textual call sites")
    add_function_query(command); command.add_argument("--limit", type=int, default=40); command.set_defaults(func=cmd_callers)
    command = sub.add_parser("callees", help="print direct reconstructed callees")
    add_function_query(command); command.set_defaults(func=cmd_callees)
    command = sub.add_parser("globals", help="list globals and conservative access direction")
    add_function_query(command); command.add_argument("--access", choices=("all", "reads", "writes", "unknown"), default="all"); command.set_defaults(func=cmd_globals)
    command = sub.add_parser("status", help="show canonical reconstruction status")
    add_function_query(command); command.add_argument("--detail", action="store_true"); command.set_defaults(func=cmd_status)
    command = sub.add_parser("symbol", help="search the symbol reference")
    command.add_argument("query"); command.add_argument("--context", type=int, default=1); command.add_argument("--limit", type=int, default=10); command.set_defaults(func=cmd_symbol)
    command = sub.add_parser("source-map", help="show strict-port mapping for one function")
    add_function_query(command); command.set_defaults(func=cmd_source_map)
    command = sub.add_parser("tests", help="print one GDScript test case plus direct dependencies")
    command.add_argument("query"); command.add_argument("--case", required=True); command.set_defaults(func=cmd_tests)
    return ap


def main() -> int:
    args = parser().parse_args()
    try:
        return args.func(args)
    except (LookupError, ValueError, KeyError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
