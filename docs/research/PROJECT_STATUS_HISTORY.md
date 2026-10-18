# Hellcats Over the Pacific — Project Status

> Historical assessments retained for traceability. Use
> [`../PROJECT_STATUS.md`](../PROJECT_STATUS.md) for current status.

> **Architecture update:** new source-faithful Godot work now starts in the
> isolated strict-port namespace described in
> [`STRICT_PORT_FOUNDATION.md`](../STRICT_PORT_FOUNDATION.md). The playable Mission
> 01 prototype below is preserved for comparison, but it is not the architectural
> source of truth for new simulation logic.

Latest assessment: 17 October 2026. The dated update below supersedes conflicting claims in the older assessment, retained afterward for context.

## Port improvement assessment — 17 October 2026

### Current position

**The strongest next milestone is one source-backed aircraft running in the playable Godot scene.** The repository has a playable training prototype and a much larger reconstruction harness, but the two still run separately. More function renaming alone will not close that gap.

Verified in this assessment:

- `PlayerAircraft._physics_process()` still calls `FlightModelMvp.step()`. `MissionController` exposes mission flags but explicitly does not call `SimCore.tick()`.
- The live scene has authored training objectives, telemetry, restart/failure flow, a chase camera, a box aircraft, a sea plane and a box island. These are useful scaffolding, not original mission or visual parity.
- `SimCore` contains substantially more than the old status suggests: overlay RNG initialization/consumption, control and propulsion slices, landing/contact branches, weapon spawn paths, object/template construction and cleanup. Some helpers still use injected entities, synthetic memory or deferred bodies; their presence does not establish complete gameplay.
- The decompilation tracker, iteration 316, records **736 inventoried functions: 686 RENAMED, 44 VERIFIED, 6 BLOCKED**. These are reconstruction workflow states, not Godot implementation or game-completion percentages. Most renamed functions still need independent verification.
- Both immutable exports (`*.c`) and annotated reconstructions (`*.decomp.c`) are now inside `sources/resedit/CODE/`, alongside CODE binaries. The older statement that they live outside this repository is obsolete. These are decompiled exports, not evidence that the original developer source has been recovered.
- New subsystem notes cover sound, cockpit instruments, rendering, ship controllers and pilot persistence. There is enough evidence to plan concrete ports in these areas; the original binaries remain necessary where decompiler output is ambiguous.
- The curated ResEdit corpus is now deterministically inspectable: 119 resources
  across all 30 on-disk type directories have local binary and JSON companions.
  Of these, 116 structures are decoded, with 1,096 internal elements, 32 proven
  outgoing resource links and 33 static executable-reference annotations. See
  [RESOURCE_ANALYSIS.md](../RESOURCE_ANALYSIS.md). The three unresolved/truncated
  primary structures are `DATA:0`, `MDPL:128`, and `DITL:135`.

### First priority: correct the simulation contract

**1. Separate prototype control fields from recovered engine fields.** In `flight_model_mvp.gd`, `movement_66a` drives yaw and `movement_672` drives roll. In the recovered overlay, `update_tachometer_needle` (`FUN_0000c9c2`) reads player `+0x66a`, while `update_manifold_needle` (`FUN_0000ca44`) reads `+0x672`; the sound driver also reads `+0x66a` for engine/wind playback. RPM and manifold pressure are strong semantic inferences supported by those consumers. Reusing the prototype axis interpretation in a parity adapter would produce the wrong telemetry and behavior. Fuel is another example: fields currently named `weapon_count_67d/67e` feed the two fuel needles. Preserve proven offsets, document confidence, and introduce explicit gameplay-facing names without blindly renaming all uses. Do not guess the remaining field meanings.

Completion criterion: a reviewed field/unit/width mapping for input, attitude, velocity, engine, fuel, gear and flaps, with source consumers and conversion fixtures. See [INSTRUMENT_PANEL.md](../INSTRUMENT_PANEL.md), especially “Live needles,” and [SOUND_SYSTEM.md](../SOUND_SYSTEM.md).

**2. Reproduce the controller call chain before making it authoritative.** `SimCore._update_single_entity()` currently runs `044a4` and then aircraft-update slices directly. The recovered code separates world-object rate updates from controller ticks: `advance_frame_and_tick_controllers` (`092e4`) calls definition tick handlers, and `aircraft_tick` (`e5aa`) calls the aircraft state handler (`e792` for the player, other handlers for AI). Preserve this separation, controller identity, mission gates and RNG consumption. Otherwise adding more entity types risks applying aircraft behavior to unrelated objects or updating an aircraft twice. Port the necessary live-frame sequence, rather than assuming the four-pass `044e8` loop is the complete original frame.

