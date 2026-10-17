# Hellcats Over the Pacific — current status

Updated 18 October 2026. Older assessments are preserved in
[`research/PROJECT_STATUS_HISTORY.md`](research/PROJECT_STATUS_HISTORY.md); they
are historical and may contain superseded counts or architecture assumptions.

## Current position

The repository has two intentionally separate Godot tracks:

- `godot/hellcats/` is a playable Mission 01 prototype with authored mission
  data, placeholder rendering, an MVP flight model, HUD, objectives, and tests.
- `godot/strict_port/` is the source-faithful track. New parity work starts here
  and follows the semantic reconstructed C, not prototype behavior.

The strict port is foundational, not gameplay-complete. Its manifest maps three
of 736 reconstructed functions; all three are structurally and behaviorally
verified with deterministic tests, none is integrated into the playable runtime,
and none has original-Mac runtime verification. Run
`python3 tools/strict_port/check_sync.py --json` for current generated counts.

The reconstruction checkpoint records 674 renamed, 56 independently verified,
and 6 blocked functions. These are C-reconstruction states, not implementation
percentages. The resource corpus contains 119 resources across 30 types, with
116 decoded structures; `python3 tools/resedit.py inventory` reports live counts.

## Architecture and next milestone

The strongest integration milestone remains one source-backed aircraft following
its recovered controller/state path exactly once per simulated frame, with input,
HUD, and rendering reading the same state. Before integration:

1. preserve original controller dispatch and RNG consumption;
2. distinguish recovered engine/fuel/control fields from prototype names;
3. validate populated fixtures against independent C/binary evidence;
4. establish coordinate units, cadence, and signed/fixed-width behavior;
5. keep exactly one backend responsible for motion in a run.

The playable prototype remains a comparison harness. It is not evidence for
unknown original behavior, and its `FlightModelMvp` must not leak into strict
translations.

## Evidence and retrieval

Start at `README.md`. Use `tools/re_query.py` for a single function, callers, globals,
status row, symbol record, or strict-port mapping. Use `tools/resedit.py inspect`
and `references` for one resource. Do not load project-wide histories or entire
source corpora for a focused task.

Detailed current references:

- `DECOMPILATION_PROGRESS.md` — live reconstruction counts and next target
- `DECOMPILATION_SYMBOLS.md` — canonical semantic symbol and field registry
- `STRICT_PORT_FOUNDATION.md` — strict translation contract and milestones
- `RESOURCE_ANALYSIS.md` — resource corpus and decoding status
- `SUBSYSTEM_MAP.md` — original-system to Godot navigation
- `IMPORT_STATUS.md` — per-symbol prototype/import status

## Validation boundary

Automated suites cover deterministic helpers, synchronization, fixtures, and
scene loading. Passing them does not establish visual parity, original runtime
parity, complete flight behavior, or end-to-end mission fidelity. Those require
explicit evidence and must be reported separately.
