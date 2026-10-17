# Cockpit instrument panel (CODE segment 3) — iterations 159–169, 2026-10-17

The instrument panel is drawn by CODE segment 3 (`ID03`). Offsets are
physical file offsets in `ID03.bin`. Byte sequences, call relations and
label strings are **[PROVEN]**; gauge identities follow from the labels
(**[STRONG INFERENCE]**); other interpretations are marked.

## Label strings

Labels come from `STR#` 129, loaded at start-up by ID07
`load_str129_string_table` into the pointer table `A5-0xf46` (slot *n* at
`A5-0xf46 + 4*n`). The text is in
`artifacts/reverse-engineering/resources/resource_dasm_Hellcats_app/`
(`…STR#_129_English Strings_<n-1>.txt`; files are 0-based, game slots
1-based). Calibration: slot 93 = "Out of memory.  Sorry", the message used by
ID02 `fatal_memory_error_exit`. A `\p` prefix marks strings kept as Pascal
strings by the loader.

| Slot | Text | Used by |
|---|---|---|
| 1 | Unable to store instrument panel to disk | ID04 `FUN_000003c2` (iteration 171) |
| 61 | Hellcats requires a Macintosh with color QuickDraw and a 68020 or higher | ID04 `FUN_00003d42` = JT $f2 start-up gate (iteration 171) |
| 65 | ALTITUDE | type 0 |
| 66 / 67 | AIR / SPEED | type 1 |
| 68 | CLIMB | type 3 |
| 69 | RPM | type 5 |
| 70 / 71 | Manifold / Pressure | type 4 |
| 72 | DIRECTION | type 6 |
| 73 / 74 | TURN / BANK | type 2 |
| 75 / 76 / 77 | FLAPS / AMMO / Fuel | `draw_flaps_indicator` (0x4c42) / `draw_ammo_counter` (0x4ecc) / `draw_fuel_gauge` (0x532e), outside the type switch (iteration 171) |

## Instrument types (`draw_instrument`, ID03 0x3c02)

| Type | Function | Gauge |
|---|---|---|
| 0 | `draw_altimeter` (0x1876) | altimeter |
| 1 | `draw_airspeed_indicator` (0x1b48) | airspeed |
| 2 | `draw_turn_and_bank_indicator` (0x2d1c) | turn and bank |
| 3 | `draw_climb_indicator` (0x1fee) | rate of climb |
| 4 | `draw_manifold_pressure_gauge` (0x2600) | manifold pressure |
| 5 | `draw_tachometer` (0x22fe) | engine RPM |
| 6 | `draw_direction_indicator` (0x2950) | heading |
| 7 | — | nothing drawn |
| 8 | `FUN_000032b8` | unidentified (no label string) |
| 9 | `FUN_000038fc` | unidentified (no label string) |

`draw_instrument` first draws the bezel with
`draw_ring_with_status_indicators` (flags `0x1b` for type 6, otherwise
`0x0f`), then calls the drawer, then stores geometry in a 16-byte record per
type at `A5-0x12a2`. Ghidra decoded the switch table after `JSR $3a(A5)` as
code; the table was parsed from the bytes.

## Drawing pipeline

1. `begin_instrument_supersample` (0x1538): in 1-bit mode a 1× black-and-white
   port; otherwise coordinates ×3 and a 3×-size black-and-white port
   (`new_offscreen_bw_port`, 0x2a8).
2. The gauge drawer draws scales, needles (through the function pointer
   `A5-0x2118`), vector-font numbers (`draw_vector_number`, 0x912) and centred
   labels (`set_scaled_text_style`, 0x6, `StringWidth` / `DrawString`).
3. `antialias_downsample_bw_3x` (0xa3c): each output pixel is a 7×7
   weighted sum (total weight 969) of the 3× bitmap, converted to a grey
   palette index with `nearest_palette_index_rgb` (0xf4) and plotted.
4. `dispose_offscreen_bw_port` (0x33c).

Coordinates are design units scaled by `scale_design_4800` (0x8a:
`A5-0x149e · v / 4800`) and centred with ID02 `design_x_to_screen` /
`design_y_to_screen` (half view width `A5-0x1372` / height `A5-0x1370`).

## Bezel

`draw_ring_with_status_indicators` (0x514): black disc, grey ring
(`PenSize(w/10)`), and for flag bits 0–4 a `draw_spinning_disc_indicator`
(0x35e) on the diagonals at `(d/2)·cos 45° + 30` design units (constant
`0xb50 >> 12`). The "indicator" is a grey disc with a black slot whose angle
steps by 45° per call (phase `A5-0x2112`, size `A5-0x2114`).
**[HYPOTHESIS]** These are bezel screw heads, the stepping phase varying the
slot orientation from screw to screw.

## Open questions

- Types 8 and 9 (FLAPS / AMMO / Fuel turned out to be separate gauges).
- The needle function pointer `A5-0x2118` and the per-type record at
  `A5-0x12a2`.
- ID04 users of slots 1 and 61 (`FUN_000003c2`, `FUN_00003d42`) are located but
  not yet decoded.