Completion criterion: one aircraft takes its original controller/state path exactly once per simulated frame; a non-aircraft controller follows its own handler; ordering and RNG draw counts are asserted. See [SHIP_CONTROLLERS.md](../SHIP_CONTROLLERS.md), “Who calls the handlers,” and `aircraft_create`, `aircraft_tick`, `advance_frame_and_tick_controllers` in `Pacific Conflict.decomp.c`.

**3. Add an independent behavior reference.** The current replay test compares two four-frame runs of the same implementation. Its runner creates a default `SimCore` without populating a playable aircraft or enabling mission phase. Input packets are recorded, not translated into flight controls. That verifies repeatability of this harness, not responsive flight or agreement with the original.

Start with populated aircraft/template fixtures and input-to-state assertions. Then compare against an independent reference for selected deterministic routines, and capture original-runtime traces if emulator instrumentation is available. Validate integer widths, signed shifts, division/rounding, initial state, tick cadence and conditional RNG draws. Adjacent accumulator/threshold boundary cases remain a useful small task, but should support this integration milestone.

Completion criterion: a throttle or control change causes the expected aircraft-state change; identical inputs reproduce a populated flight; selected original/reference outputs agree. No original-runtime capture was performed for this assessment.

### Second priority: put reconstructed behavior into play

**4. Add a selectable reconstructed-flight backend for one aircraft.** Build a narrow adapter between Godot input, the recovered aircraft controller/template state and a read-only render/HUD snapshot. Establish coordinate axes, original distance/angle units and simulation cadence before converting into meters/degrees. Load real template values where proven; explicitly identify any remaining substitutions. Keep the prototype available during migration, and give exactly one backend ownership of aircraft motion per run.

Completion criterion: the training scene visibly flies using the reconstructed path, input reaches it, HUD and mesh read the same state, and restart resets controller state, mission gates and RNG. Run automated checks plus the existing manual flight smoke checklist. This is a medium-to-large integration task, not a one-line replacement of `step()` with `tick()`.

**5. Import one original object and one original scene subset.** The template/object constructors, vertex transforms, face records and renderer notes now give a practical starting point for exporting original geometry into Godot meshes. Begin with one aircraft or static object, checking vertex counts, face indices, scale, orientation, palette and silhouette against screenshots. Then decode one mission's placements and terrain/contact data. The authored training mission must not be assumed to share original mission numbering or setup; the reconstructed aircraft-creation notes identify Flight School as original mission 2.

Use Godot rendering for the first import. The original span rasterizer, QuickDraw paths and Macintosh segment loader are separate fidelity work; they need not be recreated before displaying original geometry. However, some original collision checks occur inside rendering (`submit_object_faces`), so equivalent gameplay contact must be preserved explicitly when replacing that renderer. Terrain, runway and carrier contact should share geometry/height data with the displayed world.

Completion criterion: one recognizable original object and a documented scene subset appear at verified transforms, with matching collision. See [OVERLAY_RENDERER.md](../OVERLAY_RENDERER.md), [RASTERIZER.md](../RASTERIZER.md) and the template initialization/instantiation functions. This remains a high-effort data-decoding task; full asset extraction was not demonstrated here.

### Visible improvements supported by the recovered code

**6. Cockpit and instruments — medium effort once telemetry is mapped.** ID03 gauge drawing and overlay needle updates are documented for airspeed, altitude, climb, heading, RPM, manifold pressure, gear, flaps, ammunition and fuel. Start with a Godot cockpit panel using verified value-to-needle mappings, then refine original layout and artwork. Keep gauges whose underlying state is not yet modeled explicitly deferred. This gives visible authenticity and helps diagnose the simulation.

**7. Sound — a comparatively small first feature, medium effort for original behavior.** Bring an engine loop into the live scene, then add original event priorities, looping/release behavior and engine/wind rate rules from `update_game_sounds`. Nothing in the current Godot asset tree imports the original audio. The 13 `snds` exports are now structurally verified classic format-1 `snd ` resources with exact 16.16 sample rates, loop points, 8-bit mono sample spans and names; use `tools/resedit.py` for deterministic retrieval. Playback priority and live engine/wind rate behavior still require implementation.

Completion criterion: the engine responds to validated engine state, events trigger the appropriate sound with correct priority, and no incorrect sample rate is presented as original fidelity. See [SOUND_SYSTEM.md](../SOUND_SYSTEM.md) and [tools/mac_resources/README.md](../../tools/mac_resources/README.md).

