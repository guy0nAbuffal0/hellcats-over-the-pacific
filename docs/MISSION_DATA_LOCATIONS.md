# Mission Data Locations

## Result

The eight selectable missions are not stored as complete records in `STR#`, `DITL`, or any `DATA` resource. Their scene/object descriptions are in the data fork of the separate file `sources/hellcats/Pacific Conflict`; mission-number-specific rules are also hardcoded in the executable overlay contained at the front of that file. The main application's resources provide the selection UI, saved scenery filename, result text, loader, and host runtime.

Certainty terms in this report are strict: **PROVEN** means directly supported by original bytes or instructions; **VERIFIED** means confirmed by deterministic parsing or multiple independent code paths; **INFERRED** means the role is strongly suggested but not closed; **UNKNOWN** means the evidence is insufficient.

## External file layout

`sources/hellcats/Pacific Conflict` is 255,360 bytes (`0x3e580`), SHA-256 `ee6040c7c38586551f95bf62a96453eef41b8b27409bc89d7a6689dc2c8b5030`.

The first 32 bytes are eight big-endian 32-bit values:

```text
00000107 0001a75c 00000dc8 0000b2a4
00000000 000010f2 00007078 000003d8
```

`CODE:8` `load_overlay_from_resource` (`ID08`, function offset `0x0006`) reads that header, two image chunks of `0x1a75c` and `0x0dc8` bytes, then relocation streams of `0x7078` and `0x03d8` bytes. `alloc_and_read_resource_payload` (`ID08:0x0348`) reads the remainder of the open data fork into host global `A5-0x12fc`. Therefore the world/mission payload is exactly:

| Range in `Pacific Conflict` | Length | Meaning | Certainty |
| --- | ---: | --- | --- |
| `0x00000..0x0001f` | `0x20` | overlay header | PROVEN |
| `0x00020..0x1a77b` | `0x1a75c` | first overlay image | PROVEN |
| `0x1a77c..0x1b543` | `0x0dc8` | second overlay image | PROVEN |
| `0x1b544..0x225bb` | `0x7078` | first relocation stream, 3,599 8-byte records | VERIFIED |
| `0x225bc..0x22993` | `0x03d8` | second relocation stream, 123 8-byte records | VERIFIED |
| `0x22994..0x3e57f` | `0x1bbec` | packed scene/world/mission payload | PROVEN |

The filename is loaded from `HEL1:127` at record offset `0x2a`: the Pascal string `Pacific Conflict`. `bootstrap_window_and_load_overlay` (`CODE:8`, `ID08:0x039c`) passes it to the loader. Failure reaches `show_scenery_open_error_alert` (`CODE:4`, `ID04:0x044e`) and `ALRT`/`DITL:256`. `ALRT`/`DITL:261` separately instructs the user to install both `Hellcats` and `Pacific Conflict`. This proves that the companion file is required, not an optional embedded resource.

## Mission directory and exact descriptors

The payload root begins at file offset `0x22994`. Its kind byte is 3 and its child count at root `+0x18` is 41. `init_mission_object_tables` (`Pacific Conflict` overlay `0x16e2`) instantiates the root and copies its child entries; each packed child record is `0x18` bytes and its relative descriptor pointer is at `+0x14`. `start_mission_scene` (`0x3ac4`) selects the entry at `root_runtime_table + mission_number * 0x18 + 0x74`, algebraically child index `mission_number + 4`.

The following offsets were read deterministically from the original big-endian payload. Descriptor file offset is `0x22994 + relative_pointer`.

| Mission number | UI name | Root child | Child record | Relative descriptor | Descriptor file offset | Certainty |
| ---: | --- | ---: | ---: | ---: | ---: | --- |
| 2 | Flight School | 6 | `0x22a3e` | `0x000008ae` | `0x23242` | VERIFIED |
| 3 | Bomb Base | 7 | `0x22a56` | `0x0000661c` | `0x28fb0` | VERIFIED |
| 4 | Capture Island | 8 | `0x22a6e` | `0x000150e8` | `0x37a7c` | VERIFIED |
| 5 | Flying Fortress | 9 | `0x22a86` | `0x0001620e` | `0x38ba2` | VERIFIED |
| 6 | Scramble! | 10 | `0x22a9e` | `0x00018cca` | `0x3b65e` | VERIFIED |
| 7 | Divine Wind | 11 | `0x22ab6` | `0x000196cc` | `0x3c060` | VERIFIED |
| 8 | Flattop | 12 | `0x22ace` | `0x0001991a` | `0x3c2ae` | VERIFIED |
| 9 | The Duel | 13 | `0x22ae6` | `0x00019f40` | `0x3c8d4` | VERIFIED |

The names themselves occur in `DITL:129` items 9–16. `run_scenario_selection_dialog` (`CODE:4`, `ID04:0x0c02`) maps those radio items to mission numbers 2–9. This proves the UI mapping, but the names are not mission structures.

## Full execution path

