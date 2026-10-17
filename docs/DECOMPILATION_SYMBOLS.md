# Hellcats Over the Pacific — Decompilation Symbol Map

Maps original Ghidra identifiers to recovered names. Every entry must cite evidence.
Do not treat example names from planning docs as approved until revalidated here.

## Functions

| Original symbol | Recovered name | Confidence | Evidence |
|---|---|---|---|
| `FUN_00000048` (ID09) | `sysenvirons_glue_fallback` | STRONG INFERENCE | Iter 106: entry dispatcher at file 0x20-0x46 calls `$A090` (_SysEnvirons) only when GetOSTrapAddress($90) ≠ GetToolTrapAddress($9F _Unimplemented) or falls into 0x48; body fills SysEnvRec from documented low-memory globals and returns 0xea84 (−5500 envNotPresent). Lookup table proven at file 0x54..0x58. Trap/global names from Apple docs, not validated against Apple glue. See `ID09_SYSENVIRONS_ANALYSIS.md`. |
| `FUN_000002a6` (ID09) | `fsopen_glue` | STRONG INFERENCE | Iter 107: file 0x2a6..0x2dc LINK −0x32 IOParam; +0x12←long arg, +0x16←word arg, clears +0x1a/+0x1b/+0x1c; `$A000` (_Open); +0x18→VAR arg; D0→result; pops 10 bytes = FSOpen(fileName, vRefNum, VAR refNum): OSErr. Trap/field names from Inside Macintosh. |
| `FUN_000003c2` (ID09) | `swapmmumode_glue` | STRONG INFERENCE | Iter 108: file 0x3c2..0x3d4 loads byte via VAR ptr into D0, `$A05D` (_SwapMMUMode), stores D0.B back, pops 4 bytes = SwapMMUMode(VAR mode: SignedByte). Trap name from Inside Macintosh. |
| `FUN_00000006` (ID07) | `load_str129_string_table` | STRONG INFERENCE | Iter 109: ID07.bin 0x06..0x18e GetResource('STR#',0x81) `$A9A0`, HLock via JT `$272(A5)`, in-place \\p/escape processing, stores 120 string pointers to A5−0xf46[1..120]. Sole caller `FUN_00000190` (ID07). |
| `FUN_00000190` (ID07) | `init_string_pointer_groups` | STRONG INFERENCE | Iter 110: calls `load_str129_string_table`, copies slots 2..22→A5−0x221e[21], 94..99→A5−0xffe[6], 100..105→A5−0xfae[6], 106..115→A5−0xf86[10]. JT A5+0x592; called from ID02 file 0x2c0a. |
| `FUN_00002bbc` (ID02) | `initialize_application` | STRONG INFERENCE | Iter 111: ID02.bin 0x2bbc..0x2d9e Toolbox init sequence ($A86E InitGraf … $A850 InitCursor), JT $592 string init + UnloadSeg 7, SysEnvirons via JT $1f2, 'MENU' 2 / 'HEL1' 127/128 load-or-create, SetPort. Caller `FUN_0000309a`. |
| `FUN_0000309a` (ID02) | `main` | STRONG INFERENCE (entry chain PROVEN) | Iter 112: called from ID01 runtime entry via JT A5+0x4b2 (constant at ID01 file 0x4); runs `initialize_application`, ID08 overlay loader, UnloadSeg 4/8/5, then loops forever on `FUN_00002fd4`. |
| `FUN_00002fd4` (ID02) | `poll_and_dispatch_event` | STRONG INFERENCE | Iter 113: ID02.bin 0x2fd4..0x3098 GetNextEvent ($A970) + switch on what: mouseDown→0x2f1e, cmd-key→MenuKey→0x36a2, update→Begin/EndUpdate+0x4db0, activate→0x2fa0. Called forever by `main`. |
| `FUN_000036a2` (ID02) | `do_menu_command` | STRONG INFERENCE | Iter 114: HiWord/LoWord($A86A/$A86B) of menuResult; menu 1 Apple (OpenDeskAcc), menu 3 Edit (SystemEdit), menu 2 13-item command menu (quit = 0x2eaa). Called from `poll_and_dispatch_event` after MenuKey. |
| `FUN_00002a44` (ID02) | `apply_settings_to_live_options` | STRONG INFERENCE | Iter 116: copies HEL1 127 words S+2..S+0x24 into A5−0x12ee..−0x12d0; change-triggered callbacks via A5−0x1092/−0x104e/−0x1096 gated by A5−0x1006; redraw FUN_00004db0. 6 callers in ID02.bin. |
| `FUN_00002f1e` (ID02) | `handle_mouse_down` | STRONG INFERENCE | Iter 127: FindWindow switch: inMenuBar→MenuSelect→do_menu_command, inSysWindow→SystemClick, inGoAway(main)→TrackGoAway→HideWindow. |
| `FUN_00002fa0` (ID02) | `handle_activate_event` | STRONG INFERENCE | Iter 127: (modifiers&3)==3 && message==main_window → InvalRect(&main_window->portRect). |
| `FUN_00004db0` (ID02) | `redraw_main_window` | STRONG INFERENCE | Iter 128: gated redraw: HideCursor, FUN_00004c18, UnloadSeg 3, overlay callback A5−0x109e, helpers, ShowCursor. Called from update handling and apply_settings_to_live_options. |
| `FUN_00004c18` (ID02) | `check_device_color_state_changed` | STRONG INFERENCE | Iter 129: compares per-device 256-word arrays from FUN_000048ae with stored copies; on change → JT $182, refresh, overlay callback A5−0x1096. |
| `FUN_000048ae` (ID02) | `build_palette_index_map` | STRONG INFERENCE | Iter 130: per device slot, PmForeColor(i) → fgColor index → map[i]/inverse[idx]; duplicate detection → A5−0x102a; selects A5−0x1122 = JT 0x46a or 0x33a. |
| `FUN_000046b4` (ID02) | `rebuild_all_palette_index_maps` | STRONG INFERENCE | Iter 131: rebuild map for each device slot 1..3 (or B&W path). |
| `FUN_00004738` (ID02) | `configure_palette_entries` | STRONG INFERENCE | Iter 131: depth-4 / depth-8 Palette Manager entry usage + colours. |
| `FUN_0000488a` (ID02) | `clear_ctab_size_callback` | STRONG INFERENCE | Iter 131: A5 from CurrentA5; (*A5−0x14b2)+6 = 0. |
| `FUN_000049fe` (ID02) | `lookup_palette_index_for_rgb_level` | STRONG INFERENCE | Iter 132: (r,g,b) levels ×64→16-bit; search A5−0x350[8] then *(A5−0x14a6); +200 at 8-bit. |
| `FUN_00000d24` (ID02) | `close_and_dispose_port` | STRONG INFERENCE | Iter 133: ClosePort(p); DisposPtr(p). Used on A5−0x103a. |
| `FUN_00000d3a` (ID02) | `blit_offscreen_frame_to_window` | STRONG INFERENCE | Iter 134: (base, top, rows, mode) → offscreen PixMap port A5−0x103a, CopyBits to thePort. JT $322; ID06 0xf18; address taken at ID02 0x1b6a. |
| `FUN_00001b14` (ID02) | `freemem_a5safe` | STRONG INFERENCE | Iter 135: CurrentA5 wrapper around ID09 FreeMem glue; service slot A5−0x10a6. |
| `FUN_00001a04` / `1a84` / `1aa8` / `1acc` / `1af0` (ID02) | `dispose_handle_a5safe` / `hlock_a5safe` / `hunlock_a5safe` / `hpurge_a5safe` / `hnopurge_a5safe` | STRONG INFERENCE | Iter 136: CurrentA5 thunks → ID09 $A023/$A029/$A02A/$A049/$A04A glue; service slots. |
| `FUN_00001a28` (ID02) | `realloc_and_clear_handle_a5safe` | STRONG INFERENCE | Iter 136: ReallocHandle + MemError check + zero-fill via FUN_000002b0. |
| `FUN_000019a2` (ID02) | `new_handle_clear_or_die_a5safe` | STRONG INFERENCE | Iter 137: NewHandleClear + MemError → fatal; service slot A5−0x10c2. |
| `FUN_000019e2` (ID02) | `fatal_memory_error_exit` | STRONG INFERENCE | Iter 137: dispose overlay, FUN_00004318, show STR#129[93] via FUN_00001d48, ExitToShell. |
| `FUN_00001d48` (ID02) | `show_caution_alert_with_number` | STRONG INFERENCE | Iter 138: ParamText(msg, number) + CautionAlert(258). JT $4ba. |
| `FUN_00001c8a` (ID02) | `format_int_decimal_pstring` | STRONG INFERENCE | Iter 138: signed decimal → Pascal string in 10-byte buffer. |
| `FUN_00004318` (ID02) | `shutdown_sound` | STRONG INFERENCE | Iter 138: stop 3 channels, restore $0196, SndDisposeChannel(A5−0x356). |
| `FUN_00004242` (ID02) | `silence_sound_channel` | STRONG INFERENCE | Iter 139: ch 0..1 → FUN_00003d50(ch, A5−0xc26, 0, 370, 0) into channel record. |
| `FUN_00003d36` (ID02) | `clear_sound_buffer_to_silence` | STRONG INFERENCE | Iter 139: SoundBase ($0266) 370 words ← 0x80. |
| `FUN_00003d50` (ID02) | `alloc_sound_buffer_node` | STRONG INFERENCE | Iter 140: node from channel free list; {+0 cursor, +8 buffer, +0xc start, +0x10 end, +0x14 next, +0x18 continuation}. |
| `FUN_00003dd0` (ID02) | `init_sound_system` | STRONG INFERENCE | Iter 140: builds channel queues, silence buffer, installs routine into low-memory $0196 (saved in A5−0xc36). |
| `FUN_000039a8` / `FUN_00003aae` / `FUN_00003bc4` (ID02) | `vbl_sound_handler_ch0_unrolled` / `vbl_sound_handler_ch0_variant` / `vbl_sound_handler_two_channel` | STRONG INFERENCE | Iter 141: Lvl1DT[1] VBL hooks; in-code A5 cache; RTS-chain to previous vector; resample into SoundBase. |
| `FUN_00003db8` (ID02) | `select_two_channel_sound_handler` | STRONG INFERENCE | Iter 141: arg == 1 → $0196 = A5−0x35c. |
| `FUN_00003f54` (ID02) | `play_sample_on_channel` | STRONG INFERENCE | Iter 142: queue sample on ch 0..1 with optional sustain loop; see SOUND_SYSTEM.md. |
| `FUN_00004050` (ID02) | `enqueue_sample_on_channel` | STRONG INFERENCE (purpose HYPOTHESIS) | Iter 143: queues nodes like play_sample_on_channel but leaves channel head unchanged. |
| `FUN_0000412e` (ID02) | `set_sound_playback_rate` | STRONG INFERENCE | Iter 144: 16.16 rate → step/len globals. |
| `FUN_000041a6` (ID02) | `release_channel_loop` | STRONG INFERENCE | Iter 144: breaks sustain self-loops, ends in silence. |
| `FUN_000042b0` (ID02) | `is_channel_playing` | STRONG INFERENCE | Iter 144: current buffer ≠ silence. |
| `FUN_00000c68` (ID02) | `apply_pending_color_entries_a5safe` | STRONG INFERENCE | Iter 145: SetEntries(-1, ctSize-1, ctTable) on A5−0x14b2; ctSize = 0. |
| `FUN_00001876` (ID02) | `blit_image_clipped_to_region` | STRONG INFERENCE | Iter 145: CopyBits image A5−0x12b0 via port A5−0x1496 clipped to region from FUN_000016aa. |
| `FUN_0000195c` / `FUN_0000197c` (ID02) | `blit_image_clipped_to_region_a5safe` / `run_segment3_entry_and_unload_a5safe` | STRONG INFERENCE | Iter 145: CurrentA5 service thunks. |
| `FUN_00000a42` (ID02) | `draw_thick_line_pixel_index_a5safe` | STRONG INFERENCE | Iter 146: fgColor raw index; 2-px MoveTo/LineTo. |
| `FUN_00000a86` (ID02) | `draw_thick_xor_line_a5safe` | STRONG INFERENCE | Iter 146: black srcXor 2-px line. |
| `FUN_00000ad0` (ID02) | `paint_view_horizon_bands_a5safe` | STRONG INFERENCE (purpose HYPOTHESIS) | Iter 147: top band + two tilted quads + bottom band in view region. |
| `FUN_000015cc` (ID02) | `set_draw_color_index` | STRONG INFERENCE | Iter 147: fgColor = index (or B&W path). |
| `FUN_00000f52` / `FUN_00000f74` (ID02) | `close_port_a5safe` / `swap_port_a5safe` | STRONG INFERENCE | Iter 148: ClosePort; SetPort returning previous port. |
| `FUN_00000fa0` (ID02) | `paint_rect_color_index_a5safe` | STRONG INFERENCE | Iter 148: colour index + PaintRect. |
| `FUN_00000fd2` (ID02) | `paint_polygon_rgb_a5safe` | STRONG INFERENCE | Iter 148: filled polygon in packed RGB, y negated. |
| `FUN_00000e3e` (ID02) | `blit_pixels_via_port_a5safe` | STRONG INFERENCE | Iter 149: set baseAddr; CopyBits src→dst (default thePort). |
| `FUN_00000e9e` (ID02) | `open_offscreen_cport_a5safe` | STRONG INFERENCE | Iter 149: OpenCPort + pixmap/portRect/visRgn setup on caller storage. |
| `FUN_00000ca6` (ID02) | `new_offscreen_cport` | STRONG INFERENCE | Iter 149: allocate CGrafPort (0x6c) and set it up. |
| `FUN_000014e6` (ID02) | `swap_mmu_mode_a5safe` | STRONG INFERENCE | Iter 150: SwapMMUMode(&A5−0x1000) via ID09 glue; slot −0x10c6. |
| `FUN_000011ec` (ID02) | `draw_notched_frame_pair_a5safe` | STRONG INFERENCE mechanics | Iter 151: two notched frames (pen 2/1) from rect A5−0x119c, drawn twice. |
| `FUN_000010ce` (ID02) | `build_notched_frame_poly` | STRONG INFERENCE mechanics | Iter 151: notched/chamfered frame polygon from a Rect. |
| `FUN_00001308` (ID02) | `draw_text_in_columns_a5safe` | STRONG INFERENCE mechanics | Iter 152: columned DrawString output with FillRect backgrounds; slot −0x110e. |
| `FUN_00001656` / `FUN_00001680` (ID02) | `design_x_to_screen` / `design_y_to_screen` | STRONG INFERENCE | Iter 162: A5−0x149e·v/4800 + half view width/height. |
| `FUN_00001632` / `FUN_0000001e` (ID02) | `set_back_color_index` / `abs_long` | STRONG INFERENCE | Iter 162. |
| `FUN_00002db8` / `FUN_00004d34` (ID02) | `wait_for_click_or_key` / `process_pending_update_events` | STRONG INFERENCE | Iter 173: modal input wait; update flush. |
| A5−0x1372 / A5−0x1370 | view width / height (words) | STRONG INFERENCE | srcRect right/bottom in blit_offscreen_frame_to_window; centre in design_*_to_screen. |
| `FUN_000007b0` / `00000598` / `00000666` / `00000512` / `0000087a` (ID06) | `init_raster_target` / `alloc_row_table` / `init_edge_pool` / `free_row_table` / `set_raster_target_base` | STRONG INFERENCE | Iter 153: ID06 rasterizer set-up; structures A5−0x1cce / −0x1cd2 / −0x1cd6. |
| `FUN_000008a2` / `0000096e` / `000009d8` / `00000e10` / `0000026c` (ID06) | `set_active_row_count` / `reset_edge_table` / `add_polygon_edges` / `rasterize_and_present` / `init_row_table_fields` | STRONG INFERENCE | Iter 154: scanline polygon rasterizer API (service slots −0x1304/−0x1310/−0x130c/−0x1308). |
| `FUN_00000318` (ID06) | `render_scanline_spans` | STRONG INFERENCE | Iter 155: priority span fill; in-code state at 0x39e..0x3e1. JT $192. |
| `FUN_00000d84` / `FUN_00000dca` (ID06) | `rebase_edge_rows_for_band` / `restore_edge_rows_after_band` | STRONG INFERENCE | Iter 155: band row-counter adjustment. |
| `FUN_000001dc` / `FUN_0000024c` (ID06) | `alloc_aligned_clear` / `free_aligned` | STRONG INFERENCE | Iter 157: aligned NewPtrClear with header; DisposPtr of raw pointer. |
| `FUN_00000116` (ID06) | `rgb_to_bw_pattern` | STRONG INFERENCE | Iter 157: luma → pattern pointer (A5−0x1ed6, 64 × 8 bytes). |
| `FUN_0000017c` / `FUN_000001a2` (ID06) | `lookup_colour_map` / `reverse_lookup_colour_map` | STRONG INFERENCE | Iter 157: 256-word map at *A5−0x1ede. |
| `FUN_00000004` / `000000b0` / `000000f4` (ID06) | `init_pattern_tables` / `alloc_pattern_tables` / `get_pattern_table` | STRONG INFERENCE | Iter 158: mask + pattern table A5−0x1eda (0xc00), grey map A5−0x1ede (0x200). |
| `FUN_00000916` / `00000942` / `00000d02` (ID06) | `get_raster_target_size` / `realloc_row_table` / `add_rect_polygon` | STRONG INFERENCE | Iter 158. |
| `FUN_00000056` / `0000008a` / `000000a6` (ID03) | `scale_design_480_min10` / `scale_design_4800` / `scale_design_4800_pen_centred` | STRONG INFERENCE | Iter 159: design-unit → screen scaling via A5−0x149e. |
| `FUN_000000c8` / `000000f4` (ID03) | `max3_int` / `nearest_palette_index_rgb` | STRONG INFERENCE | Iter 159. |
| `FUN_00000006` / `000002a8` / `0000033c` (ID03) | `set_scaled_text_style` / `new_offscreen_bw_port` / `dispose_offscreen_bw_port` | STRONG INFERENCE | Iter 160: text style; 1-bit offscreen GrafPort create/dispose. |
| `FUN_00000912` (ID03) | `draw_vector_number` | STRONG INFERENCE | Iter 161: stroke-font digits from A5−0x1fde. |
| `FUN_0000035e` (ID03) | `draw_spinning_disc_indicator` | STRONG INFERENCE mechanics | Iter 163: grey disc + 4-phase rotating spoke (A5−0x2112), size A5−0x2114. Iter 167: likely a bezel screw head (HYPOTHESIS). |
| `FUN_00000514` (ID03) | `draw_ring_with_status_indicators` | STRONG INFERENCE mechanics | Iter 164: ring + up to 5 diagonal spinning indicators by flag bits. |
| `FUN_00000a3c` (ID03) | `antialias_downsample_bw_3x` | STRONG INFERENCE | Iter 166: 3× Gaussian (7×7, /969) downsample of 1-bit bitmap into grey palette pixels. |
| `FUN_00003c02` (ID03) | `draw_instrument` | STRONG INFERENCE | Iter 167: bezel + type-switch (0..9) to per-gauge drawers; record A5−0x12a2. |
| `FUN_00001876` (ID03) | `draw_altimeter` | STRONG INFERENCE | Iter 168: instrument type 0; label STR#129[65] "ALTITUDE". |
| `FUN_00001538` (ID03) | `begin_instrument_supersample` | STRONG INFERENCE | Iter 168: 1× or 3× B&W port for anti-aliased gauge drawing. |
| `FUN_00001b48` (ID03) | `draw_airspeed_indicator` | STRONG INFERENCE | Iter 169: instrument type 1; label "AIR SPEED". |
| `FUN_00002d1c` (ID03) | `draw_turn_and_bank_indicator` | STRONG INFERENCE | Iter 169: instrument type 2; label "TURN BANK". |
| `FUN_00001fee` (ID03) | `draw_climb_indicator` | STRONG INFERENCE | Iter 169: instrument type 3; label "CLIMB". |
| `FUN_00002600` (ID03) | `draw_manifold_pressure_gauge` | STRONG INFERENCE | Iter 169: instrument type 4; label "Manifold Pressure". |
| `FUN_000022fe` (ID03) | `draw_tachometer` | STRONG INFERENCE | Iter 169: instrument type 5; label "RPM". |
| `FUN_00002950` (ID03) | `draw_direction_indicator` | STRONG INFERENCE | Iter 169: instrument type 6; label "DIRECTION". |
| `FUN_00004c42` / `00004ecc` / `0000532e` (ID03) | `draw_flaps_indicator` / `draw_ammo_counter` / `draw_fuel_gauge` | STRONG INFERENCE | Iter 171: labels STR#129 slots 75 / 76 / 77. |
| `FUN_00003d42` (ID04) | `check_system_requirements` | STRONG INFERENCE | Iter 172: Color QD + 68020 check; JT $f2. |
| `FUN_000003c2` (ID04) | `run_with_temporary_window` | STRONG INFERENCE mechanics | Iter 172: "Hellcats" window around ID02 0x2db8. |
| `FUN_000004f0` / `00000516` / `00000560` (ID04) | `ask_save_changes` / `confirm_end_mission` / `confirm_erase_high_scores` | STRONG INFERENCE | Iter 175: CautionAlert 257 / 259 / 260 (texts from DITL dump). |
| `FUN_00000588` (ID04) | `compute_pilot_score` | STRONG INFERENCE | Iter 176: Σ record +0x28 tallies × A5−0xf5e weights. |
| `FUN_00000f4e` / `00001106` / `00001a0e` (ID04) | `rank_pilots_by_score` / `reset_pilot_record` / `build_rank_and_name_string` | STRONG INFERENCE | Iter 177; see PILOT_ROSTER.md. |
| `FUN_000031aa` (ID04) | `conclude_mission` | STRONG INFERENCE | Iter 178: mission-over flag + pilot status write; JT $da. |
| `FUN_00003124` / `FUN_00003178` (ID04) | `play_named_sound_async` / `stop_named_sound` | STRONG INFERENCE | Iter 179: Sound Manager 'snd ' by name (A5−0x2128); channel A5−0x2152, handle A5−0x2156. |
| `FUN_00002de6` (ID04) | `show_mission_summary_dialog` | STRONG INFERENCE | Iter 180: DLOG 133 "Mission Summary". |
| `FUN_00000006` (ID04) | `disable_dialog_control` | PROVEN | Iter 181: bytes; HiliteControl 255. |
| `FUN_0000002e` (ID04) | `enable_dialog_control` | PROVEN | Iter 181: bytes; HiliteControl 0. |
| `FUN_00000054` (ID04) | `hide_dialog_control` | PROVEN | Iter 181: bytes; HideControl. |
| `FUN_00000078` (ID04) | `show_dialog_control` | PROVEN | Iter 181: bytes; ShowControl. |
| `FUN_0000009c` (ID04) | `set_dialog_item_text` | PROVEN | Iter 181: bytes; SetIText. |
| `FUN_000000c4` (ID04) | `set_dialog_control_title` | PROVEN | Iter 181: bytes; SetCTitle. |
| `FUN_000000ec` (ID04) | `set_dialog_user_item_proc` | PROVEN | Iter 181: bytes; SetDItem with a ProcPtr. |
| `FUN_00000120` (ID04) | `frame_dialog_item_box` | PROVEN | Iter 181: bytes; InsetRect -2, PenSize 1, FrameRect. |
| `FUN_0000016e` (ID04) | `draw_default_button_outline` | PROVEN | Iter 181: bytes; user item via JT $12a; item A5-0x225e; FrameRoundRect 16. |
| `FUN_000001f2` (ID04) | `draw_grey_user_item` | PROVEN | Iter 181: bytes; user item via JT $142; FillRect gray A5-0x1624. |
| `FUN_000017e6` (ID04) | `create_scrolling_text_item` | STRONG INFERENCE | Iter 182: bytes; TENew -> A5-0x223a; NewControl scrollBarProc -> A5-0x2236; user item JT $92. |
| `FUN_0000189c` (ID04) | `dispose_scrolling_text_item` | PROVEN | Iter 182: bytes; TEDispose + DisposeControl. |
| `FUN_000018b0` (ID04) | `append_line_to_scrolling_text` | STRONG INFERENCE | Iter 182: bytes; strlen (ID02 0x3e8) + TEInsert ×2 + 0x158c scroll update. |
| `FUN_000014a0` (ID04) | `draw_scrolling_text_item` | PROVEN | Iter 183: bytes; EraseRect viewRect, TEUpdate, frame. |
| `FUN_000014f2` (ID04) | `scrolling_text_user_item_proc` | PROVEN | Iter 183: bytes; Pascal user item, JT $92. |
| `FUN_0000150e` (ID04) | `sync_text_scroll_to_control` | PROVEN | Iter 183: bytes; TEScroll by ctl value × lineHeight. |
| `FUN_00001562` (ID04) | `update_scroll_bar_maximum` | PROVEN | Iter 183: bytes; SetCtlMax(nLines − visible). |
| `FUN_0000158c` (ID04) | `scroll_text_to_show_selection` | STRONG INFERENCE | Iter 183: bytes; centre line holding selStart. |
| `FUN_00001638` (ID04) | `fit_text_view_to_box` | PROVEN | Iter 183: bytes; viewRect = box − 16, whole lines, TECalText. |
| `FUN_000016c4` (ID04) | `scroll_bar_action_proc` | PROVEN | Iter 183: bytes; JT $16a TrackControl action; parts 20..23; also documents unexported click handler 0x1752. |
| `FUN_000018e0` (ID04) | `get_mission_kill_report_state` | STRONG INFERENCE | Iter 184: bytes; 0/1/2 from A5-0x12f8, -0x14c0, -0x12ba and ten kill words A5-0x12ce. |
| `FUN_0000192e` (ID04) | `update_summary_dialog_buttons` | STRONG INFERENCE | Iter 184: bytes; enables items 1/3; moves default ring A5-0x225e to item 1. |
| `FUN_00002d86` (ID04) | `set_score_item_text` | PROVEN | Iter 185: "Score: " + compute_pilot_score. |
| `FUN_00001f5e` (ID04) | `draw_aircraft_kill_markers` | STRONG INFERENCE | Iter 186: tallies 0+1, red discs, under "Total Aircraft Destroyed". |
| `FUN_000020e8` (ID04) | `aircraft_kill_markers_user_item_proc` | PROVEN | Iter 186: JT $ea user item. |
| `FUN_00001bc8` (ID04) | `draw_targets_destroyed_row` | STRONG INFERENCE | Iter 187–188: per target type; skips 2/4/8; count and count × weight. |
| A5−0xf5e | per-target-type point weights (words) | STRONG INFERENCE | Iter 188: count × weight in draw_targets_destroyed_row and compute_pilot_score. |
| A5−0x2226 | pointer to the Mission Summary kill counts (local array) | PROVEN | Iter 188: set at ID04 0x2e00. |
| `FUN_00001d9e` (ID04) | `draw_targets_destroyed_list` | PROVEN | Iter 187: JT $aa user item 6. |
| ID04 0x1dde (unexported, JT $152) | `draw_mission_awards` | STRONG INFERENCE | Iter 187: record +0x26 bits -> cicn 512–519. |
| ID04 0x1b3e (unexported, JT $15a) | `draw_rank_insignia` | STRONG INFERENCE | Iter 187: cicn 256 + rank. |
| ID04 0x2104 (unexported, JT $ca) | `mission_summary_filter_proc` | STRONG INFERENCE | Iter 185: ModalDialog filter; comment block in ID04.decomp.c. |
| ID04 0x21d6 (unexported) | `advance_mission_summary_text` | STRONG INFERENCE | Iter 185: state machine on A5-0x2222. |
| A5−0x2222 / −0x2230 / −0x222c | summary text state / step delay (ticks) / last step tick | STRONG INFERENCE | Iter 185. |
| ID02 0x2c8 / 0x2d8; ID09 0x416 | strcpy / strcat; C-to-Pascal string in place | PROVEN | Iter 185: bytes. |
| A5−0x12ce | ten per-mission kill counters (one per target type) | STRONG INFERENCE | Iter 184: get_mission_kill_report_state; "No new kills to report." |
| A5−0x12b4 / A5−0x14c4 | current pilot status / mission-over flag | STRONG INFERENCE | Iter 178. |
| A5−0xffe / A5−0xfae / A5−0xf86 | rank / pilot-status / target-type string groups | PROVEN (dump) | Iter 176: STR#129 slots 94-99 / 100-105 / 106-115. |
| HEL1 127 / HEL1 128 | "Hellcats Saved Settings" / "Player and Score Data" | PROVEN (dump names) | Iter 176. |
| ALRT 258 "Error" ("^1 ^0.") | used by ID02 show_caution_alert_with_number | PROVEN (dump) | Iter 175. |
| ID04 file 0x432 (unexported) | panel-store failure report (proposed) | PROVEN bytes | Iter 172: flag A5−0x14a0 → JT $462 + alert slot 1. |
| STR# 129 text | `artifacts/reverse-engineering/resources/resource_dasm_Hellcats_app/` | PROVEN (dump) | Files 0-based; game slot n ↔ file n−1. Slot 93 = out-of-memory message; slot 65 = ALTITUDE. |
| ID02 `FUN_0000001e` | `abs_long` (renamed iter 162) | PROVEN (C) | JT $4da; used by nearest_palette_index_rgb. |
| A5−0x1614 / A5−0x161c | QuickDraw globals `white` / `black` patterns | STRONG INFERENCE | Standard QD global order below thePort (A5−0x160c). |
| low-memory $0196 | `Lvl1DT[1]` (VBL level-1 interrupt vector) | STRONG INFERENCE | Saved in A5−0xc36; replaced by A5−0x360 handler. |
| A5−0x7d0 | sound channel records [2] × 0x238 bytes | STRONG INFERENCE | Indexed by silence_sound_channel / FUN_00003d50. |
| ID02 file 0x1b42 (unexported) | `install_overlay_service_table` (proposed) | STRONG INFERENCE | Iter 135: 34 JT addresses → A5 table; A5−0x1040 work buffer. See OVERLAY_SERVICE_TABLE.md. |
| A5−0x1040 | overlay work buffer (HYPOTHESIS name) | PROVEN allocation | NewPtrClear(320400 or 220400) by FreeMem > 1 MB. |
| A5−0x103a | offscreen GrafPort pointer (HYPOTHESIS name) | STRONG INFERENCE | Disposed by close_and_dispose_port; created by FUN_00000d3a when 0. |
| `FUN_00004b62` (ID02, not decompiled) | `init_standard_colour_indices` (proposed) | STRONG INFERENCE | Iter 132: 9 grey-level lookups → A5 colour-index words (−0x11ae … −0x11f8). |
| A5−0x136e | device table [4] × 0x16 bytes (slots 1..3 used) | STRONG INFERENCE | +0 GDevice handle (SetGDevice in FUN_000048ae), +4 stored word array. |
| `FUN_00000728` (ID05) | `ansi_rand` | PROVEN | Iter 118: seed A5−0x6c ×0x41c64e6d +0x3039; returns (seed<<1)>>17. |
| `FUN_00000746` (ID05) | `ansi_srand` | STRONG INFERENCE | Stores arg to A5−0x6c. Caller: ID05 0x8c0 (init_protection_table, seeded by TickCount). |
| `FUN_000007f6` (ID05) | `poison_overlay_bytes` | STRONG INFERENCE | 12 × {ptr, byte} into A5−0xb4, byte := 0xFF at base + rand % size. Called from ID08 0x246 (JT $53a) with overlay base/code size. |
| `FUN_0000085e` (ID05) | `restore_poisoned_overlay_bytes` | STRONG INFERENCE | Restores A5−0xb4 table if A5−0xbc / A5−0xc0 set. Called from ID08 0x29e (JT $55a). |
| `FUN_00000934` (ID05) | `record_code_index_equals` | STRONG INFERENCE | Iter 119: (s8)rec[4]*20 + (s8)rec[5] == n → word 1/0. Called from ID08 0x282/0x2b2 (JT $54a); success at 0x282 → JT $532 stub (ID05 0x8b2) A5−0xbc++. |
| `FUN_00000754` (ID05) | `encode_base26_6chars` | PROVEN | Iter 120: 6 chars 'A'+(v%26) right-to-left, NUL; DIVS.L #26 at 0x76c/0x784. |
| `FUN_000007a8` (ID05) | `decode_base26_6chars` | PROVEN | Iter 120: acc = acc*26 + ((s8)c − 'A') over 6 chars → *out. |
| `FUN_00000a62` (ID05) | `random_28bit_value` | STRONG INFERENCE | Iter 121: caller 0x442; see ID05.decomp.c header. |
| `FUN_00000a90` (ID05) | `pack_fields_to_code_buf68` | STRONG INFERENCE | Iter 121: caller 0x498; buf A5−0x68; see ID05.decomp.c header. |
| `FUN_00000b10` (ID05) | `unpack_fields_from_code` | STRONG INFERENCE | Iter 121: no caller found; see ID05.decomp.c header. |
| `FUN_00000b84` (ID05) | `encode_code28_to_buf54` | STRONG INFERENCE | Iter 121: ID05 0x4b2; ID08 0x276/0x2a6 (JT $552); see ID05.decomp.c header. |
| `FUN_00000ba8` (ID05) | `decode_code_to_long_a` | STRONG INFERENCE | Iter 121: no caller found; see ID05.decomp.c header. |
| `FUN_00000bc2` (ID05) | `encode_long_to_buf40` | STRONG INFERENCE | Iter 121: caller 0x4ce; see ID05.decomp.c header. |
| `FUN_00000bde` (ID05) | `decode_code_to_long_b` | STRONG INFERENCE | Iter 121: caller 0x674; see ID05.decomp.c header. |
| `FUN_000002c8` (ID05) | `code_dialog_filter` | STRONG INFERENCE | Iter 122: ModalDialog filter (SetPort, default-button FrameRoundRect, HiliteControl on empty item 3, Return/Enter→1, Esc→2). File 0x3ba..0x4e2 is a separate unexported code-string builder. |
| `FUN_00000160` (ID05) | `read_DATA128_pair` | STRONG INFERENCE | Iter 123: two longs at start of resource 128; callers ID08 0x26c (JT $582). |
| `FUN_000001bc` (ID05) | `write_DATA128_pair` | STRONG INFERENCE | Iter 123: two longs at start of resource 128; callers ID08 0x2c4 (JT $57a). |
| `FUN_00000214` (ID05) | `read_TEXT128_pair` | STRONG INFERENCE | Iter 123: two longs at start of resource 128; callers ID05 0x3f4, 0x458. |
| `FUN_00000270` (ID05) | `write_TEXT128_pair` | STRONG INFERENCE | Iter 123: two longs at start of resource 128; callers ID05 0x44a, 0x718. |
| `FUN_00000006` (ID05) | `center_template_rect_on_screen` | STRONG INFERENCE | Iter 124: GetResource(type,id) rect centred horizontally, top at mbar + 1/3 of remaining height. |
| `FUN_000000c8` (ID05) | `get_machine_screen_fingerprint` | STRONG INFERENCE | Iter 124: machineType, screen width/height, depth (GDevice or screenBits), 0. |
| `FUN_000004e4` (ID05) | `get_dialog_item_text_upper` | STRONG INFERENCE | Iter 125: GetIText → C string → upper (ctype A5−0x1608 bit 7 → ID02 0x1ce). |
| `FUN_00000560` (ID05) | `run_protection_dialog` | STRONG INFERENCE | Iter 125: DLOG 1000 challenge/response loop; Alert 1001 ($A985, corrected iter 138); called from ID08 0x298 (JT $572). |
| `FUN_000008d6` (ID05) | `pick_random_protection_challenge` | STRONG INFERENCE | Iter 125: random entry of table *(A5−0xba)[A5−0xb6] → 3 words. |
| `FUN_000008b8` (ID05, not decompiled) | `init_protection_table` (proposed) | STRONG INFERENCE | Iter 126: ansi_srand(arg3); A5−0xba = arg1; A5−0xb6 = arg2; called from ID08 0x25c (JT $542) with (A5−0x1cc4, 56, TickCount). |
| A5−0x1cc4 | protection challenge table (56 × 12 bytes) | STRONG INFERENCE | Passed to init_protection_table; entries {ptr, len, w1, w2, w3}. See COPY_PROTECTION_FLOW.md. |
| A5−0x1680..−0x167a | QuickDraw `screenBits.bounds` (top,left,bottom,right) | STRONG INFERENCE | Used as screen rect in ID05 0x06/0xc8. |
| ID05 file 0x964 (unexported) | protection entry matcher (HYPOTHESIS) | PROVEN bytes | Counts matching entries of table *(A5−0xba)[A5−0xb6] into A5−0xc0; string de-obfuscated with key A5−0x2c. |
| ID02 local 0x2eaa (unexported) | `quit_application` (proposed) | STRONG INFERENCE | Iter 174: confirm (seg4 0x516 == 2), save prompt (seg4 0x4f0), HideWindow, ExitToShell. Menu 2 item 13 and fatal MENU-missing path. |
| `FUN_00002e36` (ID02) | `show_resource_file_error_box` | STRONG INFERENCE | Iter 174: "Can't open resource file." / "Click mouse to exit." dBox. |
| A5−0x14ca | `main_window` (HYPOTHESIS name) | STRONG INFERENCE | SetPort target at end of `initialize_application`; compared with update evt.message in `poll_and_dispatch_event`. |
| A5−0x1388 | `has_color_quickdraw` (HYPOTHESIS name) | STRONG INFERENCE | byte ← SysEnvRec.hasColorQD in `initialize_application`. |
| A5−0x1006 | `overlay_image_base` (HYPOTHESIS name) | PROVEN writer | Written only by ID08 `load_overlay_from_resource` (file 0xd4, aligned 0xf0/0xfe, cleared 0x226); gates overlay callbacks in ID02. |
| A5−0x1092 / −0x104e / −0x1096 | overlay callback slots (UNKNOWN names) | STRONG INFERENCE | Only read (MOVEA.L + JSR (A0)) in ID02; no d16(A5) writer in any CODE segment → filled indirectly. |
| A5−0x138a | `settings_dirty` (HYPOTHESIS name) | STRONG INFERENCE | Set to 1 by every persisted option change in `do_menu_command`; cleared by save helper 0x2da0 after WriteResource(HEL1 127). |
| A5−0x13ac / A5−0x13a8 | `hel1_127_handle` / `hel1_128_handle` | PROVEN role (resource handles) | GetResource('HEL1',0x7f/0x80) results; 0x12a / 0x500-byte defaults. |
| A5−0xf46 | `str129_string_ptrs[121]` (HYPOTHESIS name) | STRONG INFERENCE role | Written by `load_str129_string_table` slots 1..120; read by `init_string_pointer_groups`. |
| JT `$4fa(A5)` → `FUN_0000024a` (ID02) | memmove-like (not renamed yet) | STRONG INFERENCE | Overlap-safe byte copy (dst, src, n) in ID02.c:218; CODE0 jump table entry seg 2 off 0x246. |
| JT `$3a(A5)` → ID01 file 0xbe | runtime word switch helper (no Ghidra function) | PROVEN bytes | Pops return addr as table: lo, hi, default; offsets relative to their own word; zero offset → `BEQ *` hang. |
| `FUN_00000432` (ID09) | `length_prefixed_bytes_to_c_string_in_place` | STRONG INFERENCE | `ID09.c:135-142`: unsigned byte length, forward overlapping copy, zero terminator, original-pointer return. No direct callers found. C transform preserved. Iter 108: bytes at ID09.bin file 0x432..0x44a match (DBRA shift loop, CLR.B terminator, return arg) — p2cstr-like. |
| `FUN_00000006` (ID08) | `load_overlay_from_resource` | STRONG INFERENCE | ID08.bin `@0x6`: A5 `$2a2/$2b2/$232/$2aa/…`; ret 0 fail / 1 ok; LOADER_CHAIN overlay candidate. |
| `FUN_00000348` (ID08) | `alloc_and_read_resource_payload` | PROVEN | ID08.bin `@0x348`: A5 `$2ca`/`$2c2` size; `$22a` alloc→`A5-0x12fc`; `$2b2` read. |
| `FUN_00000338` (ID08) | `sysbeep_and_exit_to_shell` | PROVEN | ID08.bin `@0x338`: `MOVE.W #$64,-(A7); _SysBeep ($A9C8); _ExitToShell ($A9F4)`. |
| `FUN_0000039c` (ID08) | `bootstrap_window_and_load_overlay` | PROVEN call | ID08.bin `@0x39C`: window/port traps; fourcc `'HELL'`; `JSR (d16,PC)` → `load_overlay_from_resource` `@0x6`. |
| `FUN_00000020` | `overlay_patch_template_u16_pair` | STRONG INFERENCE | Binary at overlay file offset `0x20`: `LEA $1A7D2; MOVE.W 6(A7),D0; MOVE.W D0,(A0); MOVE.W D0,$4A(A0); RTS`. Call sites pass `0x195` / `0x1d5` from mission-setup branch on `*(short*)(DAT_0001b5a0+0xe)`. Cells are +0x0C fields of adjacent `0x4A` template records. **Not** a 32-bit load-base writer. |
| `FUN_00000032` | `copy_block_return_dst` | STRONG INFERENCE | Binary @ `0x32`: saves D2, calls `FUN_0001a63e(src,dst,n)` (args reordered), returns `dst` in D0. Used throughout `FUN_00000054` after `FUN_00001a48` with lengths `0x4A`/`0x1A`/`0x1C`/`0x20`. |
| `FUN_00000054` | `overlay_init_template_pointer_tables` | STRONG INFERENCE | Capstone `@0x54`–`0x332`: Block A 4×`0x4A` keyed; Block B 16 fixed `0x1A`/`0x20`→`DAT_0001b538`…`1b574`; Block C 5×`0x1C` keyed from `$1AA5E`; Block D five `0x1A`→`DAT_0001b58c`…`1b59c`. Caller `init_mission_object_tables`. |
| `FUN_000016e2` | `init_mission_object_tables` | STRONG INFERENCE | `@0x16E2`: BSR `$54` then `instantiate_object_from_desc`/`heap_alloc`; builds count×`0x18` child table; publishes `DAT_0001d6fc`, `1bdb4`/`b0`/`ac`/`a8`/`a4`, `bc28`/`34`/`38`. |
| `FUN_00004690` | `instantiate_object_from_desc` | STRONG INFERENCE | `@0x4690`: `alloc_object_from_desc`; if `desc[1]!=0` call `*(DAT_0001b524[type]+6)(obj,type,0)` → store at `obj+8`. |
| `FUN_000045ba` | `alloc_object_from_desc` | STRONG INFERENCE | `@0x45BA`: kind 2→size `0x52`, kind 3→size `0x34` via `heap_alloc_cleared`; copies descriptor fields. |
| `FUN_00001b6c` | `heap_alloc_cleared` | STRONG INFERENCE | `@0x1B6C`: `heap_alloc` then `heap_zero_payload`. |
| `FUN_00001b38` | `heap_zero_payload` | PROVEN | `@0x1B38`: derive payload size from heap header (`0xFF` large vs size-class); call `memzero`. |
| `FUN_0001a716` | `memzero` | PROVEN | `@0x1A716`: aligned CLR.B/CLR.L zero-fill of `nbytes` at `dst`. |
| `FUN_000044e8` | `run_simulation_tick` | PROVEN structure | `@0x44E8`: gate on `DAT_0001b5a0+0xac/+0xa8`; four entity-array passes via `dispatch_entity_tick` (path 0,0,1,1); then `FUN_00006fb8`. |
| `FUN_000044a4` | `dispatch_entity_tick` | STRONG INFERENCE | `@0x44A4`: call `apply_entity_mission_rates`; optional `entity+4` bit `0x40` from linked type word `5` vs mission `+0xB0`. |
| `FUN_0000435a` | `apply_entity_mission_rates` | STRONG INFERENCE | `@0x435A`: scale mission-table rates into `entity+0xC`; kind-2 path-0 updates `*(entity+0x48)+0x1C` slots. |
| `FUN_00005df8` | `clear_pending_entity_slots` | STRONG INFERENCE | `@0x5DF8`: for `i=0..6`, if `DAT_0001bc64[i]` non-null call `dispatch_entity_cleanup` then clear slot. |
| `FUN_0000528a` | `dispatch_entity_cleanup` | STRONG INFERENCE | `@0x528A`: skip if `flags_07&2`; else `retire_entity` or type-2 soft (`flags\|0x42`, `field_3c=DAT_0001b838`). |
| `FUN_000051ec` | `retire_entity` | STRONG INFERENCE | `@0x51EC`: clear b880/bc64/table; `+0x18=1e9`; `flags\|2`; null `**(+8)`; `DAT_00024cf0++`. |
| `FUN_00005116` | `spawn_mission_pool_object` | STRONG INFERENCE | `@0x5116`: free `0x18` slot in `*(DAT_0001d6fc+0x30)`; fill xyz/att; `instantiate_mission_pool_slot`; gate on `world+0x44`. |
| `FUN_000046da` | `instantiate_mission_pool_slot` | STRONG INFERENCE | `@0x46DA`: alloc from desc; publish slot+0x14; identity; factory; rates; `04e6e` vs `DAT_0001d0e4` queue. |
| `FUN_00012840` | `spawn_weapon_entity` | STRONG INFERENCE | `@0x12840`: pool spawn via `DAT_00026280`; entity `field_610`/`61c`/`+0x20..24`. |
| `FUN_00015d20` | `spawn_ordnance_oriented` | STRONG INFERENCE | `@0x15D20`: `build_attitude_matrix_x` then `spawn_ordnance_scattered`. |
| `FUN_00015bf6` | `spawn_ordnance_scattered` | STRONG INFERENCE | `@0x15BF6`: RNG±0x20 scatter; pool `DAT_0002664a`; write vel/`0x3a`/`+0x40` matrix. |
| `FUN_0000262e` | `build_attitude_matrix_x` | PROVEN chain | `@0x262E`: `0202a`→`025d6` (X-axis sibling of `025a8`). |
| `FUN_00019430` | `spawn_special_weapon_entity` | STRONG INFERENCE | `@0x19430`: pool `DAT_00026780`; fields `610/614/618/61c`; 0xD verts `>>3` → `622/656/68a`. |
| `FUN_0000e40c` | `fold_angle_pm_0x2000` | PROVEN | `@0xE40C`: if `>0x2000` −`0x4000`; if `<−0x2000` +`0x4000`. |
| `FUN_0001a63e` | `memmove_block` | PROVEN | `@0x1A63E`: `(src,dst,n)` overlap-aware copy; longword fast path when `n>0x19`. |
| `FUN_00001ba8` | `heap_realloc_grow_only` | PROVEN | `@0x1BA8`: if request > header capacity → `heap_calloc`+`memmove_block`+`heap_free_coalesce`. |
| `FUN_00001b84` | `heap_calloc` | STRONG INFERENCE | `@0x1B84`: `heap_alloc(a*b)` then `heap_zero_payload`. |
| `FUN_00002e08` | `abs_int` | PROVEN | `@0x2E08`: `MOVE.L 4(A7),D0` / `BGE` / `NEG.L` / `RTS`. ~49 BSR.L call sites. |
| `FUN_00002de8` | *(false entry of `FUN_00002d10`)*; callsite→`abs_int` | bytes PROVEN; callsite STRONG INFERENCE | `@0x2DE8`: mid-epilogue `TST D4`/`BNE` + xyz commit + `UNLK`/`RTS`. 19× `LEA $2DE8`+`JSR` push/arg/D0 look like abs; 0 direct BSR to `2DE8`. **BLOCKED** until LEA target explained. |
| `FUN_00004e6e` | `activate_near_range_object` | STRONG INFERENCE | `@0x4E6E`: kind2 list+`(36+3a)*0xC` via `$1A48`→`+0x4c/+0x44`+`04808`+flag-gated `02bd8`; kind3 child `0x18` table+`046da`; ends `03b98`. Gate for `spawn_mission_pool_object`. |
| `FUN_00004808` | `build_object_poly_buffers` | PROVEN layout | `@0x4808`: `heap_alloc` → `obj+0x48`; poly stride `0x20` from stream; index `heap_alloc(count<<1)` → `+0x18`; optional `(+6)&2` trailer; `DAT_0001daa2=1`. |
| `FUN_00002bd8` | `apply_template_chain_xform` | STRONG INFERENCE | `@0x2BD8`: walk `obj+0x24` chain; optional `0253e`+`02ada` if slot angles≠0; `01c5c` translate; null-aux commits `+0x18/1c/20`; mesh path uses count/`+0x34` shift into `param_4`. |
| `FUN_00002d10` | `apply_template_chain_xform_always` | STRONG INFERENCE | `@0x2D10`: same chain/commit as `02bd8` but always `0253e`; no `+0x34` shift; epilogue bytes falsely labeled `FUN_00002de8`. Caller `FUN_000168d2`. |
| `FUN_0000253e` | `build_attitude_matrix_3ang` | PROVEN chain | `@0x253E`: `0202a(p1,p2,p3,0)` then `finalize_attitude_matrix_3ang(out)`. 3-angle sibling of `build_attitude_matrix` (4ang). |
| `FUN_000024f8` | `finalize_attitude_matrix_3ang` | PROVEN chain | `@0x24F8`: `DAT_00020ce4=$2408`; `020e6`; `01d02($1d7a4,$1d7d4,temp)` then `01d02(temp,$1d7bc,out)`. |
| `FUN_00002428` | `finalize_attitude_matrix_3ang_alt` | PROVEN | `@0x2428`: `020e6`; `temp=1d7bc×1d7d4`, `out=temp×1d7a4`; no `$2408` tag. |
| `FUN_00002464` | `build_attitude_matrix_3ang_alt` | PROVEN chain | `@0x2464`: `0202a(…,0)` then `finalize_attitude_matrix_3ang_alt(out)`. |
| `FUN_00002ada` | `transform_int3_vecs_by_matrix3` | PROVEN | `@0x2ADA`: expand 9×s16 matrix; for each of `count` int[3] verts, 3× 64-bit dots → `(hi<<0x14)|(lo>>0xc)`. Sibling of `transform_vecs12_by_matrix3`. |
| `FUN_00001c5c` | `translate_int3_vecs` | PROVEN | `@0x1C5C`: DBRA count over int[3]; `dst = src + (dx,dy,dz)`. Sibling `scale_int3_vecs` uses `MULS.L`. |
| `FUN_00001cac` | `scale_int3_vecs` | PROVEN body | `@0x1CAC`: same loop as translate but `dst = src * (sx,sy,sz)`. No overlay absolute/BSR refs found. |
| `FUN_0000202a` | `load_attitude_angle_sincos` | PROVEN | `@0x202A`: for each of 4 angles, `cos_fixed14` then `sin_fixed14` into `DAT_0001d7fa/fc`, `f6/f8`, `f2/f4`, `ee/f0`. |
| `FUN_00001d76` | `sin_fixed14` | PROVEN | `@0x1D76`: lerp on `DAT_0001ab6c[angle>>6]`; frac `&0x3F`. |
| `FUN_00001dd8` | `cos_fixed14` | PROVEN | `@0x1DD8`: same as sin on `DAT_0001ad6c`. |
| `FUN_00001e3a` | `acos_fixed14` | PROVEN | `@0x1E3A`: clamp ±0x1000; binary search + lerp on cos table `DAT_0001ad6c` → angle. |
| `FUN_00001ebc` | `atan_fixed14` | STRONG INFERENCE | `@0x1EBC`: binary search+lerp on `DAT_0001af6c` longs; `((idx−0x3f)<<6)+frac & 0x3fff`. Heading via ratio+quadrants. |
| `FUN_000102d6` | `atan2_fixed14` | STRONG INFERENCE | `@0x102D6`: abs(dx),abs(dy) then `atan_fixed14` + 0x1000/0x2000 quadrants → 14-bit heading. |
| `FUN_000109ba` | `apply_relative_heading_steer` | STRONG INFERENCE | `@0x109BA`: atan2 on rel +2/+6, fold, range-blend vs +0x24, smooth +0x61e, `enqueue_control_inputs_avg4`. |
| `FUN_00010558` | `enqueue_control_inputs_avg4` | PROVEN | `@0x10558`: clamp; 4-slot rings +0x644/4c/54; means → +0x666/+0x662/+0x664; gated by +0x685 bit0. |
| `FUN_00010b2e` | `steer_entity_toward_point` | STRONG INFERENCE | `@0x10B2E`: `build_relative_steer_sample` then `apply_relative_heading_steer`; target world XYZ. |
| `FUN_00010360` | `build_relative_steer_sample` | STRONG INFERENCE | `@0x10360`: range→*p5; scaled Δxyz@p6+2/6/a; body rot; attitude_from_velocity→*p7/*p8. |
| `FUN_00010cb2` | `max_ai_throttle_maybe_invert_679` | STRONG INFERENCE | `@0x10CB2`: +0x668←9; if +0x679>0 and altΔ>100 then neg +0x679. |
| `FUN_00010c2c` | `adjust_ai_throttle_vs_speed` | STRONG INFERENCE | `@0x10C2C`: (target−(+0x62a>>2)) blend → ± into +0x668 [0..9]; extremes touch +0x679 / max_ai_throttle…. |
| `FUN_00010cd8` | `invert_ai_bias_67b_if_positive` | PROVEN | `@0x10CD8`: if +0x67b>0 then neg.b +0x67b. |
| `FUN_00010b84` | `ai_bootstrap_climb_phase` | STRONG INFERENCE | `@0x10B84`: init biases; throttle 9; pitch fold(0x2c0−att); enqueue; ret altΔ>2000. |
| `FUN_00010ce8` | `tick_ai_climb_then_waypoint` | STRONG INFERENCE | `@0x10CE8`: +0x616 script; phase0 climb else waypoint+throttle+steer; `update_aircraft_entity`. |
| `FUN_00010d68` | `ensure_ai_script_1b2e0_tick` | STRONG INFERENCE | `@0x10D68`: alloc script from `DAT_0001b2e0`, word1=0x9d8; `tick_ai_climb_then_waypoint`. |
| `FUN_00010da8` | `ensure_ai_script_1b310_tick` | STRONG INFERENCE | `@0x10DA8`: `DAT_0001b310`, word1=0xd5c; then tick. |
| `FUN_00010de8` | `ensure_ai_script_1b340_tick` | STRONG INFERENCE | `@0x10DE8`: `DAT_0001b340`, word1=0x9d8; then tick. |
| `FUN_00010e28` | `ai_script_try_fire_burst` | STRONG INFERENCE | `@0x10E28`: after [0x1ab]≤time, fire via `spawn_weapon_entity` until +0x67c==0 → return 1. |
| `FUN_00010ecc` | `tick_ai_1b310_approach_fire` | STRONG INFERENCE | `@0x10ECC`: `ensure_ai_script_1b310_tick`; script 1→2 on approach; 2→3 on fire-burst done. |
| `FUN_00010f68` | `tick_ai_1b370_mission` | STRONG INFERENCE | `@0x10F68`: script `DAT_0001b370`; phases climb/fire/waypoint/chase player; `update_aircraft_entity`. |
| `FUN_00019fba` | `try_begin_landing_approach` | STRONG INFERENCE | `@0x19FBA`: `find_nearest_runway_approach_ends`+range → `DAT_000267xx` glide; +0x32=`0x1A186`; ret 0/1. |
| `FUN_00019c5e` | `find_nearest_runway_approach_ends` | STRONG INFERENCE | `@0x19C5E`: nearest type2/0x200 pad ('p',4); two XYZ ends; 0 if score<0x40740. |
| `FUN_00019c26` | `store_xyz_asr` | PROVEN | `@0x19C26`: ASR x/y/z by s into A1 dest; used with entity +0x34 scale. |
| `FUN_0001a1a6` | `tick_landing_approach_glide` | STRONG INFERENCE | `@0x1A1A6`: consume `DAT_000267xx` glide; steer/throttle; restore +0x32 on +0x63e. |
| `FUN_00000354` | `probe_nearest_facility_kind` | PROVEN | `@0x0354`: nearest pool entity kind 0x12/0x13 → flags 0x100/0x200 (stack entity arg; Ghidra void wrong). |
| `FUN_00003c48` | `approx_dist3_from_abs` | PROVEN | `@0x3C48`: max+(a+b)>>2 on abs components in D0/D1/D3. |
| `FUN_00003c68` | `approx_dist3_xyz` | PROVEN | `@0x3C68`: six stack XYZ; abs Δs then same combine. |
| `$1A186` | *(false mid → `tick_landing_approach_glide`)* | BLOCKED | `0x1A1A6−0x20`; literal stored by `try_begin_landing_approach`. |
| `FUN_00001d02` | `matmul3x3_s16` | PROVEN | `@0x1D02`: 3×3 s16 `out=left×right`, each element 3×`MULS.W` then `ASR #12`. |
| `FUN_000020e6` | `fill_attitude_rotation_bases` | PROVEN layout | `@0x20E6`: expand sincos pairs 1–3 into bases at `DAT_0001d7d4` / `1d7bc` / `1d7a4` (≈Rx/Ry/Rz, `0x1000`=1). |
| `FUN_000021a0` | `fill_attitude_rotation_basis_4` | PROVEN layout | `@0x21A0`: angle4 (`1d7ee/f0`) → `DAT_0001d78c` as ≈Ry `[[c,0,s],[0,1,0],[-s,0,c]]`. |
| `FUN_00002562` | `finalize_attitude_matrix_4ang` | PROVEN | `@0x2562`: `out=(1d78c×1d7a4)×1d7d4×1d7bc` via three `matmul3x3_s16`. |
| `FUN_000021e0` | `fill_attitude_rotation_basis_4_rx` | PROVEN layout | `@0x21E0`: angle4 → `DAT_0001d78c` as ≈Rx `[[1,0,0],[0,c,-s],[0,s,c]]`. |
| `FUN_000020a0` | `load_attitude_angle_sincos_5_6` | PROVEN | `@0x20A0`: ang5→`1d7ea/ec`, ang6→`1d7e6/e8` via `cos_fixed14`/`sin_fixed14`. |
| `FUN_00002220` | `fill_attitude_rotation_bases_5_6` | PROVEN layout | `@0x2220`: `1d774`≈Rx from `1d7ea/ec`; `1d75c`≈Ry from `1d7e6/e8`. |
| `FUN_000025d6` | `compose_attitude_matrix_x` | PROVEN | `@0x25D6`: tag `$2468`; `fill_attitude_rotation_bases` + `_basis_4_rx` + three `matmul3x3_s16` (same product as `finalize_attitude_matrix_4ang`). |
| `FUN_00002488` | `compose_attitude_matrix_x_alt` | PROVEN | `@0x2488`: `020e6`+`021e0`; `((1d7bc×1d7d4)×1d7a4)×1d78c`; no `$2468`. |
| `FUN_000024d6` | `build_attitude_matrix_x_alt` | PROVEN chain | `@0x24D6`: `0202a(a,b,c,d)` then `compose_attitude_matrix_x_alt(out)`; no arg shuffle. |
| `FUN_00002654` | `compose_attitude_matrix_6ang` | PROVEN | `@0x2654`: tag `$26e0`; `020e6`+`021e0`+`02220`; five `matmul3x3_s16` over `1d774/75c/78c/7a4/7d4/7bc`. |
| `FUN_000026cc` | `build_attitude_matrix_6ang` | PROVEN chain | `@0x26CC`: `0202a` + `load_attitude_angle_sincos_5_6` + `compose_attitude_matrix_6ang`. |
| `FUN_00002700` | `compose_attitude_matrix_6ang_alt` | PROVEN | `@0x2700`: same fills as 6ang; five matmuls reversed; no `$26e0`. |
| `FUN_0000276e` | `build_attitude_matrix_6ang_alt` | PROVEN chain | `@0x276E`: `0202a` + `load_attitude_angle_sincos_5_6` + `compose_attitude_matrix_6ang_alt`. |
| `FUN_000027a2` | `invoke_tagged_attitude_compose_neg_sins4` | PROVEN | `@0x27A2`: NEG.W sins `1d7fc/f8/f4/f0`; JSR through `DAT_00020ce4` (`$2408`/`$2468`/`$26e0`). |
| `FUN_000027cc` | `invoke_tagged_attitude_compose_neg_sins6` | PROVEN | `@0x27CC`: NEG.W sins `1d7fc/f8/f4/f0/ec/e8`; JSR through `DAT_00020ce4`. |
| `FUN_0000229e` | `build_attitude_matrix_from_dir_roll` | PROVEN math | `@0x229E`: isqrt dir → sincos slots → two `matmul3x3_s16`; hosts tag `$2408` at matmul PEA. |
| `DAT_00020ce4` | `attitude_compose_tag` (code ptr) | PROVEN use | `$2468`/`$26e0` secondary entries; `$2408` literal mid-`0229e` but `≡ finalize_…_3ang_alt−0x20` — A890 A6 check favors +0x20 false-address reading. |
| `FUN_00003b98` | `update_object_camera_metric` | PROVEN | `@0x3B98`: abs(`+0x18/1c/20` − `d838/834/830`); `metric=max+((a+b)>>2)` → `obj+0x10` and D0. |
| `FUN_00003c00` | `compute_camera_abs_metric` | PROVEN | `@0x3C00`: abs(x/y/z − `d838/834/830`); same metric; returns D0 only (no `+0x10` store). |
| `FUN_00003be0` | *(false mid-`update_object_camera_metric`)* | BLOCKED | `@0x3BE0` = first axis-swap inside `@0x3B98`; not a real entry. |
| `FUN_00001d56` | *(false mid-`matmul3x3_s16`)*; callsite→`sin_fixed14` | BLOCKED | `@0x1D56` = `$1D76−0x20` (ASR inside matmul). |
| `FUN_00001db8` | *(false mid-`sin_fixed14`)*; callsite→`cos_fixed14` | BLOCKED | `@0x1DB8` = `$1DD8−0x20`. |
| `FUN_00006fb8` | `reset_distance_base_globals` | STRONG INFERENCE | `@0x6FB8`: six `MOVE.L #$05F5E100` to `DAT_0001d710/14/18/1c/20/24`. |
| `FUN_0000e792` | `update_aircraft_entity` | STRONG INFERENCE | Blocks 0–7c; Block1 Capstone@E8A0 links avg4→662/666 (iter 94). Callers: climb/waypoint/AI ticks — not sim tick. |
| `entity+0x662` | `ctrl_avg_pitchish` (from avg4 p3) | STRONG INFERENCE | Filled by `enqueue_control_inputs_avg4`; jittered if `flags_685` bit2. |
| `entity+0x666` | `ctrl_avg_heading` (from avg4 p4) | STRONG INFERENCE | Filled by avg4; jittered if `flags_685` bit3; force 0xFF80 if +0x684 bit0. |
| `entity+0x685` | `flags_685` | PROVEN | bit0 gates avg4; bit2/3 RNG jitter; bit0 of +0x684 clears/forces controls. |
| `FUN_0000e372` | `isqrt_floor` | PROVEN | `@0xE372`: binary-search floor sqrt on `[0,0x7FFF]`. |
| `FUN_0000e3b2` | `acos_scaled_dot3` | PROVEN | `@0xE3B2`: `(dot3>>4)/((p4*p8)>>16)` then `acos_fixed14`; 0 if denom 0. |
| `$E352` / `LAB_0000e350_2` | *(false)*; callsite→`isqrt_floor` | BLOCKED | `@0xE352=$E372−0x20`; mid-BSR garbage; LEA @0x22CC + table `$32E` @0x11C4. |
| `FUN_00001f22` | `attitude_from_velocity` | STRONG INFERENCE | `@0x1F22`: velocity → two 14-bit attitude outs via `01ebc`/`01e3a`. |
| `FUN_00011564` | `overlay_rng_next` | PROVEN | `@0x11564`: additive table RNG on `DAT_00026008…0x260E7`; return `sum>>16`. |
| `FUN_000114ca` | `overlay_rng_mul_mix` | PROVEN | `@0x114CA`: cross-mul mix for table fill (`0x1DF5E0D`). |
| `FUN_0001150a` | `overlay_rng_init` | PROVEN | `@0x1150A`: seed + fill 0x36 entries + cursor `0x260E4` + 10000× next. |
| `FUN_00011544` | `overlay_rng_warmup_epilogue` (bytes) | PROVEN bytes | `@0x11544`: Ghidra-split init tail. **Call sites** treated as `overlay_rng_next` **[INFERRED]**. |
| `FUN_0000e4a4` | `compute_template_force_from_626` | PROVEN algo | `@0xE4A4`: template coeffs `+0x26..+0x34` × `movement_626` / `0x67b`; may set `field_19e=0xC`. |
| `FUN_000025a8` | `build_attitude_matrix` | PROVEN chain | `@0x25A8`: `0202a`→`020e6`→`021a0`→`02562` into out matrix. |
| `FUN_00002802` | `transform_int3_vecs_asr_by_1d744` | PROVEN | `@0x2802`: count× (ASR.L shift, ×`DAT_0001d744` 3×3, +0x800>>12) int3→int3. |
| `FUN_000028a6` | `rotate_int3_vecs_by_3ang` | PROVEN chain | `@0x28A6`: `build_attitude_matrix_3ang` then `transform_int3_vecs_by_matrix3`. |
| `FUN_000028dc` | `transform_vecs12_by_matrix3` | PROVEN | `@0x28DC`: count× transform shorts at +2/+6/+10 by 3×3 (`+0x800>>12`). |
| `FUN_00002976` | `transform_vecs12_to_int3_by_matrix3` | PROVEN | `@0x2976`: same as `028dc` but MOVE.L int3 outs (`+0x800>>12`). |
| `FUN_00002a0e` | `transform_listed_object_vecs12_by_1d744` | PROVEN | `@0x2A0E`: walk `1c9dc` objs; ASR `+0x32`; ×`1d744`; store vecs12 at `+0x4c`. |
| `FUN_00002aba` | *(false mid-`transform_listed_object_vecs12_by_1d744`)* | BLOCKED | `@0x2ABA` = `move.w d0,$a(a1)` inside @0x2A0E loop. |
| `FUN_0000e42a` | `table_lerp_1b2c0` | PROVEN algo | `@0xE42A`: banded lerp on `DAT_0001b2c0`; input typically `*(world+0x1c)`. |
| `FUN_0000e468` | `damp_short_if_below_0x200` | PROVEN | `@0xE468`: if delta&lt;`0x200`, subtract `((0x200−delta)*v)>>12` from short. |
| `FUN_0000e570` | `scale_template_field_38` | PROVEN | `@0xE570`: `*out = template[+0x38] * (0x551a/((in+0x105)>>3)) >> 8`. |

## Globals / data

| Original symbol | Recovered name | Confidence | Evidence |
|---|---|---|---|
| `DAT_0001a7d2` | `template_rec_a_field_u16` | STRONG INFERENCE | Absolute u16; written only via `FUN_00000020`; file offset `0x1a7d2`; `+0x0C` in a `0x4A` record near `s_GRAPHIC_SIMULATIONS_...` (`0x1a77c`). Initial image value `0x0151`. |
| `DAT_0001a81c` | `template_rec_b_field_u16` | STRONG INFERENCE | `DAT_0001a7d2 + 0x4A`; same store instruction `MOVE.W D0,$4A(A0)`. Initial image value `0x0151`. |
| `DAT_0001b524` | `template_ptr_table_base` | STRONG INFERENCE | `LEA $1B524,A5` in `FUN_00000054`; indexed by sign-extended u16 record keys (`MOVEA.W (A2),A0` then `(A5,A0.L*4)`). Sparse ID-keyed pointer table. |
| `FUN_000019d0` | `heap_free_coalesce` | STRONG INFERENCE | Binary `@0x19D0`–`0x1A66`: free payload to size-class list or coalesce into large-block ring; cursor `DAT_00020c60`. |
| `FUN_00001a48` | `heap_free_epilogue_cursor` | PROVEN | Mid-label `@0x1A48` of `FUN_000019d0`: `MOVE.L A1,$20C60`; `BRA $1A64`; pop A2; `RTS`. **Not** an allocator. Kind2 `@0x4ED8` + `@0xB572` still `LEA $1A48`+`JSR` then take D0 — **[INFERRED]** LEA off-by `+0x20` vs `heap_alloc`. |
| `FUN_00001a68` | `heap_alloc` | PROVEN prologue | `@0x1A68`: `MOVEM D2-D3/A2`; size `$10(a7)`; bins/`01974`/`0199a`; D0=payload. Godot stand-in for kind2/B572 call sites. |
| `DAT_00020c60` | `heap_roving_cursor` | STRONG INFERENCE | Large-block freelist cursor; written at `@0x1A48` / read throughout alloc/free. |
| `DAT_00020c64` | `heap_size_class_bins` | STRONG INFERENCE | Array of freelist heads indexed by size class (×4). |

## Rejected / superseded interpretations

| Claim | Status | Reason |
|---|---|---|
| `FUN_00000020` sets overlay load base/handle into `DAT_0001a7d2` / `DAT_0001a81c` | SUPERSEDED | Argument and cells are 16-bit; in-overlay callers pass small immediates `0x195`/`0x1d5`, not a pointer/base. |

## Notes on Ghidra artifacts

| Location | Artifact | Correction in `.decomp.c` |
|---|---|---|
| `FUN_00000054` copy length | `pcVar5 = FUN_00000020` | Replaced with `(code *)0x20` — function address equals byte count 32. |
