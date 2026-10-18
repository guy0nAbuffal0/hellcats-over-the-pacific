# C-to-C reconstruction checkpoint

This is the concise entry point for focused semantic reconstruction.

**Next target:** `FUN_00010b2e` (steer_entity_toward_point), the caller that chains
build_relative_steer_sample -> apply_relative_heading_steer: verify it against the bytes
and confirm which outputs feed apply_relative_heading_steer's param_4 / param_5.

The angle path feeding `attitude_from_velocity` is established:
`acos_fixed14` and `atan_fixed14` match independent disassembly, and their
cosine/tangent lookup-table scales are recorded in the symbol reference.

A function may be marked `VERIFIED` when its body matches an independent
disassembly of the bytes and every call argument omitted by Ghidra is recorded
as a call-argument correction in
[`DECOMPILATION_SYMBOLS.md`](DECOMPILATION_SYMBOLS.md).

## Current coverage

Run `python3 tools/progress_stats.py` for current orthogonal reconstruction,
strict-port, and resource counts. The segment-qualified canonical records live
in [`DECOMPILATION_INVENTORY.json`](DECOMPILATION_INVENTORY.json); statuses are
reconstruction states, not Godot coverage. The strict-port manifest is the sole
authoritative C-to-GDScript mapping.

## Canonical sources

- Immutable Ghidra exports: `sources/resedit/CODE/*.c`
- Semantic reconstructions: `sources/resedit/CODE/*.decomp.c`
- Function inventory: `DECOMPILATION_INVENTORY.json`
- Symbols, globals, fields, and confidence: `DECOMPILATION_SYMBOLS.md`
- Immutable-source hashes: `DECOMPILATION_PROTECTED_CHECKSUMS.sha256`
- Strict C-to-GDScript mappings: `godot/strict_port/mappings/functions.json`

Source-local provenance comments remain authoritative evidence and must not be
removed merely because the same identity is retrievable elsewhere.

## Focused reconstruction

1. Inspect `git status --short`; do not overwrite unrelated edits.
2. Select one target from this checkpoint.
3. Retrieve only the required function, excerpt, callers, callees, globals, and
   test case with `tools/re_query.py`.
4. Compare the immutable `.c`, semantic `.decomp.c`, and independent
   binary/disassembly evidence.
5. Preserve identifiers, widths, arithmetic, conditions, layouts, and
   unresolved annotations in every evidence-backed edit.
6. Regenerate the inventory and run targeted checks, followed by the validation
   in `README.md` before handoff.

## Priority queue

1. Verify `bullet_hits_aircraft`; its caller `tick_bullet` is already verified.
2. Continue independent verification of high-traffic Pacific Conflict functions.
3. Resolve remaining ID09/ID05 segment-entry evidence.
4. Investigate `FUN_00003cca` only when its dependencies are needed.

The `$1A48` allocator ABI is resolved: the runtime address maps to `heap_alloc`
at file offset `0x1a68`.
