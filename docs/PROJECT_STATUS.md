# Hellcats Over the Pacific — Project Status

Assessment date: 15 October 2026.

This report describes the Godot repository as it exists today. It does not describe a planned game. Claims are tagged:

- **Verified** — read from a file, scene, script, original C source, or a command that was run.
- **Inference** — a conclusion that follows from those files, but was not executed as gameplay.
- **Unknown** — not established by the files inspected.

Manual play in the Godot editor was not performed. Headless tests are not evidence of how the game looks or feels.

Original decompiled sources live outside this repository, under `Hellcats-Over-the-Pacific_Mac_EN/ResEdit/CODE/` (`Pacific Conflict.c`, `ID01.c`–`ID09.c`).

## A. Executive Summary

The project is a clean-room Godot 4 reimplementation of the 1991 Macintosh flight simulator *Hellcats Over the Pacific*. Two tracks sit side by side.

The first track is a **playable Mission 1 prototype**. Launching the project opens Flight School. The player flies a box-shaped aircraft over a flat sea with keyboard controls, a text HUD, an attitude strip, a chase camera, one checkpoint ring, and an authored objective list. Success, failure, and restart are implemented in script. **Verified.**

The second track is a **deterministic reverse-engineering harness**. `SimCore` reproduces the original tick order, a few math helpers, and an ID05 random-number generator. It is exercised by tests. The running mission does not call it. **Verified:** `hellcats/mission/mission_controller.gd` states that the Mission 1 scene loop does not call `SimCore.tick()`.

This is not a faithful recreation of the original game. Combat, a cockpit, a real terrain model, original rendering, and the original flight function are absent or only approximated. **Verified** from the scene and script tree.

`project.godot` names the project "Hellcats Sim", targets Godot 4.5 features, and sets the main scene to `res://godot/scenes/main/Main.tscn`.

## B. Implemented Features

"Implemented" here means the code path exists and is wired into the main scene or into a test that exercises it. It does not mean the behavior matches the 1991 game.

### Playable mission loop

**Verified.** `Main.tscn` instances `godot/scenes/missions/Mission01Training.tscn`. That scene contains the world, the player aircraft, a checkpoint manager, the HUD, and `MissionController`.

On `_ready`, `MissionController._load_and_start()` loads:

- `godot/data/mission_01/mission_01_training.json`
- `godot/data/mission_01/aircraft_mvp.json`
- the checkpoint file referenced by the mission JSON (`checkpoints_mission_01.json`)

The aircraft spawns airborne at `(0, 1200, 0)` meters, heading 90 degrees, 95 m/s, throttle 0.72. **Verified** in the mission JSON and `AircraftState.apply_spawn`, which the player calls from `setup_mission`.

There is no mission-select screen. The game always starts this one mission. **Verified.**

### Aircraft controls

**Verified.** `project.godot` has no input map. `PlayerInputMap.ensure_actions()` registers actions at runtime. `PlayerAircraft._physics_process` reads them through `PlayerInputMap.read_input_packet`.

| Action | Keys |
| --- | --- |
| Pitch | Up / Down |
| Roll | Left / Right, A / D |
| Yaw | Q / E |
| Throttle hold | Page Up / Page Down, W / S |
| Throttle step | `=` / `-`, keypad `+` / `-` |
| Restart | R (`mission_restart` → `reload_current_scene`) |
| Quit | Esc (Godot built-in `ui_cancel`) |

When the aircraft is inactive, control output is zeroed.

### Flight model used in play

**Verified.** The live aircraft uses `FlightModelMvp.step()` on an `AircraftState` object. Each physics frame:

1. Throttle moves from a held axis and from a step impulse of `0.11` (`THROTTLE_STEP_IMPULSE`).
2. Pitch, roll, and yaw commands are smoothed into integer accumulators `movement_66e`, `movement_672`, and `movement_66a` through `FlightMath.add_delta_smoothed_int` / `add_delta_smoothed_s16`.
3. Those accumulators are scaled back to floats and applied as attitude rates, airspeed, vertical speed, and position.

