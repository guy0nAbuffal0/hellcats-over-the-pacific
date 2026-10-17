# Ship controllers (Pacific Conflict) — iterations 255–258, 2026-10-17

Damage, firing and sinking of ships in the overlay. Function names are those
in `Pacific Conflict.decomp.c`; byte facts come from the overlay file
`hellcats-over-the-pacific-sources/Hellcats/Pacific Conflict` (file offset =
runtime address + 0x20).

## Definition table [PROVEN, bytes]

`overlay_main_entry` (Block C) copies five 0x1c-byte records from runtime
0x1aa5e (file 0x1aa7e) into the keyed table `DAT_0001b524[key]`. Code
pointers in the records are stored as Ghidra address − 0x20 (Ghidra addresses are
file offsets; data labels are runtime addresses, at file offset + 0x20).

| Offset | Field |
|---|---|
| +0x00 | key word (= template type) |
| +0x02 | tick handler |
| +0x06 | create handler |
| +0x12 | extra handler (type 0x15 only) |
| +0x1a | hits to sink (copied to controller +0x32) |

| Key | Tick | Create | Extra | Hits |
|---|---|---|---|---|
| 0x15 | `step_sinking_object` | `create_flagship_controller` | 0x15154 (starts with LINK A6: a function Ghidra did not export; iteration 269) | 3 |
| 0x19 | `tick_firing_ship_controller` | `create_firing_ship_controller` | — | 2 |
| 0x18 | `step_sinking_object` | `create_basic_ship_controller` | — | 2 |
| 0x17 | `step_sinking_object` | `create_basic_ship_controller` | — | 1 |
| 0x16 | `tick_sinking_controller` | `create_sinking_controller` | — | 1 |

The record after these (key 0x1a, pointers 0x18c96 / 0x18b52 / 0x18b98 after
+0x20) is not copied by Block C.

Template types 0x15..0x19 are the ones the entity update path sends to
`sink_object_shape_at_waterline` **[PROVEN]**; reading them as ship classes is
**[STRONG INFERENCE]**. Type 0x15 alone has mission checks in
`step_sinking_object` (missions 7 / 8 / 9) **[HYPOTHESIS: the mission ship]**.

## Who calls the handlers (iteration 259)

| Slot | Caller |
|---|---|
| +6 create | `instantiate_object_from_desc` (for any template with a definition; result stored at object +8) |
| +2 tick | `advance_frame_and_tick_controllers`, or `tick_flagged_object_controllers` when `DAT_0001b870 == 3`, over the controller list `DAT_0001c25c` |
| +0xa destroy | called just before a controller is freed (iteration 270) |
| +0xe pre-render | `FUN_0000a75e`, phases 1 / 2 (iteration 270; e.g. `effect_pre_render_hook`) |
| +0x12 collision | `handle_player_contact` (player overlap, object flag +6 & 0x40) and `dispatch_collision` (iteration 262; pair table `DAT_0001b43c` overrides it for some type pairs) |

The keyed table `DAT_0001b524` is therefore general (other blocks of
`overlay_main_entry` fill other keys); the five records above are the ship
subset.

## Controller record

| Offset | Field |
|---|---|
| +0x00 | object |
| +0x04 | definition (`DAT_0001b524[key]`) |
| +0x32 | hits left |
| +0x34 / +0x36 / +0x38 | attitude angles; +0x40 drop |
| +0x3a / +0x3c / +0x3e / +0x42 | per-step rates |
| +0x44 | step interval (frames) |
| +0x46 | steps left |
| +0x48 | next step frame (`DAT_0001b838`), 1000000000 = idle |
| +0x4c | sinking started |
| +0x4e | kill credited to the player |
| +0x50 / +0x52 | firing ship: shots left / gun faces (+0x54 positions, +0xe4 aim) |

## Flow

1. Hit: `apply_hit_to_sinkable_object` decrements hits and schedules 15
   steps of list / roll and drop, first step 30 frames later.
2. Tick: `step_sinking_object` applies one step, then
   `sink_object_shape_at_waterline` cuts the faces at y = 0
   (`clip_polygon_y_nonneg`); `carry_attached_objects` moves the objects on
   deck.
3. When no face is above y = 0: carried objects removed, kill tallied,
   mission state updated, object cleaned up.
