#!/usr/bin/env python3
"""Disassemble selected regions of a big-endian m68k CODE binary with Capstone.

Optionally cross-check with Oxore m68k-disasm if available.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

try:
    from capstone import CS_ARCH_M68K, CS_MODE_BIG_ENDIAN, Cs
except ImportError:
    print("capstone required", file=sys.stderr)
    raise SystemExit(2)


def disasm_capstone(blob: bytes, base: int, start: int, end: int) -> list[dict]:
    md = Cs(CS_ARCH_M68K, CS_MODE_BIG_ENDIAN)
    md.detail = False
    region = blob[start:end]
    out = []
    for insn in md.disasm(region, base + start):
        out.append(
            {
                "address": insn.address,
                "offset": insn.address - base,
                "size": insn.size,
                "bytes": insn.bytes.hex(),
                "mnemonic": insn.mnemonic,
                "op_str": insn.op_str,
                "text": f"{insn.mnemonic} {insn.op_str}".strip(),
                "engine": "capstone",
            }
        )
    return out


def disasm_m68k_disasm(tool: Path, blob: bytes, start: int, end: int) -> list[dict]:
    """Run Oxore m68k-disasm on a temp file containing only the region.

    Addresses in output are relative to the temp file (0-based for the region).
    """
    region = blob[start:end]
    with tempfile.NamedTemporaryFile(suffix=".bin", delete=False) as tf:
        tf.write(region)
        tmp = Path(tf.name)
    try:
        proc = subprocess.run(
            [str(tool), str(tmp)],
            capture_output=True,
            text=True,
            check=False,
        )
        lines = (proc.stdout or "").splitlines()
        out = []
        for line in lines:
            # Typical: "00000000: 4e56 fff4     link.w a6,#-12" or similar — parse loosely
            line = line.strip()
            if not line or line.startswith(";"):
                continue
            out.append({"raw": line, "engine": "m68k-disasm", "region_start": start})
        return out
    finally:
        tmp.unlink(missing_ok=True)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("binary", type=Path)
    ap.add_argument("-o", "--output", type=Path, required=True)
    ap.add_argument("--base", type=lambda x: int(x, 0), default=0)
    ap.add_argument(
        "--range",
        action="append",
        default=[],
        metavar="START:END",
        help="File offset range (hex or dec). Repeatable.",
    )
    ap.add_argument(
        "--m68k-disasm",
        type=Path,
        default=Path("/Users/math/Sites/tests/m68k-disasm/m68k-disasm"),
    )
    args = ap.parse_args()
    blob = args.binary.read_bytes()
    ranges = []
    for spec in args.range or ["0x6:0x80", "0x720:0x760"]:
        a, b = spec.split(":")
        ranges.append((int(a, 0), int(b, 0)))

    result = {
        "schema": "hellcats-m68k-disasm-v1",
        "binary": str(args.binary),
        "sha256": hashlib.sha256(blob).hexdigest(),
        "size": len(blob),
        "base": args.base,
        "capstone_version": __import__("capstone").__version__,
        "ranges": [],
    }
    tool = args.m68k_disasm if args.m68k_disasm.is_file() else None
    if tool is None:
        which = shutil.which("m68k-disasm")
        tool = Path(which) if which else None

    for start, end in ranges:
        block = {
            "start": start,
            "end": end,
            "capstone": disasm_capstone(blob, args.base, start, end),
            "m68k_disasm": disasm_m68k_disasm(tool, blob, start, end) if tool else [],
            "m68k_disasm_available": bool(tool),
        }
        result["ranges"].append(block)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