The smoothing rule is taken from the original entity update. The speed, climb, and position integration are authored arcade values in `aircraft_mvp.json`, not the original aerodynamic function. See section C.

`PlayerAircraft._apply_state_to_transform` copies position and rotation onto the `Node3D`, so the mesh and camera move with the state. **Verified.**

### Camera

**Verified.** `PlayerAircraft.tscn` has a child `FollowCamera` (`Camera3D`). Offset, field of view, and attitude sway come from the `camera` block in `aircraft_mvp.json`. `_smooth_camera` lerps the camera each physics frame. This is a third-person chase camera. It is not a port of original `FUN_0000739a`.

### HUD

**Verified.** `godot/scenes/ui/HUD_MVP.tscn` is a `CanvasLayer` of labels plus `HudAttitudeStrip`. `MissionController._physics_process` passes `PlayerAircraft.get_snapshot()` into `HudMvp.update_telemetry`.

The HUD shows the brief title, current objective, speed, vertical speed, altitude, heading, throttle, pitch, bank, stall / out-of-bounds / low-altitude warnings, range and bearing to the next checkpoint, and mission status. The attitude strip draws from the same pitch and bank. These values come from `AircraftState`, not from placeholder random numbers.

There is no cockpit interior and no moving gauge artwork.

### World

**Verified.** `WorldBuilderMvp._ready()` builds, at runtime:

- a procedural sky and fog
- a directional light
- a blue sea plane about 20 km across at y = 0
- a green box island (1200 × 50 × 1200 m) near `(0, -24, 2600)`
- a billboard sun disk

### Mission 1 objectives, failure, and restart

**Verified.** `MissionObjectivesM1` walks `objective_sequence` in order. From `mission_01_training.json`:

| Step | Id | Rule |
| --- | --- | --- |
| 1 | `stabilize_flight` | Hold altitude within 120 m of 1200 m for 6 seconds |
| 2 | `turn_left` | Bank at least 20 degrees left |
| 3 | `turn_right` | Bank at least 20 degrees right |
| 4 | `climb` | Reach at least 1450 m |
| 5 | `descend` | Reach 1100 m or below |
| 6 | `checkpoint_pass` | Pass ring `cp_01` — marked `optional: true` |

Required steps must complete in order. The optional checkpoint does not block success. `MissionObjectivesM1.are_required_objectives_complete()` encodes that rule. A unit test covers a shortened version of it.

Failure, from `MissionController._check_failure` and `PlayerAircraft._physics_process`:

- open-sea altitude at or below 0.5 m (`terrain_or_sea_impact`), or position inside the island AABB (`island_impact`) via `WorldBuilderMvp.impact_reason_at`
- outside `bounds_radius_m` (4200 m) for 8 seconds
- stalled for 4 seconds

On success or failure the aircraft is deactivated and the HUD status changes. R reloads the scene. Esc quits.

`CheckpointManager` spawns one torus at the checkpoint position and detects a pass by distance. **Verified.**

### Reverse-engineering pieces that are actually coded

These run in `SimCore` and unit tests. They do not fly the on-screen aircraft.

| Original | Godot | What is reproduced |
| --- | --- | --- |
| `FUN_000044e8` | `SimCore.tick()` | Gate on mission flag `+0xac`, then four array passes with second argument `0, 0, 1, 1` when phase `+0xa8` is in `1..5`, matching `Pacific Conflict.c` lines 5102–5142 |
| `FUN_0000e42a`, `FUN_0000e468`, `FUN_0000e570` | `FlightMath` | Helper functions, with unit tests |
| Delta rule inside `FUN_0000e792` | `FlightMath.add_delta_smoothed_*` | If the absolute delta is under 8, add it all; otherwise add `delta >> 3` with the original negative adjustment |
| `FUN_00000728` / `FUN_00000746` in `ID05.c` | `Rng68k` | LCG multiply `0x41c64e6d`, add `0x3039` |
| Entity field offsets used by `FUN_0000e792` | `EntityState.OFFSETS` | Key layout for the parity objects. No binary `from_bytes` loader |
| Loader target list | `LoaderMetadata` | JSON lookup of proven entry targets. Does not execute a Macintosh segment load |

