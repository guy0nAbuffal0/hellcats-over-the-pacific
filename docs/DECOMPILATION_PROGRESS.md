# C-to-C reconstruction checkpoint

This is the live checkpoint for focused reconstruction. The 345-iteration
ledger and former 705-row Markdown tracker are preserved as historical evidence
in [`research/DECOMPILATION_HISTORY.md`](research/DECOMPILATION_HISTORY.md), but
must not be loaded wholesale for routine work.

**Last iteration:** 361 (2026-10-18)
**Next target:** decide with the user whether functions whose bodies match the
bytes but whose Ghidra calls lost their stack arguments (approx_dist3_xyz,
segment_point_min_distance, bullet_hits_*, flak_notice_object) may be marked
VERIFIED once the argument lists are documented; meanwhile continue with
`apply_random_aircraft_damage` (FUN_00016724) byte verification.

## Current coverage

Run `python3 tools/progress_stats.py` for current orthogonal reconstruction,
strict-port, and resource counts. The segment-qualified canonical records live
in [`DECOMPILATION_INVENTORY.json`](DECOMPILATION_INVENTORY.json); statuses are
reconstruction workflow states, not Godot coverage. The strict-port manifest is
the sole authoritative C-to-GDScript mapping.

## Canonical sources

- Immutable Ghidra exports: `sources/resedit/CODE/*.c`
- Semantic reconstructions: `sources/resedit/CODE/*.decomp.c`
- Function inventory: `DECOMPILATION_INVENTORY.json`
- Symbols, globals, fields, and confidence: `DECOMPILATION_SYMBOLS.md`
- Immutable-source hashes: `DECOMPILATION_PROTECTED_CHECKSUMS.sha256`
- Strict C-to-GDScript mappings: `godot/strict_port/mappings/functions.json`
- Historical tracker and iteration evidence: `research/DECOMPILATION_HISTORY.md`

Source-local provenance comments remain authoritative evidence and must not be
removed merely because the same identity is retrievable elsewhere.

## Focused iteration

1. Inspect `git status --short`; do not overwrite unrelated edits.
2. Select one target from this checkpoint.
3. Retrieve only the needed evidence with `tools/re_query.py`; use `tools/resedit.py`
   for one resource type/ID at a time.
4. Compare the original `.c`, the selected `.decomp.c` function, direct callers,
   globals, and binary/disassembly evidence. Do not load unrelated full files.
5. Make one evidence-backed change. Preserve original identifiers, widths,
   arithmetic, conditions, memory layouts, and unresolved annotations.
6. Run targeted validation. Update the symbol registry and this checkpoint only
   when their live facts change. Add historical narrative to the archive only
   when it supplies unique evidence.
7. Periodically, and before handoff, run the full validation listed in `README.md`.

Useful retrieval examples:

```sh
python3 tools/re_query.py function FUN_0000e792
python3 tools/re_query.py excerpt --segment "Pacific Conflict" FUN_0000e792 --address 0xf47c
python3 tools/re_query.py callers FUN_0000e792
python3 tools/re_query.py callees --segment "Pacific Conflict" FUN_0000e792
python3 tools/re_query.py globals FUN_0000e792
python3 tools/re_query.py status FUN_0000e792
python3 tools/re_query.py tests test_flight_math --case _test_fun_0000e42a
python3 tools/re_query.py symbol DAT_00026004
python3 tools/re_query.py source-map FUN_0001358c
```

## Priority queue

1. Verify `bullet_hits_aircraft` described above (`tick_bullet` verified in
   iteration 353).
2. Revisit the blocked `$1A48` allocator ABI.
3. Continue independent verification of high-traffic Pacific Conflict functions.
4. Resolve remaining ID09/ID05 segment-entry evidence.
5. Investigate `FUN_00003cca` only when its dependencies are needed.

Do not recreate existing outputs, touch gameplay code during a reconstruction
iteration, commit, or push. A recurring loop should operate on this checkpoint
and one narrow target; it must not reread the historical ledger every five minutes.
