# Overlay service table — iteration 135, 2026-10-16

Installed by the unexported ID02 routine at file 0x1b42..0x1c88, called by
`main` before the overlay is loaded. Each slot receives the address of a CODE 0
jump-table entry (`LEA d16(A5),A0; MOVE.L A0,slot(A5)`), so the overlay can
call application routines through `MOVEA.L slot(A5),A0; JSR (A0)`.

Offsets are physical file offsets; JT targets resolved through `ID00.bin`
(segment offset + 4-byte CODE header). Store sites and targets are
**[PROVEN, bytes]**; the 'service table for the overlay' role is
**[STRONG INFERENCE]**. Several targets reload A5 from CurrentA5 ($0904),
consistent with being called from overlay context.

| Slot | Store at | JT | Target segment / file | Recovered name |
|---|---|---|---|---|
| A5-0x1310 | 0x1bf2 | $1ba | ID06 0x96e | not yet named |
| A5-0x130c | 0x1bfa | $1c2 | ID06 0x9d8 | not yet named |
| A5-0x1308 | 0x1c02 | $19a | ID06 0xe10 | not yet named |
| A5-0x1304 | 0x1c0a | $1a2 | ID06 0x8a2 | not yet named |
| A5-0x1122 | 0x1b42 | $33a | ID02 0xc68 | `apply_pending_color_entries_a5safe` |
| A5-0x111e | 0x1b52 | $372 | ID02 0x197c | `run_segment3_entry_and_unload_a5safe` |
| A5-0x111a | 0x1b4a | $3aa | ID02 0x195c | `blit_image_clipped_to_region_a5safe` |
| A5-0x1116 | 0x1b5a | $3fa | ID02 0xa42 | `draw_thick_line_pixel_index_a5safe` |
| A5-0x1112 | 0x1b62 | $32a | ID02 0xa86 | `draw_thick_xor_line_a5safe` |
| A5-0x110e | 0x1baa | $362 | ID02 0x1308 | not yet named |
| A5-0x110a | 0x1bb2 | $3ea | ID02 0xad0 | `paint_view_horizon_bands_a5safe` |
| A5-0x1106 | 0x1b82 | $3d2 | ID02 0xe9e | not yet named |
| A5-0x1102 | 0x1b92 | $352 | ID02 0xf74 | not yet named |
| A5-0x10fe | 0x1b8a | $312 | ID02 0xf52 | not yet named |
| A5-0x10fa | 0x1b9a | $39a | ID02 0xfa0 | not yet named |
| A5-0x10f6 | 0x1ba2 | $3f2 | ID02 0xfd2 | not yet named |
| A5-0x10f2 | 0x1b6a | $322 | ID02 0xd3a | `blit_offscreen_frame_to_window` |
| A5-0x10ee | 0x1b72 | $34a | ID02 0xe3e | not yet named |
| A5-0x10ea | 0x1b7a | $3c2 | ID02 0x11ec | not yet named |
| A5-0x10de | 0x1bba | $442 | ID02 0x3f54 | `play_sample_on_channel` |
| A5-0x10da | 0x1bc2 | $42a | ID02 0x4050 | `enqueue_sample_on_channel` |
| A5-0x10d6 | 0x1bca | $452 | ID02 0x412e | `set_sound_playback_rate` |
| A5-0x10d2 | 0x1bd2 | $43a | ID02 0x42b0 | `is_channel_playing` |
| A5-0x10ce | 0x1bda | $44a | ID02 0x41a6 | `release_channel_loop` |
| A5-0x10ca | 0x1be2 | $432 | ID02 0x4242 | `silence_sound_channel` |
| A5-0x10c6 | 0x1bea | $35a | ID02 0x14e6 | not yet named |
| A5-0x10c2 | 0x1c12 | $31a | ID02 0x19a2 | `new_handle_clear_or_die_a5safe` |
| A5-0x10be | 0x1c1a | $332 | ID02 0x1a04 | `dispose_handle_a5safe` |
| A5-0x10ba | 0x1c22 | $40a | ID02 0x1a28 | `realloc_and_clear_handle_a5safe` |
| A5-0x10b6 | 0x1c2a | $342 | ID02 0x1a84 | `hlock_a5safe` |
| A5-0x10b2 | 0x1c32 | $37a | ID02 0x1aa8 | `hunlock_a5safe` |
| A5-0x10ae | 0x1c3a | $3da | ID02 0x1acc | `hpurge_a5safe` |
| A5-0x10aa | 0x1c42 | $3b2 | ID02 0x1af0 | `hnopurge_a5safe` |
| A5-0x10a6 | 0x1c4a | $38a | ID02 0x1b14 | `freemem_a5safe` |

Slot A5-0x1122 is later re-pointed by `build_palette_index_map` (ID02 0x49e4 /
0x49ee) to JT $46a (`clear_ctab_size_callback`) or back to JT $33a, depending on
palette index collisions.

Gaps in the contiguous A5-0x1122..-0x10a6 range: A5-0x10e6 and A5-0x10e2
are not written by this routine.

After the table, the routine allocates the overlay work buffer at long
`A5-0x1040`: `NewPtrClear(0x4e390)` (320400 bytes) when `FreeMem() > 0x100000`,
otherwise `NewPtrClear(0x35cf0)` (220400 bytes). The result is not checked.

## Not in this table

The function-pointer slots called by ID02 (`A5-0x1092`, `-0x104e`, `-0x1096`,
`-0x109e`, `-0x10a2`) are outside this range and have no `d16(A5)` writer in
any CODE segment (iteration 117). They are presumably written by the overlay
(overlay → application callbacks). **[STRONG INFERENCE]**