`SimCore` also keeps mission phase and flag fields, four entity arrays, a trace log, and a replay runner. **Verified** in `hellcats/core/sim_core.gd`, `flight_math.gd`, `rng.gd`, `loader_metadata.gd`, `replay_runner.gd`.

## C. Partially Implemented Features

### Flight physics

**Verified.** `FlightModelMvp` is an arcade integrator with a reconstructed smoothing rule bolted on. It is not `FUN_0000e792` (`Pacific Conflict.c` from line 14018), which is the large per-entity update for movement, status, weapons counters, and ground contact.

`SimCore._update_single_entity` applies a smaller set of those slices to `EntityState` objects: randomized control offsets, a control-gate accumulator, threshold decrement, and the same smoothing rule. The comment on that function says it stands in for `FUN_000044a4` → `FUN_0000435a` / `FUN_0000e792`. The original call graph does not work that way. See section E.

`hellcats/core/fixed.gd` (`Fixed68k`) is a 68000-style fixed-point helper. Nothing in the scenes or tests references it. **Verified** by search.

### Input versus the original dispatcher

**Verified.** `PlayerInputMap` gathers Godot actions and emits a throttle impulse. The original handler is `FUN_0000740a` (around line 7366 in `Pacific Conflict.c`), a large key dispatcher with a game-state machine (`DAT_0001d858`) and a return mask. The contract in `docs/contracts/input_godot_contract.md` already calls the Godot path an approximation. The full dispatcher is not ported.

`SimCore.input_packet` is copied into the trace inside `tick()`. It is not applied to entity motion. **Verified.**

### Mission-state bridge

**Verified.** `MissionController` sets `mission_phase_a8 = 1` and `mission_flag_ac = 1` while the mission runs, and both to `0` in a terminal state. Those names mirror `DAT_0001b5a0 + 0xa8` and `+0xac`, which gate `FUN_000044e8`. Nothing in the playable scene copies them into a `SimCore` instance or calls `tick()`. `get_mission_sim_bridge_state()` is not used by gameplay code.

`DAT_0001b5a0 + 0xb0` is described in `docs/contracts/mission_state_DAT_contract.md` and is not a field on `MissionController`.

### Tick hooks

**Verified.** Both tick hooks now have reconstructed side effects on `SimCore` (still not wired into Mission 1):

- `FUN_00005df8` (`Pacific Conflict.c` 6434–6447) — **ported** as a seven-slot clear of `dat_0001bc64` after `_call_0528a`.
- `FUN_0000528a` (5784–5798) — **ported** control flow (flag skip / `FUN_000051ec` / type-0x02 alt).
- `FUN_000051ec` (5751–5779) — **ported** for proven stores, including table poke and `**(entity+8)=0` via `SimCore.mem_u32`.
- `FUN_00006fb8` (7180–7189) — **ported**: six globals set to `100000000`.

`FUN_0000435a` gate/`+0xc`/kind2 poly helpers are wired on tick `044a4`, spawn `04e6e` followup (`param_2==0`), and `046da` (`param_2==1`). Template scale sources remain mocked.

### Terrain, sea, and collision

**Verified (Mission 1 MVP).** `WorldBuilderMvp` owns shared solid volumes that match the placeholder meshes: sea impact at `y <= 0.5` away from the island, and an AABB for the island box (`ISLAND_CENTER` / `ISLAND_SIZE`). `StaticBody3D` collision shapes (`SeaBody`, `IslandBody`) are created with the meshes. `PlayerAircraft` and `MissionController` both call `WorldBuilderMvp.impact_reason_at`. Covered by `godot/tests/unit/test_world_collision_mvp.gd`. **MVP authoring decision** — not a port of original terrain/contact (`FUN_00005df8` / `FUN_00006fb8`). No landing gear, runway, or carrier deck.

