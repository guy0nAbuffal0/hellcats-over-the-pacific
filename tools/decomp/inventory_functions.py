#!/usr/bin/env python3
"""Inventory FUN_* symbols from protected Ghidra C exports (read-only)."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

FUN_RE = re.compile(
    r"^(?P<ret>[^\n;{]+?)\s+(?P<name>FUN_[0-9a-fA-F]+)\s*\(",
    re.MULTILINE,
)


def inventory_file(path: Path) -> list[dict]:
    text = path.read_text(encoding="utf-8", errors="replace")
    rows = []
    for m in FUN_RE.finditer(text):
        rows.append(
            {
                "name": m.group("name"),
                "return_type_raw": m.group("ret").strip(),
                "file": path.name,
                "char_offset": m.start(),
                "confidence": "UNKNOWN",
                "note": "Parsed from Ghidra C export; not a historical source name",
            }
        )
    return rows


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--code-dir",
        type=Path,
        default=Path("hellcats-over-the-pacific-sources/ResEdit/CODE"),
    )
    ap.add_argument("-o", "--output", type=Path, required=True)
    args = ap.parse_args()
    files = sorted(args.code_dir.glob("ID*.c")) + sorted(
        args.code_dir.glob("Pacific Conflict.c")
    )
    # Exclude .decomp.c
    files = [f for f in files if not f.name.endswith(".decomp.c")]
    all_rows = []
    by_file = {}
    for f in files:
        rows = inventory_file(f)
        by_file[f.name] = len(rows)
        all_rows.extend(rows)
    out = {
        "schema": "hellcats-decomp-function-inventory-v1",
        "code_dir": str(args.code_dir),
        "file_counts": by_file,
        "function_count": len(all_rows),
        "functions": all_rows,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(out, indent=2, sort_keys=True) + "\n")
    print(f"wrote {args.output} functions={len(all_rows)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
