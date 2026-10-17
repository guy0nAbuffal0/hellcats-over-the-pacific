#!/usr/bin/env python3
"""Inventory function definitions from protected Ghidra C exports (read-only)."""

from __future__ import annotations

import argparse
import json
import re
from datetime import date
from pathlib import Path

FUN_RE = re.compile(
    r"^(?P<ret>[A-Za-z_][\w\s*]*?)\b(?P<name>[A-Za-z_]\w*)"
    r"\s*\([^;{}]*\)\s*\{",
    re.MULTILINE,
)


def inventory_file(path: Path) -> list[dict]:
    text = path.read_text(encoding="utf-8", errors="replace")
    # Keep offsets and line numbers while excluding commented-out signatures.
    text = re.sub(r"/\*.*?\*/|//[^\n]*",
                  lambda m: re.sub(r"[^\n]", " ", m.group()), text, flags=re.DOTALL)
    rows = []
    for m in FUN_RE.finditer(text):
        rows.append(
            {
                "name": m.group("name"),
                "return": " ".join(m.group("ret").split()),
                "file": path.name,
                "line": text.count("\n", 0, m.start()) + 1,
            }
        )
    return rows


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--code-dir",
        type=Path,
        default=Path("sources/ResEdit/CODE"),
    )
    ap.add_argument("-o", "--output", type=Path, required=True)
    args = ap.parse_args()
    files = [args.code_dir / f"ID{i:02}.c" for i in range(1, 10)]
    files.append(args.code_dir / "Pacific Conflict.c")
    all_rows = []
    by_file = {}
    for f in files:
        rows = inventory_file(f)
        by_file[f.name] = len(rows)
        all_rows.extend(rows)
    # Preserve the checkpoint schema and any per-function annotations.
    out = json.loads(args.output.read_text()) if args.output.exists() else {}
    previous = {(r["file"], r["name"]): r for r in out.get("functions", [])}
    all_rows = [dict(previous.get((r["file"], r["name"]), {}), **r) for r in all_rows]
    out.update(generated=date.today().isoformat(), total=len(all_rows), functions=all_rows)
    if "file_counts" in out:
        out["file_counts"] = by_file
    if "function_count" in out:
        out["function_count"] = len(all_rows)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(out, indent=2) + "\n")
    print(f"wrote {args.output} functions={len(all_rows)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
