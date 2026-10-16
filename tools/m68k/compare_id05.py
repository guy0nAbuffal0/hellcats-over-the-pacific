#!/usr/bin/env python3
"""Build ID05 disassembly comparison JSON against known Ghidra landmarks."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
ID05 = REPO / "hellcats-over-the-pacific-sources/ResEdit/CODE/ID05.bin"
OUT = REPO / "artifacts/reverse-engineering/id05"


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    disasm_json = OUT / "disassembly-capstone.json"
    subprocess.check_call(
        [
            sys.executable,
            str(REPO / "tools/m68k/disasm_region.py"),
            str(ID05),
            "-o",
            str(disasm_json),
            "--range",
            "0x6:0x80",
            "--range",
            "0x720:0x760",
        ]
    )
    data = json.loads(disasm_json.read_text())
    blob = ID05.read_bytes()

    # Landmarks from LOADER_CHAIN / ID05.c
    landmarks = {
        "header_u16": int.from_bytes(blob[0:2], "big"),
        "bytes_0_5_hex": blob[0:6].hex(),
        "link_at_6": blob[6:8].hex() == "4e56",
        "rts_at_4": blob[4:6].hex() == "4e75",
        "lcg_mul_offset": blob.find(bytes.fromhex("41c64e6d")),
        "lcg_add_near": None,
        "ghidra_fun_00000728": {
            "label": "FUN_00000728",
            "ghidra_address": "0x728",
            "note": "Ghidra C naming; LCG immediates at 0x730/0x738",
        },
    }
    mul = landmarks["lcg_mul_offset"]
    if mul >= 0:
        landmarks["lcg_add_near"] = blob.find(bytes.fromhex("3039"), max(0, mul - 8), mul + 16)

    # Capstone view around RNG
    rng_range = next(r for r in data["ranges"] if r["start"] == 0x720)
    caps = rng_range["capstone"]
    # Find insn covering 0x728 if present
    at_728 = [i for i in caps if i["offset"] <= 0x728 < i["offset"] + i["size"]]
    comparison_rows = []
    for insn in caps:
        row = {
            "binary_offset": hex(insn["offset"]),
            "address": hex(insn["address"]),
            "bytes": insn["bytes"],
            "capstone": insn["text"],
            "ghidra": None,
            "m68k_disasm": None,
            "agreement": "capstone-only",
            "uncertainty": "Ghidra listing not exported programmatically in this run; landmarks from ID05.c",
        }
        if insn["offset"] == 0x6:
            row["ghidra"] = "LINK A6,#… (FUN_00000006 entry)"
            row["agreement"] = "strong-inference"
        if 0x728 <= insn["offset"] < 0x746:
            row["ghidra"] = "inside FUN_00000728 (ID05.c)"
            row["agreement"] = "strong-inference"
        if insn["bytes"].startswith("41c64e6d") or "41c64e6d" in insn["bytes"]:
            row["ghidra"] = "LCG multiply immediate 0x41c64e6d"
            row["agreement"] = "proven-bytes"
        comparison_rows.append(row)

    # Attach m68k-disasm raw lines for same region
    m68_lines = rng_range.get("m68k_disasm") or []
    for i, row in enumerate(comparison_rows):
        if i < len(m68_lines):
            row["m68k_disasm"] = m68_lines[i].get("raw")
            if row["m68k_disasm"] and row["capstone"]:
                # crude token overlap
                row["agreement"] = (
                    "engines-present"
                    if row["agreement"] == "capstone-only"
                    else row["agreement"]
                )

    report = {
        "schema": "hellcats-id05-disassembly-comparison-v1",
        "id05_sha256": hashlib.sha256(blob).hexdigest(),
        "landmarks": landmarks,
        "capstone_at_728": at_728,
        "rows": comparison_rows,
        "source_disassembly": str(disasm_json),
    }
    out = OUT / "disassembly-comparison.json"
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(f"wrote {out} rows={len(comparison_rows)} mul@{hex(mul) if mul>=0 else None}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
