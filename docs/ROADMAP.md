# Strict-port roadmap

This document records stable milestones only. Current priorities and counts are
generated or maintained at the authoritative entry points:

- [`PROJECT_STATUS.md`](PROJECT_STATUS.md) — current project state and milestone;
- [`DECOMPILATION_PROGRESS.md`](DECOMPILATION_PROGRESS.md) — active semantic work;
- [`STRICT_PORT_FOUNDATION.md`](STRICT_PORT_FOUNDATION.md) — translation gates;
- `python3 tools/progress_stats.py` — live orthogonal counts.

## Milestone 1 — deterministic foundations

Preserve 68000 width/sign behavior, packed memory access, original function
boundaries, RNG consumption, and recovered tick ordering in isolated strict
modules. Every translated function needs a segment-qualified identity, source
hash, deterministic test, and explicit verification status.

## Milestone 2 — one source-backed aircraft path

Run one aircraft through its recovered controller and state path exactly once
per simulation frame. Input, HUD, and rendering must read the same state. Do not
substitute the prototype flight model for unresolved original behavior.

Acceptance requires proven coordinate units and cadence, stable RNG draw order,
source-backed fixtures, and no second backend moving the same aircraft.

## Milestone 3 — mission integration

Integrate verified entity dispatch, mission gates, collision/contact, and
resource-backed behavior behind thin Godot adapters. Keep scene lifecycle,
rendering, and input collection separate from strict simulation semantics.

## Milestone 4 — parity validation

Compare deterministic traces against independently captured original behavior
when such traces are available. Until then, structural and behavioral unit tests
prove only their documented slices—not full runtime, visual, or mission parity.

Prototype-era Phase A/B/C tables and convergence-loop instructions are retained
in Git history and `docs/research/`; they are not current task queues.
