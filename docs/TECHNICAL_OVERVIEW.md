# Technical reference map

The repository has two deliberately separate Godot tracks:

- `godot/strict_port/` contains source-faithful translations backed by the
  canonical mapping manifest. Its contract and verification rules live in
  [`STRICT_PORT_FOUNDATION.md`](STRICT_PORT_FOUNDATION.md).
- `godot/hellcats/` contains the playable Mission 01 comparison harness. Its
  authored flight model, world, camera, and UI are not evidence of original
  Macintosh behavior.

The reconstructed C is the behavioral authority for strict work. Immutable
Ghidra exports are under `sources/resedit/CODE/*.c`; semantic counterparts are
the adjacent `*.decomp.c` files. The traceability chain is:

```text
original CODE bytes / immutable .c
    -> semantic .decomp.c with source-local provenance
    -> godot/strict_port/mappings/functions.json
    -> strict-port .gd plus deterministic test
```

## Stable layer boundaries

| Layer | Responsibility | Authority |
|---|---|---|
| Reconstruction | Function names, control flow, fields, unresolved facts | canonical inventory, `.decomp.c`, symbol reference |
| Strict translation | Exact widths, ordering, state, and source hashes | strict-port foundation and mapping manifest |
| Prototype simulation | Playable Mission 01 comparison behavior | explicitly MVP-tagged Godot code and data |
| Integration | Scenes, input collection, rendering, HUD, resource loading | Godot runtime adapters; never original-behavior evidence by itself |
| Resources | Original payloads and deterministic decoding | `sources/resedit/` via `tools/resedit.py` |

`SimCore.tick()` mirrors recovered update ordering for deterministic tests, but
the playable aircraft still uses `FlightModelMvp`; the two must not be described
as already integrated. Mission phase/flag bridges expose selected recovered
state without proving the remaining mission state machine.

## Evidence vocabulary

- **PROVEN / RECONSTRUCTED**: directly supported by source bytes or equivalent
  independent evidence.
- **STRONG INFERENCE / INFERRED**: supported interpretation whose semantic label
  is not directly encoded.
- **UNKNOWN / BLOCKED**: unresolved; strict code must not approximate it.
- **MVP APPROXIMATION / TUNING / AUTHORING DECISION**: prototype-only choice.

## Narrow entry points

- Current state and active milestone: [`PROJECT_STATUS.md`](PROJECT_STATUS.md)
- Semantic checkpoint: [`DECOMPILATION_PROGRESS.md`](DECOMPILATION_PROGRESS.md)
- System-to-source navigation: [`SUBSYSTEM_MAP.md`](SUBSYSTEM_MAP.md)
- Per-symbol prototype cross-reference: [`IMPORT_STATUS.md`](IMPORT_STATUS.md)
- Structures and contracts: [`STRUCTS.md`](STRUCTS.md), `contracts/`
- Loader evidence: [`LOADER_CHAIN.md`](LOADER_CHAIN.md)
- Trace format: [`TRACE.md`](TRACE.md)
- Mission 01 harness: [`MISSION_01_MVP.md`](MISSION_01_MVP.md)

Use `tools/re_query.py` for one function, block, dependency, or test case and
`tools/progress_stats.py` for current counts. Historical convergence plans are
retained under `docs/research/` and are not active instructions.
