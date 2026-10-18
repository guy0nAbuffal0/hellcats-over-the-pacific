# Cockpit and HUD data locations

## Result

The cockpit is not stored as one `PICT`. The clean application resource fork
contains five PICTs—about artwork (128/129), refueling photograph (130),
credits (131), and protection instructions (1000)—and none is a cockpit panel.
The static instrument panel is drawn procedurally by `CODE:3` with QuickDraw
into offscreen bitmaps; the `Pacific Conflict` overlay draws dynamic needles,
heading tape, radar, and readouts from flight state, including direct 4/8-bit
framebuffer line routines.

Certainty labels mean: **PROVEN** direct original-byte/instruction evidence;
**VERIFIED** deterministic/corroborated behavior; **INFERRED** plausible but
incomplete; **UNKNOWN** insufficient evidence.

## Static panel construction

`prepare_instrument_panel` (`CODE:3`, `ID03:0x5cc4`) lays out and constructs
the panel. `draw_instrument` (`ID03:0x3c02`) dispatches ten panel types:

| Type | Instrument | Drawing function | Certainty |
| ---: | --- | ---: | --- |
| 0 | altimeter | `ID03:0x1876` | VERIFIED |
| 1 | airspeed | `ID03:0x1b48` | VERIFIED |
| 2 | turn/bank | `ID03:0x2d1c` | VERIFIED |
| 3 | vertical speed/climb | `ID03:0x1fee` | VERIFIED |
| 4 | manifold pressure | `ID03:0x2600` | VERIFIED |
| 5 | tachometer | `ID03:0x22fe` | VERIFIED |
| 6 | direction/heading | `ID03:0x2950` | VERIFIED |
| 7 | empty/none | dispatch no-op | PROVEN |
| 8 | gyro | `ID03:0x32b8` | VERIFIED |
| 9 | artificial horizon | `ID03:0x38fc` | VERIFIED |

The routines use QuickDraw ovals, arcs, lines, fills, numerals, and labels from
`STR#:129` slots 65–78. `begin_instrument_supersample` (`0x1538`),
`composite_instrument_bitmap` (`0x146a`), and
`finish_instrument_supersample` (`0x1844`) implement offscreen construction.
At depth 1, composition uses the monochrome bitmap path/CopyBits semantics;
color configurations use a 3× temporary render and antialiased downsample.

Additional static panel routines construct flaps, landing gear, ammunition,
fuel, and other panel items. Their geometry is procedural and their
centers/needle lengths are recorded in the host panel table at `A5-0x12a2` for
the overlay.

## Generated `HEL2` cache, not source art

`store_panel_bitmaps_as_resources` (`CODE:3`, `ID03:0x5ab6`) writes
runtime-generated cache resources of type `HEL2`: ID 127 for the panel cache
and per-configuration IDs in the 200/300/400/500 series named `Bitmap`,
`HorizonInstrument`, `GyroInstrument`, and `GyroFlags`.
`prepare_instrument_panel` creates them when needed.

No `HEL2` directory/resource exists in the clean extracted application fork.
Therefore these are generated cache artifacts, not the original authored
cockpit source. Treating a recovered user preference/resource file containing
`HEL2` as cockpit artwork would reverse cause and effect.

## Flight state to dynamic display

The overlay's `update_view_readouts_and_overlays`
(`Pacific Conflict:0xd00c`) orchestrates panel updates. `draw_gauge_needle`
(`0xc572`) erases the previous line from the saved static panel and draws the
new line. Its callers provide these source values:

| Visible item | Flight-state source | Update function | Certainty |
| --- | --- | --- | --- |
| altimeter, two hands | player altitude/derived angle | `0xc664` | VERIFIED path; hand interpretation INFERRED |
| airspeed | player `+0x62a` | `0xc80c` | VERIFIED |
| direction | camera heading | `0xc8d6` | VERIFIED |
| vertical speed | overlay climb-rate value `DAT_0001bc80` | `0xc948` | VERIFIED |
| tachometer | player `+0x66a` | `0xc9c2` | VERIFIED |
| manifold pressure | player `+0x672` | `0xca44` | VERIFIED |
| flaps | player byte `+0x67b` | `0xcc12` | VERIFIED |
| landing gear, three needles/lamps | player byte `+0x679` | `0xccca` | VERIFIED |
| ammunition | player word `+0x682`, 675-round scale | `0xce1c` | VERIFIED |
| fuel, two tanks | player bytes `+0x67d/+0x67e` | `0xcec4` | VERIFIED |

The heading tape is updated by `update_heading_tape` (`0xc1aa`). Radar
collection and display culminate in `update_radar_scope` (`0x17b68`), which
draws up to six tracked objects. Depth-8 and depth-4 line functions write
directly into the frame buffer and restore erased needle pixels from the saved
static panel; at depth 1 the overlay calls the host line service.