Checkpoint pass audio is looked up as `PassAudio` and is never created. **Verified.**

### Data that the mission loader does not use

**Verified** by comparing JSON keys with GDScript reads:

- `nav` compass metadata — the HUD nav line is computed in `MissionController._merge_nav_into_snapshot`
- `aircraft_mvp.json` `stall.fail_after_seconds` — the fail timer comes from the mission JSON `failure.stall_seconds`

**Now wired (Mission 1 MVP):**

- `success.complete_all_required_objectives` — `MissionObjectivesM1.is_mission_success()` (true: required only; false: all objectives including optional)
- `start_mode` — `MissionController` applies `"airborne"`; other values warn and fall back to airborne spawn

### Rendering

**Verified.** The aircraft is a `BoxMesh` fuselage plus a wing box, built in `PlayerAircraft._ensure_visuals`. No imported aircraft, terrain, or cockpit assets are in the gameplay scenes.

### Duplicate test trees

**Verified.** The runner is `godot/tests/run_all.gd` (13 scripts). `hellcats/tests/` holds older `SceneTree` scripts, including `test_sim_entity_controls.gd` and `test_movement_smoothing.gd`, which the runner does not call.

## D. Missing Features

These are absent from the running scene. Some have notes in `docs/`. A note is not an implementation.

| Gap | Evidence |
| --- | --- |
| Mission select and any mission after Flight School | Main scene always instances Mission 1 |
| Cockpit and original HUD field mapping | No cockpit scene. `docs/CONVERGENCE_BACKLOG.md` item 6 is still "Not started" for original field parity |
| Original camera and projection (`FUN_0000739a` and the view modes in the input brief) | Chase camera only. `docs/IMPORT_STATUS.md` section E: not started |
| Landing, carrier deck, original terrain contact | Mission 1 has MVP sea/island solids; no gear/deck; original `FUN_00005df8`/`FUN_00006fb8` still unwired to playable flight |
| Other entities: wingmen, enemies, ships, AI | No such nodes. Original callers of `FUN_0000e792` such as `FUN_00010ce8` and `FUN_0001820a` have no Godot counterpart |
| Weapons and damage as gameplay | Weapon counters exist only as fields inside the unwired `SimCore` path |
| Overlay random generator `FUN_00011564` | Ported as `RngOverlay11564` and wired into `SimCore` entity control offsets; ID05 remains a separate harness RNG |
| Resource loading as execution | `ID08.c` and `FUN_00000020` are documented in `docs/LOADER_CHAIN.md`. Runtime is a JSON metadata lookup |
| Sound | No audio players in the gameplay scenes. This pass did not find a sound subsystem in the decompiled overlay |
| Original world renderer | Not mapped to a named function that has a Godot port. **Unknown** which original functions draw the world |
| Packaged game | No `export_presets.cfg` in the repository |

## E. Reverse-Engineering Coverage

Corpus sizes, from line counts of the authoritative C exports:

| File | Lines | Role established from the file |
| --- | --- | --- |
| `Pacific Conflict.c` | about 24,083 | Main overlay: init, tick, input, entity update, AI wrappers, camera anchors |
| `ID02.c` | 2,738 | Largest CODE segment; many Toolbox-style calls and bad-decomp regions |
| `ID04.c` | 1,013 | Deferred helper segment |
| `ID03.c` | 945 | Mixed helpers. Cockpit role is suggested in docs and is **not proven** |
| `ID06.c` | 900 | Bit tables and resource/geometry-adjacent helpers; some ID00-proven entries |
| `ID05.c` | 369 | LCG `FUN_00000728` |
| `ID08.c` | 282 | Resource-loader candidate (A5 trap calls) |
| `ID01.c`, `ID09.c`, `ID07.c` | 155, 145, 46 | Small helpers. `ID07.c` `FUN_00000190` is an ID00-proven entry |

