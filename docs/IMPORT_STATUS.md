# Import status (decompiled C ↔ Godot)

Tags: **[RECONSTRUCTED]** / **[INFERRED]** / **[UNKNOWN]** / **[DEFERRED]**.

**Purpose:** Single place to see which **Pacific Conflict.c** (and segment) symbols are reflected in the repo, and how complete that reflection is. This is a **living** table—update it when contracts or code change.

**Corpus:** `Hellcats-Over-the-Pacific_Mac_EN/ResEdit/CODE/` — **Pacific Conflict.c** (main game), **ID01.c–ID09.c** (segment/runtime splits). See `docs/LOADER_CHAIN.md` for how ID segments relate to the overlay.

**Related:** `docs/SUBSYSTEM_MAP.md`, `docs/CONVERGENCE_BACKLOG.md`, `docs/ROADMAP.md`.

## Legend

| Status | Meaning |
|--------|---------|
| **Done** | Behavior or ordering represented in Godot/tests; contract may still note approximations. |
| **Partial** | Some paths, data, or branches ported; parity incomplete. |
| **Doc only** | Documented in `docs/contracts/*_contract.md` or `STRUCTS.md`; not executed in Godot (or only as comments). |
| **Not started** | No meaningful port; **[UNKNOWN]** may still apply to the original. |
| **DEFERRED** | Intentionally out of scope for current milestones (often runtime/helpers). |

## A) Sim tick and entity dispatch

| Symbol / cluster | Source (evidence) | Godot / tests | Status | MVP notes |
|------------------|-------------------|---------------|--------|-----------|
| **FUN_000044e8** | `Pacific Conflict.c` (~5096–5145); `docs/contracts/tick_FUN_000044e8_contract.md` | `hellcats/core/sim_core.gd`; `godot/tests/integration/test_sim_tick_ordering.gd` | **Done** | **[INFERRED]** Mission-1 playable loop uses `PlayerAircraft` + `FlightModelMvp`; SimCore is parity / future wiring. |
| **FUN_000044a4** | Same; dispatches to **FUN_0000435a** | `SimCore._update_single_entity` | **Partial** | **param_2** surfaced; full tail parity **[UNKNOWN]**. |
| **FUN_0000435a** | `Pacific Conflict.c` (~5008–5075); `docs/contracts/FUN_0000435a_contract.md` | `SimCore` (counts / `param_2`); branch logic not fully split | **Partial** | Critical for array 1–2 vs 3–4 fidelity. |
| **FUN_00005df8** | Called when `DAT_0001b5a0 + 0xac == 0`; clears 7× `DAT_0001bc64` after `FUN_0000528a` (Pacific Conflict.c:6434–6447) | `SimCore._call_05df8()` + `dat_0001bc64`; tick-order counters; test in `test_sim_tick_ordering.gd` | **Done** (loop/clear) | **`FUN_0000528a` body deferred** (call counted only). |
| **FUN_0000528a** | Cleanup invoked by **FUN_00005df8** (Pacific Conflict.c:5784–5798) | `SimCore._call_0528a` + entity offsets `flags_07` / `field_24` / `field_3c` | **Done** (control flow) | Calls **FUN_000051ec** or type-0x02 alt (`field_04\|0x42`, `field_3c=DAT_0001b838`). |
| **FUN_000051ec** | Called from **FUN_0000528a** (Pacific Conflict.c:5751–5779) | `SimCore._call_051ec` + `mem_u32` | **Done** (proven stores) | Entity writes, table poke via `mem_u32[*(DAT_0001d6fc+0x30)+0x14+field_02*0x18]`, and `mem_u32[entity+8]=0`. Full Mac heap identity **[INFERRED]** via flat `mem_u32`. |
| **FUN_00006fb8** | After four entity passes; body sets six globals to `100000000` (Pacific Conflict.c:7180–7189) | `SimCore._call_06fb8()` + `last_tick_order.fun_00006fb8_*`; `test_sim_tick_ordering.gd` | **Done** (side effect) | Semantic role of the six DATs **[INFERRED]** / partially **[UNKNOWN]**. |
| Entity arrays **DAT_0001d4a4**, **DAT_0001b5a4**, **DAT_0001d0e4**, **DAT_0001cbe4** + counts | `STRUCTS.md`, tick contract | `SimCore` pass lists | **Done** (structural) | **[INFERRED]** Roles of arrays 1,3,4 beyond counts **[UNKNOWN]**. |