1. `run_scenario_selection_dialog` returns mission 2–9.
2. `start_new_mission` (`CODE:2`, `ID02:0x35e4`) calls the overlay hook at `A5-0x109a`.
3. `overlay_main_entry` (`Pacific Conflict:0x1112`) installs `start_mission_scene` (`0x3ac4`) in that hook.
4. `start_mission_scene` activates the corresponding root child and constructs runtime objects from the external descriptor graph.
5. `run_flight_session` (`CODE:2`, `ID02:0x04fc`) drives the frame hook `A5-0x107a` (`Pacific Conflict:0x6598`) and input/outcome hook `A5-0x106a` (`0x740a`).
6. Overlay controller/AI routines write the signed objective state at host `+0xce`: zero pending, positive success, negative failure.
7. `conclude_mission` (`CODE:4`, `ID04:0x31aa`) and the summary dialog consume the outcome and `STR#:129` messages.

## Located hardcoded objective rules

These are executable rules, not claims that the full descriptor schema is decoded.

| Mission | Original rule evidence | Function/offset | Certainty |
| --- | --- | --- | --- |
| Bomb Base (3) | Bomb impact within `0xce40` of `(-0x3bcd3, 0x2b246a)` sets objective success; same point is map target T | bomb-impact branch near `0x12a2a`; `plot_mission_map_symbols:0x0954` | VERIFIED |
| Capture Island (4) | Bomb impact within `0xce40` of `(-0xf2bf12, 0xb242d8)` sets success; same point is map target T | bomb-impact branch near `0x12a2a`; `plot_mission_map_symbols:0x0954` | VERIFIED |
| Flying Fortress (5) | destruction of aircraft template/type 2 sets failure; friendly-bomber route completion sets success | aircraft-damage branch near `0x10400`; `tick_ai_1b370_mission:0x10f68` | VERIFIED |
| Scramble! (6) | destruction of aircraft template/type 3 sets success | aircraft-damage branch near `0x10400` | VERIFIED |
| Divine Wind (7) | controller creates ten mission targets; empty target list sets success; loss of the protected friendly facility/carrier sets failure | controller key `0x14`; `remove_mission_target:0x17ffe`; `step_sinking_object:0x14d86` | VERIFIED |
| Flattop (8) | sinking type-`0x15` mission ship near enemy facility kind `0x100` sets success | `step_sinking_object:0x14d86` | VERIFIED |
| The Duel (9) | enemy-facility ship result sets success; protected-friendly-facility ship result sets failure | `step_sinking_object:0x14d86` | VERIFIED |
| Flight School (2) | mission map is deliberately unavailable; complete training objective sequence is not yet identified | `run_map_dialog:ID04:0x3976` | PROVEN for map exclusion; UNKNOWN for objectives |

`STR#:129` slots 29–37 provide generic and mission-specific completion/failure prose, including B-17, Henderson Field, and carrier outcomes. They corroborate the branches but are not objective definitions.

Starting pose, aircraft loadout, teams, AI controller selection, and most entity placement are encoded in or selected while instantiating the mission descriptor subtrees. Their exact field schemas are still **UNKNOWN**; it would be inaccurate to promote the offsets above into a fully decoded mission format.

## Current Godot gap

`godot/data/mission_01/mission_01_training.json` labels its content as an authored MVP rather than extracted data. Its `[0,1200,0]` spawn, heading 90, speed 95, throttle setting, checkpoint sequence, altitude/bank objectives, and objective timing are not traced to the original descriptor at `0x23242`. `godot/scripts/mission_controller.gd` and `mission_objectives_m1.gd` implement a simplified JSON/flag flow rather than the original scene graph and mission-specific controller branches.

The faithful replacement path is: parse the external root and the mission-2 subtree without semantic guesses; retain byte offsets for every decoded field; then map proven descriptor fields and original objective transitions into a new data layer. The current prototype should remain the explicit fallback until that parser has deterministic fixtures.

## Evidence table

| Component | Original source | Function/resource | Certainty | Missing evidence |
| --- | --- | --- | --- | --- |
| Mission selection | main resource fork | `DITL:129`; `run_scenario_selection_dialog` | PROVEN | none for 2–9 mapping |
| Mission scene roots | `Pacific Conflict` data fork | payload `0x22994..0x3e57f`; table above | VERIFIED | child field semantics |
| Mission objectives | external descriptors plus overlay code | mission branches listed above | VERIFIED in listed branches | Flight School rules; full trigger graph |
| Starting state/loadout | mission descriptor subtrees | first descriptor at `0x23242` | UNKNOWN | packed record decoder and initialization trace |
| Enemy/friendly spawning | descriptor objects plus controller factories | `start_mission_scene`, controller tables | INFERRED | definition-to-entity schema |
| Completion/reporting | overlay objective word and host UI | host `+0xce`; `conclude_mission`; `STR#:129` | VERIFIED | exact scoring formula still partial |

## Highest-value next step

Implement a read-only deterministic parser for the kind-3 root's 41 `0x18`-byte children, then recursively decode the Flight School descriptor at file `0x23242`. Log every record's original file offset and follow construction through `instantiate_object_from_desc`. This single step should expose starting state and controller references while testing the general format needed by all other missions.