Most of those functions are not ported. Coverage below is by subsystem, not by percentage of lines.

### Reproduced structure

- Tick gate and four-pass order of `FUN_000044e8`, including `param_2` values 0, 0, 1, 1. Hook bodies `FUN_00005df8` / `FUN_00006fb8` have proven stores on `SimCore` (still not Mission 1).
- Flight helper trio, delta-smoothing, and `FUN_0000e792` slices through `field_63e` touchdown plus pitch follow-on (`status|0x400`, clear `field_18e`, player `DAT_0001b868`).
- Overlay `FUN_00011564` on the entity path; ID05 LCG constants and the 15-bit extract remain for the harness RNG.
- Entity offset keys on `EntityState`.
- Mission phase and flag *values* on the controller, as data only.

### Approximated

- Player flight (`FlightModelMvp`).
- Keyboard input (`PlayerInputMap`).
- Mission 1 rules. These are authored JSON, not a port of the original mission block.
- HUD. Telemetry is real for the arcade state and is not the original cockpit field map.
- Sea-level failure. Original `FUN_0000e792` has a ground/water contact branch using a status bit. Godot uses `y <= 0.5`.
- Loader. Metadata records proven targets. It does not load a CODE segment.

### Documented only

- Full `FUN_0000435a` body (`docs/contracts/FUN_0000435a_contract.md`).
- Full `FUN_0000740a` state machine (`docs/briefs/input_FUN_0000740a_brief.md`).
- `FUN_0000739a` camera copy into view globals.
- `DAT_0001b5a0 + 0xb0` and the designated-target slot `DAT_0001b888`.
- `FUN_00000020` / ID08 loader execution (`Pacific_Conflict_loader_analysis.md`, `docs/LOADER_CHAIN.md`).
- Hook behavior of `FUN_00005df8` and `FUN_00006fb8`: the C bodies are known; Godot still stubs them, and several docs still say the behavior is unknown.

### Not yet investigated, or only implied

- Original world / projection renderer. **Unknown** which functions draw terrain and the map.
- Sound. No sound symbols were identified in this pass.
- Semantic names for entity offsets `0x66e`, `0x672`, and `0x66a`. Code treats them as pitch, roll, and yaw accumulators. That reading is marked inferred in the flight contract.
- Roles of entity arrays 1, 3, and 4 beyond "they are iterated."
- Whether a trace from the original binary can be captured for comparison. `docs/ROADMAP.md` Phase C still lists this as not started.

### Call-graph correction

**Verified** in `Pacific Conflict.c`. `FUN_000044e8` calls `FUN_000044a4`, which leads toward `FUN_0000435a`. That chain does not call `FUN_0000e792`. `FUN_0000e792` is called from later wrappers, including `FUN_00010ce8`, `FUN_00010f68`, `FUN_000110f4`, and `FUN_0001820a`.

`SimCore._update_single_entity` comments, and the diagram in `docs/SUBSYSTEM_MAP.md`, present `0435a` and `e792` as one chain. That is a structural resemblance, not the original call graph. Movement slices inside `SimCore` are still real code. They are not evidence that the original tick function runs the flight function.

## F. Architecture Assessment

### Runtime shape

```
project.godot
  Main.tscn
    Mission01Training.tscn
      World          world_builder_mvp.gd
      PlayerAircraft player_aircraft.gd
        AircraftMesh, Wings, FollowCamera
      Checkpoints    checkpoint_manager.gd
      HUD            hud_mvp.gd + hud_attitude_strip.gd
      MissionController
```

Scenes, JSON, and the test runner live under `godot/`. Gameplay scripts live under `hellcats/`. There is no second gameplay script tree inside `godot/`. **Verified.**

`docs/TECHNICAL_OVERVIEW.md` section 3 says scripts live under `godot/hellcats/`. That path does not exist. `docs/NOTES.md` repeats the same stale prefix.

