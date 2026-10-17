# C-to-C reconstruction checkpoint

This is the live checkpoint for focused reconstruction. The 345-iteration
ledger and former 705-row Markdown tracker are preserved as historical evidence
in [`research/DECOMPILATION_HISTORY.md`](research/DECOMPILATION_HISTORY.md), but
must not be loaded wholesale for routine work.

**Last iteration:** 347 (2026-10-18)
**Next target:** name the aircraft control inputs `+0x662` / `+0x664` / `+0x666`
(stick axes, with the ±0x40 jitter when damage bits are set) from
`apply_player_mouse_controls` and the AI controllers.

## Current coverage

| Source | Inventoried | Renamed | Verified | Blocked |
|---|---:|---:|---:|---:|
| ID01.c | 6 | 6 | 0 | 0 |
| ID02.c | 125 | 125 | 0 | 0 |
| ID03.c | 45 | 45 | 0 | 0 |
| ID04.c | 59 | 59 | 0 | 0 |
| ID05.c | 24 | 24 | 0 | 0 |
| ID06.c | 24 | 24 | 0 | 0 |
| ID07.c | 2 | 2 | 0 | 0 |
| ID08.c | 4 | 4 | 0 | 0 |
| ID09.c | 4 | 4 | 0 | 0 |
| Pacific Conflict.c | 443 | 381 | 56 | 6 |
| **Total** | **736** | **674** | **56** | **6** |

The inventory count comes from
[`DECOMPILATION_INVENTORY.json`](DECOMPILATION_INVENTORY.json). Statuses are
reconstruction workflow states, not Godot coverage; 674 renamed functions still
require independent verification. The strict-port manifest currently maps three
functions and is the sole authoritative C-to-GDScript mapping.

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
python3 tools/re_query.py callers FUN_0000e792
python3 tools/re_query.py globals FUN_0000e792
python3 tools/re_query.py status FUN_0000e792
python3 tools/re_query.py symbol DAT_00026004
python3 tools/re_query.py source-map FUN_0001358c
```

## Priority queue

1. Name the aircraft control inputs described above (aircraft records 1–4 and
   type-record fields `+0x36..+0x48` were settled in iterations 346–347).
2. Revisit the blocked `$1A48` allocator ABI.
3. Continue independent verification of high-traffic Pacific Conflict functions.
4. Resolve remaining ID09/ID05 segment-entry evidence.
5. Investigate `FUN_00003cca` only when its dependencies are needed.

Do not recreate existing outputs, touch gameplay code during a reconstruction
iteration, commit, or push. A recurring loop should operate on this checkpoint
and one narrow target; it must not reread the historical ledger every five minutes.
