#!/usr/bin/env python3
"""Regression tests for deterministic ResEdit enrichment."""

from __future__ import annotations

import hashlib
import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools import resedit  # noqa: E402


class ResEditMetadataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.records, cls.errors = resedit.build_records(write=False)
        cls.by_key = {r["resource"]["key"]: r for r in cls.records}

    def test_complete_curated_inventory(self) -> None:
        self.assertEqual([], self.errors)
        self.assertEqual(119, len(self.records))
        self.assertEqual(resedit.REQUIRED_TYPES, list(dict.fromkeys(
            r["resource"]["type"] for r in self.records)))
        self.assertEqual(30, len(resedit.REQUIRED_TYPES))
        inventory = json.loads((resedit.RESEDIT / "inventory.json").read_text(encoding="utf-8"))
        self.assertEqual(resedit.inventory_document(self.records), inventory)
        self.assertEqual(12, inventory["supporting_file_count"])

    def test_every_resource_has_matching_binary_and_metadata(self) -> None:
        for record in self.records:
            typ = record["resource"]["type"]
            rid = record["resource"]["id"]
            stem = resedit.output_stem(typ, rid)
            metadata = resedit.RESEDIT / typ / f"{stem}.json"
            binary = ROOT / record["evidence"]["binary_path"]
            self.assertTrue(metadata.is_file(), metadata)
            self.assertTrue(binary.is_file(), binary)
            self.assertEqual(record, json.loads(metadata.read_text(encoding="utf-8")))
            self.assertEqual(record["evidence"]["sha256"], hashlib.sha256(binary.read_bytes()).hexdigest())

    def test_decoders_and_claim_statuses(self) -> None:
        allowed = {"PROVEN", "VERIFIED", "INFERRED", "UNKNOWN"}
        for record in self.records:
            self.assertTrue(set(record["claims"].values()) <= allowed)
            decoded = record["decoded"]
            self.assertEqual(record["evidence"]["binary_size"],
                             decoded["consumed_bytes"] + decoded["trailing_bytes"])
        unknown = {r["resource"]["key"] for r in self.records
                   if r["claims"]["decoded_structure"] == "UNKNOWN"}
        self.assertEqual({"DATA:0", "DITL:135", "MDPL:128"}, unknown)

    def test_core_resource_decodes(self) -> None:
        self.assertEqual(259, self.by_key["ALRT:259"]["decoded"]["properties"]["ditl_id"])
        map_items = self.by_key["DITL:137"]["decoded"]["elements"]
        self.assertEqual(16, len(map_items))
        self.assertEqual("mission map custom drawing region", map_items[7]["descriptive_identity"])
        self.assertEqual(16, len(self.by_key["clut:999"]["decoded"]["elements"]))
        self.assertEqual("#217B31", self.by_key["clut:999"]["decoded"]["elements"][10]["hex_rgb8"])
        self.assertEqual("1.0.3", self.by_key["vers:1"]["decoded"]["properties"]["version"])
        code0 = self.by_key["CODE:0"]["decoded"]
        self.assertEqual(175, code0["properties"]["jump_table_entry_count"])
        self.assertEqual(0x20, code0["elements"][0]["a5_offset"])
        file_menu = self.by_key["MENU:2"]["decoded"]["elements"]
        self.assertEqual("VERIFIED", file_menu[5]["command_handler_status"])
        self.assertIn("mission map", file_menu[5]["command_handler"])
        self.assertEqual("VERIFIED", file_menu[8]["command_handler_status"])

    def test_sound_and_color_icons_are_structural_not_heuristic(self) -> None:
        sound = self.by_key["snds:19330"]["decoded"]["properties"]
        self.assertEqual("none", sound["compression"])
        self.assertEqual(1, sound["channels"])
        self.assertEqual(8, sound["sample_width_bits"])
        self.assertGreater(sound["sample_rate_hz"], 22000)
        self.assertEqual({"load_named_sound_into_slot", "play_named_sound_async"},
                         {x["function_or_context"] for x in self.by_key["snds:19330"]["type_code_references"]})
        for rid in list(range(256, 262)) + list(range(512, 520)):
            comparison = self.by_key[f"cicn:{rid}"]["decoded"]["properties"]["png_pixel_comparison"]
            self.assertEqual("pixel_exact", comparison["status"])
            self.assertEqual(0, comparison["differing_pixels"])
        for key in ("ICON:128", "ICN#:128", "ICN#:129", "ics#:128", "ics#:129"):
            comparison = self.by_key[key]["decoded"]["properties"]["png_pixel_comparison"]
            self.assertEqual("pixel_exact", comparison["status"])
            self.assertEqual(0, comparison["differing_pixels"])

    def test_bidirectional_relationships_resolve(self) -> None:
        for record in self.records:
            source = record["resource"]["key"]
            for link in record["relationships"]["outgoing"]:
                self.assertNotIn("target_status", link)
                target = self.by_key[link["target"]]
                self.assertTrue(any(back["source"] == source and back["kind"] == link["kind"]
                                    for back in target["relationships"]["incoming"]))

    def test_version_provenance_and_truncated_ditl_are_explicit(self) -> None:
        version = self.by_key["vers:1"]
        self.assertFalse(version["evidence"]["binary_matches_resource_fork_payload"])
        self.assertEqual("1.0.4", version["comparison_version_1_0_4"]["decoded"]["properties"]["version"])
        ditl = self.by_key["DITL:135"]
        self.assertFalse(ditl["decoded"]["properties"]["parse_complete"])
        self.assertEqual("TRUNCATED", ditl["decoded"]["elements"][-1]["status"])
        recovered = ditl["comparison_version_1_0_4"]["decoded"]["elements"][-1]
        self.assertEqual("editable_text", recovered["item_type"])
        self.assertEqual("INFERRED", ditl["comparison_version_1_0_4"]["claim_status"])

    def test_code_2_provenance_is_preserved(self) -> None:
        code = self.by_key["CODE:2"]
        self.assertEqual(19994, code["evidence"]["binary_size"])
        self.assertEqual(24832, code["evidence"]["resource_fork_payload_size"])
        self.assertFalse(code["evidence"]["binary_matches_resource_fork_payload"])
        mismatches = {r["resource"]["key"] for r in self.records
                      if not r["evidence"]["binary_matches_resource_fork_payload"]}
        self.assertEqual({"CODE:2", "DITL:135", "HEL1:127", "HEL1:128", "vers:1"}, mismatches)


if __name__ == "__main__":
    unittest.main(verbosity=2)
