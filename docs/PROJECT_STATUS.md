# Hellcats Over the Pacific — current status

## Current position

The repository has two intentionally separate Godot tracks:

- `godot/hellcats/` is a playable Mission 01 prototype with authored mission
  data, placeholder rendering, an MVP flight model, HUD, objectives, and tests.
- `godot/strict_port/` is the source-faithful track. New parity work starts here
  and follows the semantic reconstructed C, not prototype behavior.

The strict port is foundational, not gameplay-complete. Run
`python3 tools/progress_stats.py` for current reconstruction, translation, and
resource counts, and `python3 tools/strict_port/check_sync.py --json` for strict
source-hash synchronization. These independent categories must not be collapsed
into an overall completion percentage.

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

Start at `README.md`. Use `tools/re_query.py` for a single function, bounded
excerpt, caller/callee set, globals, status, symbol record, strict mapping, or
test case. Use `tools/resedit.py inspect`, `item`, `references`, and bounded
`raw` for one resource. Do not load project-wide histories or entire source
corpora for a focused task.

Detailed current references:

- `DECOMPILATION_PROGRESS.md` — semantic reconstruction target and workflow
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