## B) Flight model and entity update (FUN_0000e792)

| Symbol / cluster | Source (evidence) | Godot / tests | Status | MVP notes |
|------------------|-------------------|---------------|--------|-----------|
| **FUN_0000e792** | `Pacific Conflict.c` (~14016+); `docs/contracts/flight_FUN_0000e792_contract.md` | `FlightModelMvp` + `AircraftState`; `SimCore` slices incl. contact early-out | **Partial** | Through `05116` free-slot/fill/gate (046da/grow mocked); `12840` writes; `15d20`/`19430` / real `046da` still open. |
| **FUN_0000e42a**, **FUN_0000e468**, **FUN_0000e570** | Inside / near **FUN_0000e792** block (~13796–13915) | `hellcats/core/flight_math.gd` | **Done** (helpers) | Used by convergence; not always wired in live tick. |
| **FUN_00011564** | Overlay table RNG (Pacific Conflict.c:16407–16433) | `rng_overlay_11564.gd`; `SimCore.rng` / `_rng_consume` | **Done** | Paired with **FUN_0001150a** / **FUN_000114ca** init. ID05 on `rng_id05`. |
| **FUN_0001150a** / **FUN_000114ca** | Init + mul helper (Pacific Conflict.c:16355–16385) | `init_1150a` / `fun_000114ca` / `set_seed` | **Done** | `table[0]` prior value **[UNKNOWN]** (=0). |
| **DAT_0001b738** (player entity ptr) | `STRUCTS.md`, input + **FUN_0000e792** | `PlayerAircraft` / mission flow | **Partial** | Single “player” in Godot; SimCore designation **[INFERRED]** partial. |
| **DAT_0001b888** (second designated entity) | Ownership branch ~14179 | Not modeled end-to-end | **Doc only** | **[UNKNOWN]** full semantics. |

## C) Input (FUN_0000740a)

| Symbol / cluster | Source (evidence) | Godot / tests | Status | MVP notes |
|------------------|-------------------|---------------|--------|-----------|
| **FUN_0000740a** | `Pacific Conflict.c` (~7366+); `docs/briefs/input_FUN_0000740a_brief.md`, `STRUCTS.md` | `hellcats/flight/player_input_map.gd`; `docs/contracts/input_godot_contract.md` | **Partial** | Throttle steps → `throttle_impulse`; full **DAT_0001d858** FSM not ported. |
| **DAT_00024cf6** (throttle step accumulator path) | C input handler | Approximated as impulse | **Partial** | **[MVP APPROXIMATION]** per `docs/contracts/input_godot_contract.md`. |
| **DAT_0001d858** (game state) | Values 1, 7, 8, 9 | `player_active` gate only | **Doc only** / **Partial** | Menu/pause parity **[DEFERRED]**. |

## D) Mission globals and bridge

| Symbol / cluster | Source (evidence) | Godot / tests | Status | MVP notes |
|------------------|-------------------|---------------|--------|-----------|
| **DAT_0001b5a0** + **0xa8** / **0xac** | `docs/contracts/mission_state_DAT_contract.md`, `STRUCTS.md` | `MissionController.mission_phase_a8`, `mission_flag_ac`; `get_mission_sim_bridge_state()` | **Done** (MVP bridge) | Matches gates for tick narrative. |
| Full **DAT_0001b5a0** layout | C | Partial in `STRUCTS.md` | **Doc only** | **[UNKNOWN]** many fields. |