There are no autoloads. The renderer is `gl_compatibility`. The window is 1280×720 and starts fullscreen (`window/size/mode=2`).

### Who owns the simulation

| Object | Holds | Used while playing? |
| --- | --- | --- |
| `AircraftState` | Position, attitude, speed, throttle, stall timers, and the three movement accumulators | Yes. This is the aircraft |
| `FlightModelMvp` | Integrator configuration and `last_flight_trace` | Yes |
| `PlayerAircraft` | The node transform, camera, crash signal | Yes |
| `MissionController` | Objective index, fail timers, phase/flag mirrors | Yes, for rules and HUD |
| `SimCore` + `EntityState` | Tick order, four arrays, separate copies of the movement accumulators, ID05 RNG | No. Tests and `ReplayRunner` only |

**Verified.** The two movement-accumulator sets are different objects updated by different functions. They can diverge because they are never the same state. **Inference:** wiring `SimCore.tick()` into the scene later, without deleting or syncing `FlightModelMvp`, would create two sources of truth for the same aircraft.

### Pipelines

**Input to physics.** `PlayerInputMap.read_input_packet` → `FlightModelMvp.step` → `AircraftState`. Mission restart and quit are handled in `MissionController._unhandled_input`, not in the flight step.

**Physics to picture.** `PlayerAircraft._apply_state_to_transform` writes `global_position` and `rotation`. Child meshes and `FollowCamera` follow. The world does not read aircraft state.

**HUD.** `get_snapshot()` plus nav fields merged by the controller → `HudMvp.update_telemetry`. The HUD does not read `last_flight_trace` or `SimCore`.

**Mission progression.** `mission_state` is `boot`, then `running`, then `success` or `failure`. Objectives advance only while `running`. Terminal state freezes the player. Restart reloads the whole scene. `PlayerAircraft.restart()` exists and is not what the controller calls.

**Data loading.** `MissionLoader.load_bundle` reads the three JSON files. `LoaderMetadata` is a separate path for reverse-engineering fixtures. The Macintosh resource loader does not run.

### Documentation that disagrees with the tree

These files were not edited by this assessment. They should be treated as historical until updated:

- `docs/ROADMAP.md` "Current status summary" says Phase B is not started. The Phase B table itself marks input gathering and tick ordering done, and `flight_model_mvp.gd` already smooths `0x66e` / `0x672` / `0x66a`.
- The same summary says the next step is to wire that smoothing block. The playable flight model already calls it. The `SimCore` ownership-branch version is a separate, test-only path.
- `docs/ROADMAP.md` Phase C says the `FUN_000044a4` second argument is not started. `SimCore.tick()` already passes `0, 0, 1, 1`.
- `README.md` says `proven_loader_targets.json` lists two targets and cites `godot/docs/LOADER_CHAIN.md`, which does not exist. Both fixture copies list six targets. The table is in `docs/LOADER_CHAIN.md`.
- `docs/LOADER_CHAIN.md` section 10 records an ID05 `id00_entry_offset` of 1314. The fixtures and loader tests use 1362. Which value matches `ID00` was not re-checked against the binary. **Unknown.**
- `docs/CONVERGENCE_BACKLOG.md` item 6 says HUD work is not started. A telemetry HUD exists. Original cockpit parity does not.

## G. Testing Status

Automated commands were re-run from the repository root on 15 October 2026 after a P0 reliability fix. Manual smoke from `tools/qa/README.md` was not run. Nothing below is a visual or gameplay pass.

Godot on `PATH`: not found (`which godot` and `which godot4` empty). The binary used was `/Applications/Godot.app/Contents/MacOS/Godot`, version **4.6.2.stable**. `project.godot` declares feature **4.5**.

### Root cause fixed (same day)

Headless Godot without a `.godot/` global class cache could not resolve `class_name` types used as annotations. That made `entity_state.gd` fail to parse (`-> EntityState`), so `preload(...).new()` failed and `test_sim_tick_ordering.gd` failed. The same issue logged parse errors for `HudAttitudeStrip` and `MissionCheckpoint` during scene-load tests.

