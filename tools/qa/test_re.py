#!/usr/bin/env python3
"""Regression checks for targeted reverse-engineering retrieval."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TOOL = ROOT / "tools" / "re_query.py"


def run(*args: str) -> str:
    result = subprocess.run(
        [sys.executable, str(TOOL), *args], cwd=ROOT, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True,
    )
    return result.stdout


def main() -> int:
    function = run("function", "FUN_0000e42a")
    assert "table_lerp_1b2c0" in function and "Original: FUN_0000e42a" in function
    assert "DAT_0001b2c0" in run("globals", "table_lerp_1b2c0")
    assert "update_aircraft_entity" in run("callers", "table_lerp_1b2c0")
    assert "VERIFIED" in run("status", "FUN_0000e42a")
    assert "altitude curve" in run("symbol", "DAT_0001b2c0")
    assert "contact_pair_hash" in run("source-map", "FUN_0001358c")
    print("PASS targeted reverse-engineering retrieval")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