The exact crosshair/gunsight routine and any cockpit-attached 3D framing object
are not yet conclusively separated from the view renderer.
`tick_view_attached_object` (`0x19bbc`) is a promising but still **INFERRED**
camera-attached-object path. No resource has been relabeled as a gunsight
without that proof.

## Coordinates, palette, and presentation

The panel is resolution-aware rather than a fixed-size bitmap. Host view
dimensions and pixel depth (1, 4, or 8) select renderer paths; layout
calculations use scaled panel coordinates, including a 4800 design denominator.
The clean binary has a special 512-wide/342-high screen-layout case (with
menu/view deductions), but this is not evidence for a universal fixed cockpit
canvas.

Color indices depend on the original `clut` resources and display-depth setup.
Static panel bitmaps are composited into the offscreen frame. Dynamic color
needles/readouts can be written directly into that framebuffer. Final
presentation reaches `blit_offscreen_frame_to_window` (`CODE:2`,
`ID02:0x0d3a`) and the CopyBits/window path.

World polygons, cockpit panel, map, and menus therefore use related but separate drawing stages:

| Stage | Primary mechanism |
| --- | --- |
| world | custom polygon/scanline rasterization |
| static cockpit | procedural QuickDraw into cached offscreen bitmap |
| dynamic cockpit/HUD | overlay calculations plus depth-specific framebuffer/line drawing |
| map | scene traversal plus host QuickDraw custom item |
| menus/dialogs | Resource Manager and QuickDraw |

## PICT exclusion evidence

| PICT | Proven/verified identity | Why it is not cockpit art |
| ---: | --- | --- |
| 128 | color About-dialog background, linked from `DITL:127` | dialog relationship and decoded render |
| 129 | monochrome About-dialog background, linked from `DITL:138` | dialog relationship and decoded render |
| 130 | refueling ground-crew photograph, linked from `DITL:132` | dialog relationship and decoded render |
| 131 | About/credits scroll picture | decoded render and credits use |
| 1000 | copy-protection instructions, linked from `DITL:1000` | dialog relationship and decoded render |

Icons and `cicn` resources are Finder/UI/award imagery, not an instrument
panel. `STR#:129` instrument words are labels, not bitmaps.

## Current Godot gap

`godot/scripts/hud_mvp.gd` provides modern text telemetry and a simplified
attitude strip. It does not reproduce the original panel layout, QuickDraw
gauge faces, two-stage cached/dynamic drawing, original nonlinear scale
equations, heading tape, radar, palette behavior, or 1/4/8-bit presentation.
The current interface is therefore a placeholder even where it displays real
prototype flight values.

A faithful port should encode the verified procedural panel geometry and
flight-state conversion equations as data/tests first, then render them in
Godot. Generated `HEL2` bitmaps may be used as regression references if
recovered, but should not replace the original construction logic.

## Evidence table

| Component | Original source | Function/resource | Certainty | Missing evidence |
| --- | --- | --- | --- | --- |
| Cockpit panel | executable procedural drawing | `CODE:3`, `prepare_instrument_panel:0x5cc4` | VERIFIED | complete layout record documentation |
| Gauge faces | QuickDraw primitives and `STR#:129` labels | `draw_instrument:0x3c02` and dispatch table | VERIFIED | pixel-perfect render comparison |
| Dynamic needles | flight state plus overlay framebuffer routines | `Pacific Conflict:0xc572..0xcec4` | VERIFIED | a few semantic/unit calibrations |
| Artificial horizon/gyro | procedural static/dynamic combination | `ID03:0x32b8/0x38fc`; generated `HEL2` cache | VERIFIED source | full dynamic overlay trace |
| Heading tape | overlay code | `update_heading_tape:0xc1aa` | VERIFIED | exact label/clip documentation |
| Radar | runtime tracked-object list | `update_radar_scope:0x17b68` | VERIFIED | all blip semantics |
| Gunsight/crosshair | likely overlay/view code | not conclusively isolated | UNKNOWN | exact draw function and inputs |
| Cockpit artwork PICT | none in clean resource fork | PICT 128/129/130/131/1000 are non-cockpit | VERIFIED | none for exclusion of known PICTs |
| Final framebuffer | offscreen frame and CopyBits/window presentation | `ID02:0x0d3a` | VERIFIED | timing/double-buffer details |

## Highest-value next step

Capture the complete panel layout records written by `prepare_instrument_panel`
and make a deterministic reference renderer for one display depth. Comparing
its output against an emulator frame will close scale, palette, clipping,
gunsight placement, and dynamic/static layering more efficiently than searching
for nonexistent cockpit artwork.