**8. Landing, combat and AI — high effort, build a small complete encounter.** After the aircraft/scene bridge, implement a runway or carrier approach, followed by one weapon, one target, collision/damage, effects and a mission outcome. The recovered source now identifies aircraft state handlers, target acquisition, bullet/shape collision, ship hit counts and sinking steps. These are actionable references, but Godot weapon counters/spawn helpers alone are not a working combat system. Add one AI behavior and one ship type only after the basic encounter works.

Completion criterion: a fired projectile exists in the world, can hit and damage a target, updates the objective/score, produces feedback and cleans up deterministically. Original landing conditions must distinguish safe contact from crashes rather than treating all terrain contact as mission failure.

**9. Mission selection, briefing and pilot progression — medium-to-high effort.** ID02/ID04 reconstruction and [PILOT_ROSTER.md](../PILOT_ROSTER.md) provide references for selection, outcomes, summaries and persistence. Start with a verified scenario and mission result, then expand the roster/awards flow. Recreating Macintosh dialog machinery is unnecessary for a Godot UI, but the data and outcome rules should be preserved where proven.

### Recommended sequence and progress measures

1. Correct semantic mappings and add populated, input-responsive reference fixtures.
2. Implement the live controller sequence and one reconstructed aircraft backend.
3. Deliver one source-backed training/landing scene with one imported model, cockpit readouts and engine sound.
4. Deliver one complete combat encounter with damage and mission outcome.
5. Expand missions, AI, ships, pilot progression and visual fidelity from that working base.

Measure completed playable behaviors, independently checked routines and imported assets. A function-count percentage would be misleading: platform helpers, renamed functions and tested mathematical slices contribute very different amounts to the playable port. The six blocked function entries should be tracked by dependency; they are not automatically blockers for all Godot work. Full LoadSeg emulation and pixel-identical rasterization can remain deferred unless a chosen fidelity milestone requires them.

Documentation cleanup is small and useful now: synchronize `ROADMAP.md`, `IMPORT_STATUS.md`, `CONVERGENCE_BACKLOG.md` and the README with the current overlay RNG, implemented `0435a` branches, in-repository source paths and the still-disconnected gameplay backend. Several older rows describe work already present in code as unstarted, while “Done” mission bridge wording overstates runtime integration.

### Validation performed for this assessment

- Godot 4.6.2 headless suite: **13 scripts passed, 0 failed**, exit 0, using an explicit `/tmp/hellcats-status-20261017.log`. The engine subsequently printed a macOS certificate diagnostic; no script test failed.
- Python regression: **all checks passed**, including the optional compiled ID05 RNG check.
- Protected-source checksum verification: **all 32 listed files matched**. The checksum utility also reported one malformed manifest line; no listed file mismatch was reported.
- No manual play, visual comparison, sound audition, original-emulator trace or end-to-end original mission validation was performed. Headless scene-instantiation tests do not establish those properties.
- This assessment updates documentation only; no gameplay implementation was changed.

The sections below retain the earlier assessment and may describe an older reconstruction state.

## Focused convergence update — 16 October 2026

**Verified:** baseline recheck passed all 13 Godot scripts and Python regression checks. The earlier class-resolution / fixture failures did not recur. An initial sandboxed Godot launch crashed in its user-log rotation; rerunning with an explicit `/tmp` log outside the sandbox succeeded.

One flight-harness correction: `SimCore._apply_randomized_control_offsets` now narrows each perturbed `movement_662` / `movement_666` sum to signed 16 bits **before** clamping. `FUN_0000e792` at `Pacific Conflict.c:14105–14138` assigns to `short sVar21` before `FUN_00002e08` (absolute value, lines 3461–3468). Previously an overflow could clamp to the opposite sign. The reverse-engineering review independently confirmed the ordering. Mission 1 continues to use `FlightModelMvp`; this change is confined to `SimCore`.

