# World and scenery data locations

## Result

The original world is driven by the packed scene graph in the external `sources/hellcats/Pacific Conflict` data fork, not by `PICT:137`, `DITL:137`, `MDPL`, or an embedded main-application scenery resource. The navigation map traverses the same active mission scene graph used to build and render 3D objects. `DLOG`/`DITL:137` supplies only the dialog shell and its 253 × 253 custom-drawn rectangle.

Certainty labels mean: **PROVEN** direct original-byte/instruction evidence; **VERIFIED** deterministic parse or corroborated code flow; **INFERRED** plausible but not closed; **UNKNOWN** insufficient evidence.

## Source and loader

See `MISSION_DATA_LOCATIONS.md` for the byte-exact file layout. In brief, `CODE:8` reads `Pacific Conflict` as a normal Macintosh data fork through the File Manager glue in `CODE:9` (`FSOpen` near `ID09:0x02a6`, `FSClose:0x02de`, `FSRead/FSWrite:0x02fa/0x02fe`, `GetEOF:0x0368`, `GetFPos:0x038c`). The file remainder `0x22994..0x3e57f`, length `0x1bbec`, is allocated at host `A5-0x12fc` and becomes the overlay's host pointer `+0x8c`.

`ALRT`/`DITL:256` is the open-failure path. `ALRT`/`DITL:261` identifies the companion file as required installation content. No Resource Manager lookup selects a world resource ID.

## Packed and runtime scene representation

The packed root at file `0x22994` is kind 3 with 41 children. The established portion of the layout is:

| Field | Meaning | Certainty |
| --- | --- | --- |
| descriptor byte `+0` | kind; 3 is a group/container | VERIFIED |
| descriptor `+0x18` | child count | VERIFIED |
| descriptor `+0x1a` | first child record | VERIFIED |
| child record size | `0x18` bytes | VERIFIED |
| child record `+0x14` | pointer relative to payload base `0x22994` | VERIFIED |

`init_mission_object_tables` (`Pacific Conflict:0x16e2`) and `alloc_object_from_desc` (`0x45ba`) instantiate this data. `traverse_scene_tree` (`0x05fa`) recursively follows kind-3 groups. `for_each_mission_scene_object` (`0x06a6`) chooses the current mission's scene root from the 0x18-byte runtime table and traverses it.

Object and land geometry are then built by `build_object_poly_buffers` (`0x4808`) and `build_land_outline_at_detail` (`0x4958`). The latter is rebuilt at distance/altitude-dependent detail levels, so the final coastline mesh is data-driven plus runtime LOD generation, not a static screen bitmap.

World positions are signed 32-bit coordinates. Attitude routines consistently use a turn modulus of `0x4000`. The exact conversion of world units to physical miles is **UNKNOWN**. The map code contains `0xce40` distance thresholds and its scale UI reports miles per grid, but that is not sufficient to assert a universal unit ratio.

## Navigation map uses the same world

`collect_map_features` (`Pacific Conflict:0x06ec`) is a visitor invoked by `plot_mission_map_symbols` (`0x0954`) through `for_each_mission_scene_object`. It:

- transforms scene-object vertices through `transform_through_node_chain` (`0x04f8`);
- selects land objects using flag `0x10` while excluding `0x240`;
- clips their transformed outlines to the map rectangle;
- classifies type-nibble `0x70` objects as mapped airfield points;
- associates facility kinds `0x12`/`0x13` with base/carrier symbols.

Map coordinates are computed directly from the player and world positions:

```text
map_x = (world_x - player_x) / map_scale
map_y = (player_z - world_z) / map_scale
```

For missions 3 and 4, `plot_mission_map_symbols` adds hardcoded target `T` positions `(-0x3bcd3, 0x2b246a)` and `(-0xf2bf12, 0xb242d8)`. The same coordinates are checked by the bomb-impact objective code.

On the host side, `draw_map_view_item` (`CODE:4`, `ID04:0x33d6`) paints the blue map background and calls overlay hook `A5-0x1052`, installed as `plot_mission_map_symbols`. `draw_map_grid_and_centre_mark` (`ID04:0x3260`) and `plot_map_symbol_callback` (`0x3352`) draw the UI. `track_map_bearing_and_distance` (`0x3614`) derives navigation feedback. The map scale passed to the overlay is calculated from saved setting `+0x26`, `4 * 0xce40`, and the map width.

This data path **PROVES** that the navigation map and flight renderer share the active external scene graph. They render it differently; they do not use separate world databases.

## Flight rendering path

The original has distinct but connected pipelines:

| Content | Construction/render path | Certainty |
| --- | --- | --- |
| menus/dialogs/map chrome | Resource Manager UI plus QuickDraw primitives | PROVEN |
| world geometry | external descriptors → runtime meshes → transforms/projection → polygon edges/spans | VERIFIED |
| 1-bit world output | overlay visibility/projection → `CODE:6` scanline rasterizer | VERIFIED |
| 4/8-bit world output | overlay depth-specific edge/span rasterizers | VERIFIED |
| final presentation | offscreen frame → `blit_offscreen_frame_to_window` (`CODE:2`, `ID02:0x0d3a`) / CopyBits path | VERIFIED |

