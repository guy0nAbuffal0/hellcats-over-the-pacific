#!/usr/bin/env python3
"""Retrieve one reverse-engineering fact without loading project-wide reports."""

from __future__ import annotations

import sys

import argparse
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CODE = ROOT / "sources" / "resedit" / "CODE"
PROGRESS_FILES = (
    ROOT / "docs" / "DECOMPILATION_PROGRESS.md",
    ROOT / "docs" / "research" / "DECOMPILATION_HISTORY.md",
)
SYMBOLS = ROOT / "docs" / "DECOMPILATION_SYMBOLS.md"
STRICT_MAP = ROOT / "godot" / "strict_port" / "mappings" / "functions.json"


def decomp_files() -> list[Path]:
    return sorted(CODE.glob("*.decomp.c"))


def definition_start(text: str, query: str) -> int | None:
    original = re.compile(
        rf"^[^\n;]*\([^;\n]*\)\s*/\*\s*Original:\s*{re.escape(query)}\s*\*/[^\n]*$",
        re.MULTILINE,
    )
    semantic = re.compile(
        rf"^[^\n;/]*\b{re.escape(query)}\s*(?:/\*[^\n]*\*/\s*)?\([^;\n]*$",
        re.MULTILINE,
    )
    for pattern in (original, semantic):
        match = pattern.search(text)
        if match:
            return match.start()
    return None


def extract_definition(text: str, query: str) -> str | None:
    start = definition_start(text, query)
    if start is None:
        return None
    brace = text.find("{", start)
    if brace < 0:
        return None
    depth = 0
    for index in range(brace, len(text)):
        if text[index] == "{":
            depth += 1
        elif text[index] == "}":
            depth -= 1
            if depth == 0:
                return text[start:index + 1]
    return None


def find_definition(query: str) -> tuple[Path, str]:
    for path in decomp_files():
        text = path.read_text(encoding="utf-8", errors="replace")
        body = extract_definition(text, query)
        if body:
            return path, body
    raise LookupError(f"function not found in reconstructed sources: {query}")


def cmd_function(args: argparse.Namespace) -> int:
    path, body = find_definition(args.query)
    print(f"// {path.relative_to(ROOT)}")
    print(body)
    return 0


def cmd_callers(args: argparse.Namespace) -> int:
    definition_path, body = find_definition(args.query)
    names = {args.query}
    match = re.search(r"Original:\s*(FUN_[0-9A-Fa-f]+)", body)
    if match:
        names.add(match.group(1))
    signature = body.split("{", 1)[0]
    for token in re.findall(r"\b(?:FUN_[0-9A-Fa-f]+|[A-Za-z_]\w+)\s*(?=\()", signature):
        if token not in {"if", "for", "while", "switch"}:
            names.add(token)
    hits: list[str] = []
    for path in decomp_files():
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        definitions: list[tuple[int, str]] = []
        for index, line in enumerate(lines, 1):
            if (
                "Original: FUN_" not in line
                or line[:1].isspace()
                or line.lstrip().startswith(("*", "//"))
            ):
                continue
            prefix = line.split("/* Original:", 1)[0]
            if ";" in prefix:
                continue
            found = re.search(r"\b([A-Za-z_]\w+)\s*$", prefix.split("(", 1)[0].rstrip())
            if found:
                definitions.append((index, found.group(1)))
        for number, line in enumerate(lines, 1):
            if not any(re.search(rf"\b{re.escape(name)}\s*\(", line) for name in names):
                continue
            if line.lstrip().startswith(("*", "//")):
                continue
            caller = next((name for index, name in reversed(definitions) if index <= number), "<global>")
            if path == definition_path and caller in names:
                continue
            hits.append(f"{path.relative_to(ROOT)}:{number}:{caller}: {line.strip()}")
    for hit in hits[: args.limit]:
        print(hit)
    if len(hits) > args.limit:
        print(f"... {len(hits) - args.limit} more; rerun with --limit {len(hits)}")
    return 0


def cmd_globals(args: argparse.Namespace) -> int:
    path, body = find_definition(args.query)
    names = sorted(set(re.findall(r"\b_?DAT_[0-9A-Fa-f]+\b", body)))
    print(json.dumps({"source": str(path.relative_to(ROOT)), "function": args.query, "globals": names}, indent=2))
    return 0


def cmd_status(args: argparse.Namespace) -> int:
    for path in PROGRESS_FILES:
        if not path.is_file():
            continue
        for number, line in enumerate(path.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            if line.startswith("|") and args.query in line:
                print(f"{path.relative_to(ROOT)}:{number}:{line}")
                return 0
    raise LookupError(f"no progress row found: {args.query}")


def cmd_symbol(args: argparse.Namespace) -> int:
    lines = SYMBOLS.read_text(encoding="utf-8", errors="replace").splitlines()
    hits = [i for i, line in enumerate(lines) if args.query.casefold() in line.casefold()]
    if not hits:
        raise LookupError(f"no symbol record found: {args.query}")
    shown: set[int] = set()
    for hit in hits[: args.limit]:
        for index in range(max(0, hit - args.context), min(len(lines), hit + args.context + 1)):
            if index not in shown:
                print(f"{SYMBOLS.relative_to(ROOT)}:{index + 1}:{lines[index]}")
                shown.add(index)
    return 0


def cmd_source_map(args: argparse.Namespace) -> int:
    rows = json.loads(STRICT_MAP.read_text(encoding="utf-8")).get("functions", [])
    matches = [
        row for row in rows
        if args.query in {row.get("source_function"), row.get("original_function"), row.get("target_function")}
    ]
    print(json.dumps(matches, indent=2, sort_keys=True))
    return 0 if matches else 1


def parser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__)
    sub = ap.add_subparsers(dest="command", required=True)
    p = sub.add_parser("function", help="print one reconstructed C function")
    p.add_argument("query"); p.set_defaults(func=cmd_function)
    p = sub.add_parser("callers", help="print direct textual call sites")
    p.add_argument("query"); p.add_argument("--limit", type=int, default=40); p.set_defaults(func=cmd_callers)
    p = sub.add_parser("globals", help="list DAT_* names referenced by one function")
    p.add_argument("query"); p.set_defaults(func=cmd_globals)
    p = sub.add_parser("status", help="print one reconstruction tracker row")
    p.add_argument("query"); p.set_defaults(func=cmd_status)
    p = sub.add_parser("symbol", help="search the canonical symbol reference")
    p.add_argument("query"); p.add_argument("--context", type=int, default=1); p.add_argument("--limit", type=int, default=10); p.set_defaults(func=cmd_symbol)
    p = sub.add_parser("source-map", help="print strict-port mapping rows")
    p.add_argument("query"); p.set_defaults(func=cmd_source_map)
    return ap


def main() -> int:
    args = parser().parse_args()
    try:
        return args.func(args)
    except (LookupError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