Validation: new deterministic overlay-table fixtures failed four overflow assertions before the fix (12 scripts passed / 1 failed), then all 13 scripts passed. Fixtures also check ordinary positive/negative deltas, a clamp boundary, two RNG draws, and the subsequent status override. Commands run from repository root:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --log-file /tmp/hellcats-loop-runtime.log --script res://tests/run_all.gd
python3 tools/qa/test_regression.py
git diff --check
```

Final Godot and Python exits: **0**. No GDScript parse errors; Godot logged a macOS `get_system_ca_certificates` diagnostic after the passing summary. Python's optional C RNG check compiled and passed. No manual gameplay or visual checks were performed. No original-binary trace was captured; fidelity here is to the decompiled short-assignment semantics, not demonstrated whole-game parity.

Next focused loop: verify signed-width behavior in the adjacent control accumulator / threshold decrement (`FUN_0000e792:14139–14167`) with boundary fixtures. Broader dispatch and playable-flight migration remain unresolved.

This report describes the Godot repository as it exists today. It does not describe a planned game. Claims are tagged:

- **Verified** — read from a file, scene, script, original C source, or a command that was run.
- **Inference** — a conclusion that follows from those files, but was not executed as gameplay.
- **Unknown** — not established by the files inspected.

Manual play in the Godot editor was not performed. Headless tests are not evidence of how the game looks or feels.

Original decompiled sources live outside this repository, under `Hellcats-Over-the-Pacific_Mac_EN/ResEdit/CODE/` (`Pacific Conflict.c`, `ID01.c`–`ID09.c`).

## A. Executive Summary

The project is a clean-room Godot 4 reimplementation of the 1991 Macintosh flight simulator *Hellcats Over the Pacific*. Two tracks sit side by side.

The first track is a **playable Mission 1 prototype**. Launching the project opens Flight School. The player flies a box-shaped aircraft over a flat sea with keyboard controls, a text HUD, an attitude strip, a chase camera, one checkpoint ring, and an authored objective list. Success, failure, and restart are implemented in script. **Verified.**

The second track is a **deterministic reverse-engineering harness**. `SimCore` reproduces the original tick order, a few math helpers, and an ID05 random-number generator. It is exercised by tests. The running mission does not call it. **Verified:** `godot/hellcats/mission/mission_controller.gd` states that the Mission 1 scene loop does not call `SimCore.tick()`.

This is not a faithful recreation of the original game. Combat, a cockpit, a real terrain model, original rendering, and the original flight function are absent or only approximated. **Verified** from the scene and script tree.

`godot/project.godot` names the project "Hellcats Sim", targets Godot 4.6 features, and sets the main scene to `res://scenes/main/Main.tscn`.

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

`SimCore` also keeps mission phase and flag fields, four entity arrays, a trace log, and a replay runner. **Verified** in `godot/hellcats/core/sim_core.gd`, `flight_math.gd`, `rng.gd`, `loader_metadata.gd`, `replay_runner.gd`.

## C. Partially Implemented Features

### Flight physics

**Verified.** `FlightModelMvp` is an arcade integrator with a reconstructed smoothing rule bolted on. It is not `FUN_0000e792` (`Pacific Conflict.c` from line 14018), which is the large per-entity update for movement, status, weapons counters, and ground contact.

`SimCore._update_single_entity` applies a smaller set of those slices to `EntityState` objects: randomized control offsets, a control-gate accumulator, threshold decrement, and the same smoothing rule. The comment on that function says it stands in for `FUN_000044a4` → `FUN_0000435a` / `FUN_0000e792`. The original call graph does not work that way. See section E.

`godot/hellcats/core/fixed.gd` (`Fixed68k`) is a 68000-style fixed-point helper. Nothing in the scenes or tests references it. **Verified** by search.

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

**Verified.** The runner is `godot/tests/run_all.gd` (13 scripts). `godot/hellcats/tests/` holds older `SceneTree` scripts, including `test_sim_entity_controls.gd` and `test_movement_smoothing.gd`, which the runner does not call.

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
godot/
  project.godot
  scenes/main/Main.tscn
    scenes/missions/Mission01Training.tscn
      World          hellcats/world/world_builder_mvp.gd
      PlayerAircraft hellcats/player/player_aircraft.gd
        AircraftMesh, Wings, FollowCamera
      Checkpoints    hellcats/mission/checkpoint_manager.gd
      HUD            hellcats/ui/hud_mvp.gd + hud_attitude_strip.gd
      MissionController
```

`godot/` is the self-contained Godot project root: it contains `project.godot`, scenes, JSON, gameplay scripts under `godot/hellcats/`, and the test runner. **Verified.**

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

**Fix (verified):** avoid those annotations in favor of untyped / base types (`Control`, `Node3D`) and `call()` / `has_method()` where needed. Align `tools/qa/test_regression.py` `EXPECTED_RUNNER_PATHS` with `godot/tests/run_all.gd`. Make `godot/hellcats/tests/fixtures/proven_loader_targets.json` byte-identical to the migrated fixture (tabs vs spaces).

### Python regression

```bash
python3 tools/qa/test_regression.py
```

Exit code **0**. All checks passed: `runner-layout`, `loader-fixture`, `replay-fixture`, `mission-mvp-data`.

### Godot headless suite

```bash
HOME=/tmp/hellcats-godot-home /Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/run_all.gd
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

- `godot/hellcats/tests/*.gd`, including entity-control and movement-smoothing tests
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