`render_visible_objects` (`Pacific Conflict:0xac72`) performs visible-object/face submission. Camera and hierarchy transforms begin around `0x1d02`; face clipping, perspective, and edge generation feed either the overlay color-depth span code or the host `CODE:6` rasterizer (`reset` near `ID06:0x096e`, polygon-edge addition `0x09d8`, rasterize/present `0x0e10`). Face records are built from original object descriptors, including vertices, indices, detail thresholds, and optional BSP ordering.

Water, sky/horizon, and terrain contact have runtime code paths rather than a PICT backdrop. Relevant routines include `test_terrain_collision`/surface queries near `0x13cdc`, `handle_terrain_contact:0x14198`, land LOD rebuilding, and altitude-following horizon/ground reference objects. The exact packed terrain-height/land-outline schema is still only partially decoded.

## Resource census

There are 30 directories in this extraction (the request says 29). All were reviewed. The table records their demonstrated role and prevents UI/resources from being mistaken for scenery.

| Type | Established role | Mission/world/HUD source? | Certainty |
| --- | --- | --- | --- |
| `ALRT` | alert templates, including 256 and 261 | loader/install evidence only | PROVEN |
| `BNDL` | Finder bundle mapping | no | PROVEN |
| `CNTL` | dialog control templates | no | VERIFIED |
| `CODE` | host 68K executable segments | loader, map UI, rasterizer, panel construction | PROVEN |
| `DATA` | `DATA:0` compressed A5 initializer; `DATA:128` protection-related opaque block | filename/default state, not world payload | VERIFIED / partial |
| `DITL` | dialog item lists | names/map shell only | PROVEN |
| `DLOG` | dialog layouts | map shell only | PROVEN |
| `DREL` | A5-world relocation information | executable startup support | VERIFIED |
| `FREF` | Finder file references | no | PROVEN |
| `HEL1` | saved settings and roster | scenery filename/settings only | VERIFIED |
| `HELL` | Finder/Get Info text | no | VERIFIED |
| `ICN#`, `ICON`, `icI4`, `icI8`, `ics#`, `ics4`, `ics8` | Finder/app icons | no | PROVEN |
| `MDPL` | opaque custom resource; no proven loader/consumer | UNKNOWN; not evidence of world data | UNKNOWN |
| `MENU` | menus | no | PROVEN |
| `PICT` | about, refuel, credits, protection pictures | no world/cockpit picture | VERIFIED |
| `SIZE` | Macintosh memory/launch settings | no | PROVEN |
| `STR#` | result, help, UI, instrument label strings | text only | PROVEN |
| `TEXT`, `styl` | about/help/protection text and styling | no | VERIFIED |
| `ZERO` | zero-initialization stream | runtime startup support, not serialized world | VERIFIED |
| `cicn` | color UI/award icons | no | VERIFIED |
| `clut` | display/world palette tables | rendering dependency, not geometry | VERIFIED |
| `snds` | sound resources | no | VERIFIED |
| `vers` | version metadata | no | PROVEN |

`MDPL` remains deliberately **UNKNOWN**: no current code reference proves a role, so its suggestive type name is not promoted to model/world evidence.

## Current Godot gap

`godot/scripts/world_builder_mvp.gd` constructs a procedural sky, a roughly 20 km sea, and a box-like 1,200 × 50 × 1,200 island centered around `(0,-24,2600)`. Those values and meshes are placeholders, not decoded `Pacific Conflict` geometry. The Godot navigation/checkpoint data likewise does not traverse the original scene graph. Carrier, base, runway, coastline, elevation, facility classifications, palette-driven haze, land LOD, and original coordinate conversion remain disconnected.

The correct replacement is a read-only importer that preserves payload offsets and emits an intermediate scene graph. Both the Godot 3D world and mission map should consume that single intermediate representation, mirroring the original shared-data architecture.

## Evidence table

| Component | Original source | Function/resource | Certainty | Missing evidence |
| --- | --- | --- | --- | --- |
| World root | external data fork | `Pacific Conflict:0x22994..0x3e57f` | PROVEN | full field schema |
| Terrain/islands | external scene objects plus runtime LOD | `build_land_outline_at_detail:0x4958` | VERIFIED source/path | elevation/outline record semantics |
| Airfields | active scene graph | type nibble `0x70`, `collect_map_features:0x06ec` | VERIFIED classification path | exact descriptor fields |
| Bases/carriers | active scene graph | facility kinds `0x12`/`0x13` | VERIFIED map classification | complete object identities and meshes |
| Mission map | shared scene graph plus dialog chrome | `DITL:137`, overlay `0x06ec/0x0954`, host `ID04:0x33d6` | PROVEN | none for data sharing |
| World rasterization | overlay and `CODE:6` | `render_visible_objects:0xac72`; scanline functions | VERIFIED | remaining color-depth routine details |
| World scale | signed coordinates; angle modulus known | map scale formula, transforms | INFERRED | authoritative physical-unit conversion |
| `MDPL` | main resource fork | no proven consumer | UNKNOWN | format and references |

## Highest-value next step

After the root parser, decode one land object's packed descriptor end-to-end through `build_object_poly_buffers` and `build_land_outline_at_detail`, retaining the source byte range for every vertex/face. That will establish coastline/elevation encoding and immediately support both map and 3D reconstruction without inventing geometry.