**Fix (verified):** avoid those annotations in favor of untyped / base types (`Control`, `Node3D`) and `call()` / `has_method()` where needed. Align `tools/qa/test_regression.py` `EXPECTED_RUNNER_PATHS` with `godot/tests/run_all.gd`. Make `hellcats/tests/fixtures/proven_loader_targets.json` byte-identical to the migrated fixture (tabs vs spaces).

### Python regression

```bash
python3 tools/qa/test_regression.py
```

Exit code **0**. All checks passed: `runner-layout`, `loader-fixture`, `replay-fixture`, `mission-mvp-data`.

### Godot headless suite

```bash
HOME=/tmp/hellcats-godot-home /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script res://godot/tests/run_all.gd
```

Exit code **0**. Runner summary: **13 passed, 0 failed, 0 skipped.** No `SCRIPT ERROR` / `Parse Error` lines in the log.

| Script | Result |
| --- | --- |
| `test_rng.gd` | Passed |
| `test_flight_math.gd` | Passed |
| `test_loader_metadata.gd` | Passed |
| `test_mission_objectives_m1.gd` | Passed |
| `test_player_input_frame.gd` | Passed |
| `test_flight_model_mvp.gd` | Passed |
| `test_sim_loader_bridge.gd` | Passed |
| `test_sim_tick_ordering.gd` | Passed |
| `test_replay.gd` | Passed |
| `test_mission_scene_load.gd` | Passed |
| `test_hud_mvp_scene.gd` | Passed |

### Not executed

- `hellcats/tests/*.gd`, including entity-control and movement-smoothing tests
- `tools/run_headless_rng_test.sh`
- Editor play: camera, controls, objective banners, stall, sea impact, restart

### What the passing tests actually cover

RNG sequence, flight-math helpers, loader metadata for six targets, a short synthetic objective list, input packets fed without the `Input` singleton, a few `FlightModelMvp.step` calls, SimCore tick pass order / `param_2` / phase gate, a four-frame replay, and the presence of mission and HUD nodes.

They do not cover rendering, camera motion, keyboard integration, stall and out-of-bounds timers, the full six-step Mission 1 from the JSON file, or weapons. Sea/island impact volumes are covered by `test_world_collision_mvp.gd` (not editor play).

## H. Recommended Next Steps

The two sims should stay apart until one change has a single owner. Mission 1 sea/island solids are in place; the headless baseline includes them.

**Recommended milestone:** `04958` `local_f54` gather (clipped verts → poly buffer), or `15762` `1562e` poly emit, or `01be4` ABI — still without merging integrators.

1. Port `local_f54` / post-`01ba8` vertex gather on `04958`, or `FUN_0001562e` on `15762`.
2. Trace D2/D3/A2 into `01be4` mid-entry after `04e4e`.
3. Only after ownership is explicit, decide whether player motion should move into `SimCore` or whether `SimCore` remains a parity lab.

Later work, in the order requested:

### 1. Flight simulation

Keep `FlightModelMvp` as the playable integrator until a vertical slice of `FUN_0000e792` can replace one behavior at a time (speed, then vertical speed, then contact). Port `FUN_00011564` before expecting entity RNG to match the original. Do not treat the ID05 LCG as that generator.

Fill in `FUN_00005df8` and `FUN_00006fb8` as their own small change. Their C bodies are already known. Update `docs/ROADMAP.md` and `docs/IMPORT_STATUS.md` when that happens, so "unknown" is not left in place.

### 2. HUD and cockpit

The current HUD already reflects `AircraftState`. The next HUD step is a written field map from original cockpit values to those snapshot keys, then a gauge only where the map is proven. A 3D cockpit before that map would be new art, not recovered behavior.

### 3. Map and terrain