## E) Camera

| Symbol / cluster | Source (evidence) | Godot / tests | Status | MVP notes |
|------------------|-------------------|---------------|--------|-----------|
| **FUN_0000739a** | Called around tick / render path (`Pacific Conflict.c` ~7350, ~4442, etc.) | Godot `PlayerAircraft` chase camera (authored) | **Not started** (RE parity) | **[INFERRED]** MVP uses Godot camera, not a line-accurate port. |

## F) RNG (Macintosh LCG vs in-game)

| Symbol / cluster | Source (evidence) | Godot / tests | Status | MVP notes |
|------------------|-------------------|---------------|--------|-----------|
| **FUN_00000728** (LCG `* 0x41c64e6d + 0x3039`) | **ID05.c** (~130–135); cited in `docs/ROADMAP.md` | `Rng68k` / SimCore seeding pattern | **Done** (algorithm) | Segment-local; parity uses same constants **[RECONSTRUCTED]**. |
| **FUN_00011564** | **Pacific Conflict.c** | See §B; `rng_overlay_11564.gd` | **Partial** | Fixture exists; not yet the SimCore consumer. |

## G) Loader / segments (ID01–ID09)

| File | Role **[INFERRED]** | Import status | MVP notes |
|------|----------------------|---------------|-----------|
| **ID01.c** | Integer/math runtime fragments | **DEFERRED** | Use Godot math, not a C port. |
| **ID02.c** | Large segment helpers (`unaff_A5` patterns) | **DEFERRED** | Not game rules. |
| **ID03.c–ID04.c**, **ID06.c–ID07.c**, **ID09.c** | Mixed helpers; some bad decomp regions | **DEFERRED** / **[UNKNOWN]** | Port only if proven game-critical and missing from **Pacific Conflict.c**. |
| **ID05.c** | LCG + helpers | **Partial** (RNG constant match) | See §F. |
| **ID08.c** | LoadSeg / resource traps; see `LOADER_CHAIN.md` | **Doc only** | Full loader parity **[DEFERRED]**. |

## H) HUD / cockpit numeric fields

| Topic | Godot / docs | Status | MVP notes |
|-------|----------------|--------|-----------|
| Cockpit ↔ **FUN_0000e792** entity fields | `AircraftState` snapshot; training HUD | **Partial** | `CONVERGENCE_BACKLOG.md` #6: field-accurate HUD vs original **[INFERRED]** still open for parity. |

## Update log

| Date | Change |
|------|--------|
| 2026-10-15 | Contact surface via `world_obj_ptr` (`*param_1`) + `mem_u32[+0x1c]`; drops `contact_surface_1c`. |
| 2026-10-15 | **FUN_0001150a** / **FUN_000114ca** init+warm-up on overlay RNG. |
| 2026-10-15 | **FUN_00011564** wired into `SimCore._rng_consume`; ID05 retained as `rng_id05`. |
| 2026-10-15 | **FUN_00011564** overlay RNG class + fixture test; SimCore still on ID05 LCG. |
| 2026-10-15 | **FUN_0000e792** contact early-out (`status_1a1&8`) on SimCore; Mission-1 not wired. |
| 2026-10-15 | **FUN_000051ec** indirect table/`**(+8)` stores via `mem_u32`. |
| 2026-10-15 | **FUN_0000528a** control flow + partial **FUN_000051ec**; table/`**(+8)` still deferred. |
| 2026-10-15 | **FUN_00005df8** loop/clear ported; **FUN_0000528a** body still deferred. |
| 2026-10-15 | **FUN_00006fb8** side effect ported on `SimCore`; docs/contracts updated. |
| 2026-04-08 | Initial **IMPORT_STATUS.md** from architecture audit. |

When you complete a row (e.g. **FUN_00006fb8**), update this file and add a line to `docs/NOTES.md`.
