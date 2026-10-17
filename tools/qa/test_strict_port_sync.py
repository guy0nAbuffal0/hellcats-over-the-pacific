#!/usr/bin/env python3
"""Tests for strict-port mapping validation and source-change detection."""

from __future__ import annotations

import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = REPO_ROOT / "tools/strict_port/check_sync.py"
SPEC = importlib.util.spec_from_file_location("strict_port_check_sync", MODULE_PATH)
assert SPEC and SPEC.loader
SYNC = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(SYNC)
MANIFEST = REPO_ROOT / "godot/strict_port/mappings/functions.json"


class StrictPortSyncTest(unittest.TestCase):
    def test_current_source_is_synchronized(self) -> None:
        report, errors = SYNC.check(MANIFEST, REPO_ROOT)
        self.assertEqual(errors, [])
        self.assertEqual(report["mapped_functions"], 1)
        self.assertEqual(report["behaviorally_verified"], 1)

    def test_changed_source_is_reported_without_rewriting_manifest(self) -> None:
        manifest_before = MANIFEST.read_bytes()
        mapping = json.loads(MANIFEST.read_text(encoding="utf-8"))["functions"][0]
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            for key in ("source_file", "target_file", "deterministic_test"):
                source = REPO_ROOT / mapping[key]
                target = root / mapping[key]
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(source.read_bytes())
            source_copy = root / mapping["source_file"]
            source_copy.write_text(
                source_copy.read_text(encoding="utf-8").replace(
                    "return param_1 ^ param_2 << 2;",
                    "return param_1 ^ param_2 << 3;",
                    1,
                ),
                encoding="utf-8",
            )
            report, errors = SYNC.check(MANIFEST, root)

        self.assertEqual(report["source_changed"], 1)
        self.assertTrue(any("SOURCE_CHANGED" in error for error in errors))
        self.assertEqual(MANIFEST.read_bytes(), manifest_before)


if __name__ == "__main__":
    unittest.main()