The playable world is one plane and one box with matching MVP solids. A navigation map, height field, or Pacific layout can build on `WorldBuilderMvp.impact_reason_at` / the StaticBody shapes — still not original terrain.

### 4. 3D rendering

Replace the box aircraft only after the flight state it displays is the state you intend to keep. Original projection remains `FUN_0000739a` and is unported. Chase-camera tuning is independent of that port.

### 5. Mission gameplay

Mission 1's objective order is in place for an authored school flight. Before a second mission, use the JSON fields that are currently ignored (`success`, `start_mode`) or remove them, so data and code describe the same rules. Combat, weapons, and AI are a later project: the original dispatch wrappers are identified and have no Godot counterparts.

### 6. Original-game fidelity

Fidelity work is the `SimCore` track: tick hooks, `FUN_0000435a`, then real callers of `FUN_0000e792`, then a binary trace if one can be captured. Publish that track as parity research. Do not describe it as the flight the player feels until the scene calls it.

## I. Project Maturity

Qualitative ratings from the files and the test run. These are not completion percentages.

| Area | Rating | Why |
| --- | --- | --- |
| Technical foundation | Usable, split in two | Scenes, data, and scripts have a clear layout and a headless runner. Player state and `SimCore` state are not one system |
| Mission 1 playability | Playable as an authored slice, not play-tested here | Code path covers boot, fly, objectives, fail, and restart. No editor session confirmed it |
| Flight simulation fidelity | Early approximation | One reconstructed smoothing rule plus arcade integration. The original entity update is not what moves the aircraft |
| Visual fidelity | Placeholder | Primitive meshes, a label HUD, no cockpit, no original camera |
| Reverse-engineering coverage | Structural on a few seams | Tick order, three math helpers, and the ID05 LCG are in code. Most of `Pacific Conflict.c` and the ID segments are unread by the port or documented only |
| Automated test coverage | Narrow, currently green | 11 of 11 Godot scripts pass; Python QA passes. Coverage is still limited to logic, fixtures, and scene structure. Rendering, input devices, and the full mission are untested |

## J. Darkwood Project Readiness

The names Accueil, Conception, and Télécharger are not defined in this repository. The notes below say what a public page can claim if those three sections are a home page, a design page, and a download page.

### Accueil

Supported:

- A Godot reimplementation is in progress.
- The default scene is a Flight School prototype: keyboard flight, a chase camera, a text HUD, authored objectives, and success or failure.
- The world is a placeholder sea and island with matching MVP collision volumes.

Needs verification before it is said in public:

- That the prototype is enjoyable or that a person has completed the objective list. This assessment did not play it.
- Any claim of visual or flight likeness to the 1991 game.

Do not claim: a finished campaign, combat, a cockpit, or a downloadable game build.

### Conception

Supported, if the wording stays precise:

- Behavior is taken from decompiled C (`Pacific Conflict.c`, `ID01.c`–`ID09.c`) and reimplemented where a contract and a test exist.
- Tick order, the ID05 random generator, and three flight helpers are reconstructed in `SimCore` / `FlightMath` / `Rng68k`.
- The aircraft the player flies uses a separate, simpler model (`FlightModelMvp`). The mission scene does not call `SimCore.tick()`.
- Docs in the repo distinguish reconstructed, inferred, and unknown behavior. Some of those docs are stale; see section F. The code is the authority.

Do not claim: that the original update function has been ported, that the loader runs original CODE segments, or that tests prove parity with the Macintosh binary.

### Télécharger

Supported:

- The project is source that opens in Godot 4.5 (tested here with Godot 4.6.2).
- Run instructions in `README.md` match the main scene.
- Headless tests exist. After tick 38 (11544-callsite + flags_685&2 + `@` field_18c): Godot 13 passed / 0 failed, Python regression passed.

Not supported:

- A packaged build. There is no export preset in the repository.
- A statement that the test suite is green.
- A statement that installing the project yields the original game.

A download section can offer the source repository and the Godot run command. It should say the build is a prototype and that automated checks were last seen failing.
