# Hellcats Over the Pacific — C-to-C Decompilation Progress

Persistent checkpoint for the recurring 5-minute semantic reconstruction loop.

**Last iteration:** 287
**Last iteration date:** 2026-10-17
**Loop:** session-only CronCreate job `f156ee33` (`*/5 * * * *`) activated 2026-10-16 in a Claude Code desktop session; it ends when that session closes and auto-expires after 7 days. Otherwise resume manually using the instructions below.

## Inventory summary

| Source file | Functions inventoried | NOT_STARTED | INVESTIGATING | ANNOTATED | RENAMED | VERIFIED | BLOCKED |
|---|---:|---:|---:|---:|---:|---:|---:|
| ID01.c | 6 | 0 | 0 | 0 | 6 | 0 | 0 |
| ID02.c | 125 | 0 | 0 | 0 | 125 | 0 | 0 |
| ID03.c | 45 | 0 | 0 | 0 | 45 | 0 | 0 |
| ID04.c | 59 | 0 | 0 | 0 | 59 | 0 | 0 |
| ID05.c | 24 | 0 | 0 | 0 | 24 | 0 | 0 |
| ID06.c | 24 | 0 | 0 | 0 | 24 | 0 | 0 |
| ID07.c | 2 | 0 | 0 | 0 | 2 | 0 | 0 |
| ID08.c | 4 | 0 | 0 | 0 | 4 | 0 | 0 |
| ID09.c | 4 | 0 | 0 | 0 | 4 | 0 | 0 |
| Pacific Conflict.c | 443 | 128 | 0 | 0 | 309 | 0 | 6 |
| **TOTAL** | **736** | **128** | **0** | **0** | **602** | **0** | **6** |

Inventory correction (iteration 100): five multiline definitions were previously
omitted: ID02 `FUN_00003d50` (:2126), `FUN_00003f54` (:2231),
`FUN_00004050` (:2266); Pacific Conflict `FUN_0000e262` (:13673),
`FUN_00010360` (:15361). Totals count exclusive processing statuses; renamed
functions with annotations remain RENAMED. The two blocked labels `$E352` and
`$1A186` remain documented below but are not function definitions and do not
contribute to function totals. Remaining work: 128 NOT_STARTED + 6 BLOCKED (iteration 287);
602 RENAMED still require independent verification before VERIFIED status.

Full machine-readable inventory: [`DECOMPILATION_INVENTORY.json`](DECOMPILATION_INVENTORY.json)  
Protected original checksums: [`DECOMPILATION_PROTECTED_CHECKSUMS.sha256`](DECOMPILATION_PROTECTED_CHECKSUMS.sha256)  
Symbol map: [`DECOMPILATION_SYMBOLS.md`](DECOMPILATION_SYMBOLS.md)

## Output files

| Immutable input | Editable output | Status |
|---|---|---|
| `ID01.c` | `ID01.decomp.c` | seeded (copy) |
| `ID02.c` | `ID02.decomp.c` | seeded + iter 111-112 (initialize_application, main, poll_and_dispatch_event, do_menu_command, apply_settings_to_live_options, handle_mouse_down, handle_activate_event, redraw_main_window, check_device_color_state_changed, build_palette_index_map, palette helpers) |
| `ID03.c` | `ID03.decomp.c` | seeded + iter 159 (scaling / colour helpers) |
| `ID04.c` | `ID04.decomp.c` | seeded + iter 172 (requirements check, temporary window) |
| `ID05.c` | `ID05.decomp.c` | seeded + iter 118 (all 24 functions renamed, iterations 118-125) |
| `ID06.c` | `ID06.decomp.c` | seeded + iter 153-158 (all 24 functions renamed) |
| `ID07.c` | `ID07.decomp.c` | seeded + iter 109-110 (both functions renamed) |
| `ID08.c` | `ID08.decomp.c` | seeded + iter 68–71 edits (all 4 FUN renamed) |
| `ID09.c` | `ID09.decomp.c` | preserved + iterations 100-104 helper and initializer annotations |
| `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | seeded + iter 1–99 edits |

## Function tracker (processed / in focus)

| Original | Proposed name | File | Status | Confidence | Orig loc | Decomp loc | Dependencies | Unresolved | Last iter | Validation |
|---|---|---|---|---|---|---|---|---|---|---|
| `FUN_00000020` | `overlay_patch_template_u16_pair` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c:739` | `Pacific Conflict.decomp.c` (header + body) | `DAT_0001a7d2`, `DAT_0001a81c`; callers near mission setup using `DAT_0001b5a0+0xe` | Exact meaning of patched u16; whether external loader also JSRs here | 1 | Protected checksums OK; binary @0x20 matches dual MOVE.W; call sites updated; Ghidra 0x20 length artifact clarified |
| `FUN_00000032` | `copy_block_return_dst` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c:749` | `Pacific Conflict.decomp.c` | `FUN_0001a63e`; heavy use from `FUN_00000054` | Full `FUN_0001a63e` semantics | 2 | Binary @0x32: arg reorder + return dst; 23 call sites renamed; protected checksums OK |
| `FUN_00000054` | `overlay_init_template_pointer_tables` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c:758` | `Pacific Conflict.decomp.c` (Blocks A–D) | `copy_block_return_dst`, `heap_roving_cursor_store`, `DAT_0001b524`…`1b59c` | Record schemas; `$1A48` D0 ABI | 5 | Capstone @0x54–0x332; slot map proven; protected OK |
| `FUN_000019d0` | `heap_free_coalesce` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:2086` / `@0x19D0` | `Pacific Conflict.decomp.c` | `DAT_00020c60`, `DAT_00020c64` | — | 4 | Capstone 0x19D0–0x1A66 |
| `FUN_00001a48` | `heap_roving_cursor_store` | Pacific Conflict | BLOCKED | PROVEN body / BLOCKED ABI | `:2128` / `@0x1A48` | `Pacific Conflict.decomp.c` | mid-label of `FUN_000019d0` | Call sites expect malloc(D0); bytes only store A1→cursor | 4 | Body proven; allocator ABI unresolved |
| `FUN_00001a68` | `heap_alloc` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:2139` / `@0x1A68` | `Pacific Conflict.decomp.c` | freelists `DAT_00020c64`, cursor `DAT_00020c60` | — | 4 | Capstone size-class + large-block paths |
| `FUN_000016e2` | `init_mission_object_tables` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:1917` / `@0x16E2` | `Pacific Conflict.decomp.c` | templates, `instantiate_object_from_desc`, `heap_alloc` | Child schemas; setup hooks | 6 | Capstone BSR.L chain |
| `FUN_00004690` | `instantiate_object_from_desc` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:5195` / `@0x4690` | `Pacific Conflict.decomp.c` | `alloc_object_from_desc`, `DAT_0001b524[type]+6` factory | Factory payload schema | 7 | Capstone; ties to template table |
| `FUN_000045ba` | `alloc_object_from_desc` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:5149` / `@0x45BA` | `Pacific Conflict.decomp.c` | `heap_alloc_cleared`; kinds 2/3 | Other kind tags; field meanings | 7 | Capstone kind switch |
| `FUN_00001b6c` | `heap_alloc_cleared` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x1B6C` | `Pacific Conflict.decomp.c` | `heap_alloc` + `heap_zero_payload` | — | 7–8 | Clear path proven |
| `FUN_00001b38` | `heap_zero_payload` | Pacific Conflict | RENAMED | PROVEN | `:2197` / `@0x1B38` | `Pacific Conflict.decomp.c` | heap headers; `memzero` | — | 8 | Header size rules + CLR fill |
| `FUN_0001a716` | `memzero` | Pacific Conflict | RENAMED | PROVEN | `@0x1A716` | `Pacific Conflict.decomp.c` | CLR.B/CLR.L loops | — | 8 | Capstone fill loops |
| `FUN_000044e8` | `run_simulation_tick` | Pacific Conflict | RENAMED | PROVEN structure | `:5096` / `@0x44E8` | `Pacific Conflict.decomp.c` | `dispatch_entity_tick`, `05df8`, `06fb8` | Array semantics; external caller | 9 | Capstone four-pass order |
| `FUN_000044a4` | `dispatch_entity_tick` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:5079` / `@0x44A4` | `Pacific Conflict.decomp.c` | `apply_entity_mission_rates`; flag `0x40` vs `+0xb0` | Linked type-5 object meaning | 10 | Capstone BSR+flag OR/AND |
| `FUN_0000435a` | `apply_entity_mission_rates` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:5008` / `@0x435A` | `Pacific Conflict.decomp.c` | mission tables; path gate for kind-2 | Field `+0xC` / `+0x48` semantics | 10 | Capstone; path==0 subloop |
| `FUN_00005df8` | `clear_pending_entity_slots` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:6434` / `@0x5DF8` | `Pacific Conflict.decomp.c` | `DAT_0001bc64[7]`, `dispatch_entity_cleanup` | Slot queue semantics | 11–21 | Capstone 7-slot clear |
| `FUN_0000528a` | `dispatch_entity_cleanup` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x528A` | `Pacific Conflict.decomp.c` | `retire_entity`; type-2 soft path | — | 21 | NOTES branches; all call sites |
| `FUN_000051ec` | `retire_entity` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x51EC` | `Pacific Conflict.decomp.c` | `DAT_0001bc64`, `DAT_0001b880`, table poke | Mac heap vs flat mem | 21 | NOTES stores; call sites |
| `FUN_00005116` | `spawn_mission_pool_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x5116` | `Pacific Conflict.decomp.c` | `DAT_0001d6fc+0x30`; `instantiate_mission_pool_slot`; `retire_entity` gate | — | 22–28 | NOTES free-slot; call sites |
| `FUN_000046da` | `instantiate_mission_pool_slot` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x46DA` | `Pacific Conflict.decomp.c` | `alloc_object_from_desc`; factory; `04e6e` gate | `02bd8`/`03b98`/`04e6e` bodies | 28 | NOTES identity+gate; 2 call sites |
| `FUN_00002e08` | `abs_int` | Pacific Conflict | RENAMED | PROVEN | `:3461` / `@0x2E08` | `Pacific Conflict.decomp.c` | — | INT_MIN negate; vs `FUN_00002de8` | 29 | Body + 48 call sites |
| `FUN_00002de8` | *(false entry)* / callsite→`abs_int` | Pacific Conflict | BLOCKED | bytes PROVEN; callsite STRONG INFERENCE | `@0x2DE8` mid-`02d10` | `Pacific Conflict.decomp.c` | `FUN_00002d10` epilogue; `abs_int` @`0x2E08` | Why LEA targets `0x2DE8` not `0x2E08` | 30 | Capstone; 19 LEA sites; 0 BSR to 2DE8 |
| `FUN_00004e6e` | `activate_near_range_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x4E6E` | `Pacific Conflict.decomp.c` | `04808`, `02bd8`, `$1A48`×2→`+0x44/4c`, `03b98` | Full flag-branch callees; `$1A48` ABI | 31 | Capstone kind2 head; 5 call sites |
| `FUN_00004808` | `build_object_poly_buffers` | Pacific Conflict | RENAMED | PROVEN layout | `@0x4808` | `Pacific Conflict.decomp.c` | `heap_alloc`; stream→`+0x48` polys + `+0x18` indices | Flag nibble meanings; multi-poly consumers | 32 | Capstone size/record/index; 1 call site |
| `FUN_00002bd8` | `apply_template_chain_xform` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x2BD8` | `Pacific Conflict.decomp.c` | `0253e`/`02ada`/`01c5c`; chain `+0x24` | Exact rotate/translate math | 33 | Capstone walk+commit; 9 call sites |
| `FUN_00002d10` | `apply_template_chain_xform_always` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x2D10` | `Pacific Conflict.decomp.c` | same helpers; epilogue=`02de8` false entry | Same unknowns as 02bd8 | 34 | Capstone always-0253e; 1 call site |
| `FUN_0000253e` | `build_attitude_matrix_3ang` | Pacific Conflict | RENAMED | PROVEN chain | `@0x253E` | `Pacific Conflict.decomp.c` | `0202a(…,0)`→`024f8` | Axis meaning of 3 args | 35 | Capstone body; 15 call sites |
| `FUN_000024f8` | `finalize_attitude_matrix_3ang` | Pacific Conflict | RENAMED | PROVEN chain | `@0x24F8` | `Pacific Conflict.decomp.c` | `020e6`; `01d02`×2; tag `0x2408` | Exact basis table roles | 36 | Capstone; sole caller 0253e |
| `FUN_00002ada` | `transform_int3_vecs_by_matrix3` | Pacific Conflict | RENAMED | PROVEN | `@0x2ADA` | `Pacific Conflict.decomp.c` | 3×3 s16→int; count×int3; `>>12` | Row vs column convention | 37 | Capstone MULS path; 6 call sites |
| `FUN_00001c5c` | `translate_int3_vecs` | Pacific Conflict | RENAMED | PROVEN | `@0x1C5C` | `Pacific Conflict.decomp.c` | count× `(x+dx,y+dy,z+dz)` | — | 38 | Capstone ADD loop; 8 call sites |
| `FUN_00001cac` | `scale_int3_vecs` | Pacific Conflict | RENAMED | PROVEN body | `@0x1CAC` | `Pacific Conflict.decomp.c` | count× `(x*sx,y*sy,z*sz)` | No overlay call sites found | 39 | Capstone MULS; 0 refs |
| `FUN_0000202a` | `load_attitude_angle_sincos` | Pacific Conflict | RENAMED | PROVEN | `@0x202A` | `Pacific Conflict.decomp.c` | `01dd8`/`01d76` ×4 → `1d7ee…1d7fc` | Axis→slot mapping labels | 40 | Capstone; 8 call sites |
| `FUN_00001d76` | `sin_fixed14` | Pacific Conflict | RENAMED | PROVEN | `@0x1D76` | `Pacific Conflict.decomp.c` | table `DAT_0001ab6c`; `>>6` lerp | Usable base +0x20 | 41 | Capstone; 29 call sites |
| `FUN_00001dd8` | `cos_fixed14` | Pacific Conflict | RENAMED | PROVEN | `@0x1DD8` | `Pacific Conflict.decomp.c` | table `DAT_0001ad6c`; twin of sin | Usable base +0x20 | 41 | Capstone; 28 call sites |
| `FUN_00001d56` | *(false)* / callsite→`sin_fixed14` | Pacific Conflict | BLOCKED | bytes PROVEN; callsite STRONG INFERENCE | `@0x1D56` mid-`01d02` | `Pacific Conflict.decomp.c` | — | LEA `$1D56` vs `$1D76` | 41 | NOTES; +0x20 pattern |
| `FUN_00001db8` | *(false)* / callsite→`cos_fixed14` | Pacific Conflict | BLOCKED | bytes PROVEN; callsite STRONG INFERENCE | `@0x1DB8` mid-sin | `Pacific Conflict.decomp.c` | — | LEA `$1DB8` vs `$1DD8` | 41 | Capstone mid-sin |
| `FUN_00001d02` | `matmul3x3_s16` | Pacific Conflict | RENAMED | PROVEN | `@0x1D02` | `Pacific Conflict.decomp.c` | 3×3 s16 `>>12` | Row/col convention | 42 | Capstone; 26 call sites |
| `FUN_000020e6` | `fill_attitude_rotation_bases` | Pacific Conflict | RENAMED | PROVEN layout | `@0x20E6` | `Pacific Conflict.decomp.c` | sincos→`1d7d4`/`1d7bc`/`1d7a4` | Exact axis→angle mapping | 43 | Capstone; 7 call sites |
| `FUN_000021a0` | `fill_attitude_rotation_basis_4` | Pacific Conflict | RENAMED | PROVEN layout | `@0x21A0` | `Pacific Conflict.decomp.c` | angle4→`DAT_0001d78c` (~Ry) | Sibling `021e0` ~Rx form | 44 | Capstone; 1 call site |
| `FUN_00002562` | `finalize_attitude_matrix_4ang` | Pacific Conflict | RENAMED | PROVEN | `@0x2562` | `Pacific Conflict.decomp.c` | `matmul3x3_s16` ×3: R4×Rz×Rx×Ry | Exact multiply association | 45 | Capstone; 1 call site |
| `FUN_000021e0` | `fill_attitude_rotation_basis_4_rx` | Pacific Conflict | RENAMED | PROVEN layout | `@0x21E0` | `Pacific Conflict.decomp.c` | angle4→`DAT_0001d78c` (~Rx) | Twin of `_basis_4` (~Ry) | 46 | Capstone; 4 call sites |
| `FUN_000025d6` | `compose_attitude_matrix_x` | Pacific Conflict | RENAMED | PROVEN | `@0x25D6` | `Pacific Conflict.decomp.c` | bases+Rx+3×matmul; tag `0x2468` | — | 47 | Capstone; 1 call site |
| `FUN_00003b98` | `update_object_camera_metric` | Pacific Conflict | RENAMED | PROVEN | `@0x3B98` | `Pacific Conflict.decomp.c` | abs(pos−cam); max+((a+b)>>2)→`+0x10` | Ghidra void vs D0 | 48 | Capstone; 11 call sites |
| `FUN_00003c00` | `compute_camera_abs_metric` | Pacific Conflict | RENAMED | PROVEN | `@0x3C00` | `Pacific Conflict.decomp.c` | abs(x/y/z−cam); same max+ASR#2; return D0 | Ghidra lost 3 args | 49 | Capstone; 11 call sites |
| `FUN_00003be0` | *(false mid-`update_object_camera_metric`)* | Pacific Conflict | BLOCKED | PROVEN bytes | `@0x3BE0` mid-`03b98` | `Pacific Conflict.decomp.c` | axis-swap mid-body | Call-site ABI | 49 | Capstone; 2 call sites deferred |
| `FUN_00002428` | `finalize_attitude_matrix_3ang_alt` | Pacific Conflict | RENAMED | PROVEN | `@0x2428` | `Pacific Conflict.decomp.c` | `020e6`+2×`01d02` alt order; no `$2408` | Axis meaning of alt | 50 | Capstone; 1 call site |
| `FUN_00002464` | `build_attitude_matrix_3ang_alt` | Pacific Conflict | RENAMED | PROVEN | `@0x2464` | `Pacific Conflict.decomp.c` | `0202a`→`finalize_…_3ang_alt` | Why alt vs tagged | 51 | Capstone; 2 call sites |
| `FUN_00002488` | `compose_attitude_matrix_x_alt` | Pacific Conflict | RENAMED | PROVEN | `@0x2488` | `Pacific Conflict.decomp.c` | bases+Rx+3×matmul alt; no `$2468` | Equiv vs tagged X | 52 | Capstone; 1 call site |
| `FUN_000024d6` | `build_attitude_matrix_x_alt` | Pacific Conflict | RENAMED | PROVEN | `@0x24D6` | `Pacific Conflict.decomp.c` | `0202a`→`compose_…_x_alt` | Why alt vs tagged X | 53 | Capstone; 2 call sites |
| `FUN_00002654` | `compose_attitude_matrix_6ang` | Pacific Conflict | RENAMED | PROVEN | `@0x2654` | `Pacific Conflict.decomp.c` | tag `$26e0`; bases+Rx+02220+5×matmul | 02220/020a0 names; tag dispatch | 54 | Capstone; 1 call site |
| `FUN_00002220` | `fill_attitude_rotation_bases_5_6` | Pacific Conflict | RENAMED | PROVEN | `@0x2220` | `Pacific Conflict.decomp.c` | `1d774`≈Rx ang5; `1d75c`≈Ry ang6 | Exact axis labels | 55 | Capstone; 2 call sites |
| `FUN_000020a0` | `load_attitude_angle_sincos_5_6` | Pacific Conflict | RENAMED | PROVEN | `@0x20A0` | `Pacific Conflict.decomp.c` | ang5→`1d7ea/ec`; ang6→`1d7e6/e8` | — | 56 | Capstone; 2 call sites |
| `FUN_000026cc` | `build_attitude_matrix_6ang` | Pacific Conflict | RENAMED | PROVEN | `@0x26CC` | `Pacific Conflict.decomp.c` | `0202a`+`020a0`→`compose_…_6ang` | — | 57 | Capstone; 1 call site |
| `FUN_00002700` | `compose_attitude_matrix_6ang_alt` | Pacific Conflict | RENAMED | PROVEN | `@0x2700` | `Pacific Conflict.decomp.c` | bases+Rx+5_6+5×matmul alt; no `$26e0` | Equiv vs tagged | 58 | Capstone; 1 call site |
| `FUN_0000276e` | `build_attitude_matrix_6ang_alt` | Pacific Conflict | RENAMED | PROVEN | `@0x276E` | `Pacific Conflict.decomp.c` | `0202a`+`020a0`→`compose_…_6ang_alt` | — | 59 | Capstone; 1 call site |
| `FUN_000027a2` | `invoke_tagged_attitude_compose_neg_sins4` | Pacific Conflict | RENAMED | PROVEN | `@0x27A2` | `Pacific Conflict.decomp.c` | neg 4 sins; JSR `DAT_00020ce4` | `$2408`≡`$2428−0x20`; A890 A6≠0229e | 60/73 | Capstone; 1 call site |
| `FUN_000027cc` | `invoke_tagged_attitude_compose_neg_sins6` | Pacific Conflict | RENAMED | PROVEN | `@0x27CC` | `Pacific Conflict.decomp.c` | neg 6 sins; JSR `DAT_00020ce4` | same; see NOTES tag map | 61/62 | Capstone; 1 call site |
| `FUN_0000229e` | `build_attitude_matrix_from_dir_roll` | Pacific Conflict | RENAMED | PROVEN math | `@0x229E` | `Pacific Conflict.decomp.c` | dir+roll→sincos slots→2×matmul; hosts `$2408` | No overlay callers; `$2408` contract | 63 | Capstone; 0 BSR |
| `FUN_00002802` | `transform_int3_vecs_asr_by_1d744` | Pacific Conflict | RENAMED | PROVEN | `@0x2802` | `Pacific Conflict.decomp.c` | ASR then ×`1d744` +0x800>>12 | Row vs col convention | 64 | Capstone; 1 call site |
| `FUN_000028a6` | `rotate_int3_vecs_by_3ang` | Pacific Conflict | RENAMED | PROVEN | `@0x28A6` | `Pacific Conflict.decomp.c` | `0253e`→`02ada` | No overlay callers | 65 | Capstone; 0 BSR |
| `FUN_00002976` | `transform_vecs12_to_int3_by_matrix3` | Pacific Conflict | RENAMED | PROVEN | `@0x2976` | `Pacific Conflict.decomp.c` | vecs12 in → int3 out; +0x800>>12 | — | 66 | Capstone; 4 call sites |
| `FUN_00002a0e` | `transform_listed_object_vecs12_by_1d744` | Pacific Conflict | RENAMED | PROVEN | `@0x2A0E` | `Pacific Conflict.decomp.c` | obj list ×`1d744`→vecs12 | No overlay callers | 67 | Capstone; 0 BSR |
| `FUN_00002aba` | *(false mid-`transform_listed_object_vecs12_by_1d744`)* | Pacific Conflict | BLOCKED | PROVEN bytes | `@0x2ABA` mid-`02a0e` | `Pacific Conflict.decomp.c` | store `$a(a1)` | — | 67 | Capstone |
| `$E352` / `LAB_0000e350_2` | *(false)* / callsite→`isqrt_floor` | Pacific Conflict | BLOCKED | PROVEN bytes; callsite STRONG INFERENCE | `@0xE352` = `$E372−0x20` | `Pacific Conflict.decomp.c` (isqrt header) | mid-BSR disp / FRESTORE garbage | Why LEA −0x20 | 72 | Capstone; LEA @0x22CC; table @0x11C4 |
| `FUN_0000e3b2` | `acos_scaled_dot3` | Pacific Conflict | RENAMED | PROVEN | `@0xE3B2` | `Pacific Conflict.decomp.c` | `(dot3>>4)/((a*b)>>16)` → `acos_fixed14` | callers | 74 | Capstone; 0 BSR |
| `FUN_00001e3a` | `acos_fixed14` | Pacific Conflict | RENAMED | PROVEN | `@0x1E3A` | `Pacific Conflict.decomp.c` | inverse cos table `1ad6c` | — | 75 | Capstone; 3 call sites |
| `FUN_00001ebc` | `atan_fixed14` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x1EBC` | `Pacific Conflict.decomp.c` | table `1af6c` longs; mid-biased | table scale | 76 | Capstone; 4 BSR |
| `FUN_000102d6` | `atan2_fixed14` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x102D6` | `Pacific Conflict.decomp.c` | abs+atan_fixed14 + quadrants | axis meaning of args | 77 | Capstone; 1 BSR |
| `FUN_000109ba` | `apply_relative_heading_steer` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x109BA` | `Pacific Conflict.decomp.c` | atan2+fold → +0x61e; avg4 | 61a/c/e | 78 | Capstone; 2 callers |
| `FUN_00010558` | `enqueue_control_inputs_avg4` | Pacific Conflict | RENAMED | PROVEN | `@0x10558` | `Pacific Conflict.decomp.c` | 4-ring → +0x662/4/6 | channel axis names | 79 | Capstone; 4 BSR |
| `FUN_00010b2e` | `steer_entity_toward_point` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10B2E` | `Pacific Conflict.decomp.c` | sample+steer wrapper | — | 80 | Capstone; 10 callers |
| `FUN_00010360` | `build_relative_steer_sample` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10360` | `Pacific Conflict.decomp.c` | Δxyz→body; attitude cmds | Y-bump | 81 | Capstone; 2 BSR |
| `FUN_00010cb2` | `max_ai_throttle_maybe_invert_679` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10CB2` | `Pacific Conflict.decomp.c` | +0x668=9; maybe neg +0x679 | +0x679 meaning | 82 | Capstone; 5 BSR |
| `FUN_00010c2c` | `adjust_ai_throttle_vs_speed` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10C2C` | `Pacific Conflict.decomp.c` | target vs +0x62a → +0x668 | +0x62a unit | 83 | Capstone; 6 BSR |
| `FUN_00010cd8` | `invert_ai_bias_67b_if_positive` | Pacific Conflict | RENAMED | PROVEN | `@0x10CD8` | `Pacific Conflict.decomp.c` | neg +0x67b if >0 | — | 84 | Capstone; 3 BSR |
| `FUN_00010b84` | `ai_bootstrap_climb_phase` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10B84` | `Pacific Conflict.decomp.c` | pitch→2c0; ret alt>2000 | script context | 85 | Capstone; 2 BSR |
| `FUN_00010ce8` | `tick_ai_climb_then_waypoint` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10CE8` | `Pacific Conflict.decomp.c` | script +0x616; climb→steer | `16966` | 86 | Capstone; 3 BSR |
| `FUN_00010d68` | `ensure_ai_script_1b2e0_tick` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10D68` | `Pacific Conflict.decomp.c` | table 1b2e0; spd 0x9d8 | table contents | 87 | Capstone |
| `FUN_00010da8` | `ensure_ai_script_1b310_tick` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10DA8` | `Pacific Conflict.decomp.c` | table 1b310; spd 0xd5c | table contents | 87 | Capstone; 1 BSR |
| `FUN_00010de8` | `ensure_ai_script_1b340_tick` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10DE8` | `Pacific Conflict.decomp.c` | table 1b340; spd 0x9d8 | table contents | 87 | Capstone |
| `FUN_00010e28` | `ai_script_try_fire_burst` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10E28` | `Pacific Conflict.decomp.c` | timegate+RNG fire; ret ammo0 | +0x67c meaning | 88 | Capstone; 2 BSR |
| `FUN_00010ecc` | `tick_ai_1b310_approach_fire` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10ECC` | `Pacific Conflict.decomp.c` | 1b310 tick; 1→2→3 fire | `03c68` | 89 | Capstone; 0 BSR |
| `FUN_00010f68` | `tick_ai_1b370_mission` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x10F68` | `Pacific Conflict.decomp.c` | 1b370 multi-phase mission | landing helper | 90 | Capstone; 0 BSR |
| `FUN_00019fba` | `try_begin_landing_approach` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x19FBA` | `Pacific Conflict.decomp.c` | setup 267xx glide; +0x32→1a186 | handler | 91 | Capstone; 2 BSR |
| `FUN_00019c5e` | `find_nearest_runway_approach_ends` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x19C5E` | `Pacific Conflict.decomp.c` | nearest 'p'/4 pad ends | pad schema | 92 | Capstone; 1 BSR |
| `FUN_00019c26` | `store_xyz_asr` | Pacific Conflict | RENAMED | PROVEN | `@0x19C26` | `Pacific Conflict.decomp.c` | A1←(x,y,z)>>s | — | 93 | Capstone; 4 BSR |
| `FUN_0001a1a6` | `tick_landing_approach_glide` | Pacific Conflict | RENAMED / ANNOTATED | STRONG INFERENCE | `@0x1A1A6` | `Pacific Conflict.decomp.c` | glide phases annotated | abort band | 95+98 | Capstone |
| `FUN_00000354` | `probe_nearest_facility_kind` | Pacific Conflict | RENAMED | PROVEN | `@0x0354` | `Pacific Conflict.decomp.c` | 0x12→0x100, 0x13→0x200 | Ghidra void ABI | 97 | Capstone; 12 BSR |
| `FUN_00003c48` | `approx_dist3_from_abs` | Pacific Conflict | RENAMED | PROVEN | `@0x3C48` | `Pacific Conflict.decomp.c` | max+(a+b)>>2 on regs | — | 99 | Capstone |
| `FUN_00003c68` | `approx_dist3_xyz` | Pacific Conflict | RENAMED | PROVEN | `@0x3C68` | `Pacific Conflict.decomp.c` | 6-arg XYZ approx dist | — | 99 | Capstone; 31 BSR |
| `$1A186` | *(false mid of landing tick)* | Pacific Conflict | BLOCKED | PROVEN | `1A1A6−0x20` | — | installed by `19fba` | real=`1A1A6` | 95 | +0x20 family |
| `FUN_00012840` | `spawn_weapon_entity` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x12840` | `Pacific Conflict.decomp.c` | `DAT_00026280` → pool; entity `+0x610/61c/20..24` | Exact munition class | 22 | NOTES post-spawn; 3 call sites |
| `FUN_00015d20` | `spawn_ordnance_oriented` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x15D20` | `Pacific Conflict.decomp.c` | `build_attitude_matrix_x` → `spawn_ordnance_scattered` | — | 23 | NOTES; e792 field_676 |
| `FUN_00015bf6` | `spawn_ordnance_scattered` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x15BF6` | `Pacific Conflict.decomp.c` | `DAT_0002664a`; RNG scatter; `1a63e` | `1a63e` body | 23 | NOTES spawn fields |
| `FUN_0000262e` | `build_attitude_matrix_x` | Pacific Conflict | RENAMED | PROVEN chain | `@0x262E` | `Pacific Conflict.decomp.c` | `0202a`→`025d6` (X-axis) | — | 23 | Sibling of `025a8` |
| `FUN_00019430` | `spawn_special_weapon_entity` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x19430` | `Pacific Conflict.decomp.c` | `DAT_00026780`; vertex `>>3`×0x1c6/0x255 | Exact munition class | 24 | NOTES spawn+vertex; 1 call site |
| `FUN_0000e40c` | `fold_angle_pm_0x2000` | Pacific Conflict | RENAMED | PROVEN | `@0xE40C` | `Pacific Conflict.decomp.c` | — | — | 25 | Body + all call sites |
| `FUN_0001a63e` | `memmove_block` | Pacific Conflict | RENAMED | PROVEN | `@0x1A63E` | `Pacific Conflict.decomp.c` | (src,dst,n); overlap fwd/back | Exact return-reg meaning | 26 | Body annotated; call sites |
| `FUN_00001ba8` | `heap_realloc_grow_only` | Pacific Conflict | RENAMED | PROVEN | `@0x1BA8` | `Pacific Conflict.decomp.c` | header capacity; `heap_calloc`+`memmove_block` | — | 27 | NOTES; pool grow path |
| `FUN_00001b84` | `heap_calloc` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x1B84` | `Pacific Conflict.decomp.c` | `heap_alloc(a*b)` + zero | — | 27 | Body |
| `FUN_00006fb8` | `reset_distance_base_globals` | Pacific Conflict | RENAMED | STRONG INFERENCE | `:7180` / `@0x6FB8` | `Pacific Conflict.decomp.c` | six `DAT_0001d710`…`1d724` | Exact distance semantics | 11 | Capstone six MOVE.L #$5F5E100 |
| `FUN_0000e792` | `update_aircraft_entity` | Pacific Conflict | RENAMED / ANNOTATED (Blocks 0–7c) | STRONG INFERENCE | `:14018` / `@0xE792` | `Pacific Conflict.decomp.c` end | weapons; control avg4→662/666 | Spawn/pool; VERIFIED pending | 19–20,94 | Block1 cross-link avg4 iter 94 |
| `FUN_00011564` | `overlay_rng_next` | Pacific Conflict | RENAMED | PROVEN | `@0x11564` | `Pacific Conflict.decomp.c` | `DAT_00026008` table | — | 20 | Body + all call sites |
| `FUN_00011544` | `overlay_rng_warmup_epilogue` (bytes) / callsite→`overlay_rng_next` | Pacific Conflict | RENAMED / ANNOTATED | PROVEN bytes; INFERRED callsite | `@0x11544` | `Pacific Conflict.decomp.c` | split from `1150a` tail | Exact binary JSR semantics | 20 | Call sites rewritten to next |
| `FUN_0001150a` | `overlay_rng_init` | Pacific Conflict | RENAMED | PROVEN | `@0x1150A` | `Pacific Conflict.decomp.c` | `mul_mix` + 10k warmup | table[0] pre-init | 20 | Body + 1 call site |
| `FUN_000114ca` | `overlay_rng_mul_mix` | Pacific Conflict | RENAMED | PROVEN | `@0x114CA` | `Pacific Conflict.decomp.c` | — | — | 20 | Body |
| `FUN_0000e372` | `isqrt_floor` | Pacific Conflict | RENAMED | PROVEN | `@0xE372` | `Pacific Conflict.decomp.c` | binary-search floor sqrt | — | 18 | Body + all call sites |
| `FUN_00001f22` | `attitude_from_velocity` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x1F22` | `Pacific Conflict.decomp.c` | `01ebc`/`01e3a`/`02de8`; writes two 14-bit angles | Exact axis mapping | 18 | Body + all call sites |
| `FUN_000025a8` | `build_attitude_matrix` | Pacific Conflict | RENAMED | PROVEN chain | `@0x25A8` | `Pacific Conflict.decomp.c` | `0202a`→`020e6`→`021a0`→`02562` | Axis order semantics | 17 | Body + call sites renamed |
| `FUN_000028dc` | `transform_vecs12_by_matrix3` | Pacific Conflict | RENAMED | PROVEN | `@0x28DC` | `Pacific Conflict.decomp.c` | 3×3 × packed +2/+6/+10 | — | 17 | Body; all overlay call sites |
| `FUN_0000e4a4` | `compute_template_force_from_626` | Pacific Conflict | RENAMED | PROVEN algo | `@0xE4A4` | `Pacific Conflict.decomp.c` | template `+0x26..+0x34`; `0x67b`; out→`0x63a` | Physical “lift” label | 16 | Body + single call site |
| `FUN_0000e42a` | `table_lerp_1b2c0` | Pacific Conflict | RENAMED | PROVEN algo | `@0xE42A` | `Pacific Conflict.decomp.c` | `DAT_0001b2c0` band table | Physical meaning of `*(world+0x1c)` bands | 14 | Capstone-equivalent body; 2 call sites |
| `FUN_0000e468` | `damp_short_if_below_0x200` | Pacific Conflict | RENAMED | PROVEN | `@0xE468` | `Pacific Conflict.decomp.c` | height delta vs `0x200` | — | 14 | Body + e792 use (drag stash) |
| `FUN_0000e570` | `scale_template_field_38` | Pacific Conflict | RENAMED | PROVEN | `@0xE570` | `Pacific Conflict.decomp.c` | `DAT_00026004+0x38` | — | 14 | Body; e570 uses raw e42a |

| `FUN_00000006` | `load_overlay_from_resource` | ID08 | RENAMED | STRONG INFERENCE | `ID08.c:11` / `@0x6` | `ID08.decomp.c` | A5 `$2a2/$2b2/$2aa`…; ret 0/1 | Exact resource ID; trap names | 68 | Capstone ID08.bin; LOADER_CHAIN |
| `FUN_00000348` | `alloc_and_read_resource_payload` | ID08 | RENAMED | PROVEN | `ID08.c:249` / `@0x348` | `ID08.decomp.c` | `$2ca/$2c2` size; `$22a` alloc; `$2b2` read | Exact trap names | 69 | Capstone; 1 call site |
| `FUN_00000338` | `sysbeep_and_exit_to_shell` | ID08 | RENAMED | PROVEN | `@0x338` | `ID08.decomp.c` | `_SysBeep(100)` + `_ExitToShell` | No callers in ID08 | 70 | Capstone traps |
| `FUN_0000039c` | `bootstrap_window_and_load_overlay` | ID08 | RENAMED | PROVEN call | `@0x39C` | `ID08.decomp.c` | window/port; `'HELL'`; JSR→`load_overlay…` | Trap names; HELL check | 71 | Capstone; completes ID08 |
| `FUN_00000432` | `length_prefixed_bytes_to_c_string_in_place` | ID09 | RENAMED | STRONG INFERENCE | `ID09.c:129-143` | `ID09.decomp.c` (Original: FUN_00000432 header) | Caller buffer only; no globals/callees; no direct callers found | Binary mapping, ABI, encoding and runtime callers | 100 (2026-10-16) | Full-file token equivalence; independent QA; strict C99 helper compile; 768 reference cases pass; protected hashes pass |

| `FUN_00000048` | `sysenvirons_glue_fallback` | ID09 | RENAMED | STRONG INFERENCE role / PROVEN C control flow + dispatcher and lookup bytes | `ID09.c:26-103` | `ID09.decomp.c` (Original header + all exported blocks) | Entry dispatcher file 0x20-0x46 (`$A346`/`$A746`/`$A090`); low-memory globals | Omitted +7 write; `$A260`/`$A207` trap ABI; 'ERIK' literal; machineType mapping HYPOTHESIS; validation vs Apple glue | 106 (2026-10-16) | Token diff = rename only; Capstone decode; 32 protected hashes unchanged |
| `FUN_000002a6` | `fsopen_glue` | ID09 | RENAMED | PROVEN bytes / STRONG INFERENCE role | `ID09.c:107-114` | `ID09.decomp.c` (header; body retained as halt_baddata) | `$A000` _Open; IOParam frame | Callers via jump table unknown; neighbouring unexported glue | 107 (2026-10-16) | Token diff = rename only; Capstone decode; 32 hashes OK |
| `FUN_000003c2` | `swapmmumode_glue` | ID09 | RENAMED | PROVEN bytes / STRONG INFERENCE role | `ID09.c:118-125` | `ID09.decomp.c` (header; body retained as halt_baddata) | `$A05D` _SwapMMUMode | Callers via jump table unknown | 108 (2026-10-16) | Token diff = rename only; Capstone decode; 32 hashes OK |
| `FUN_00000006` (ID07) | `load_str129_string_table` | ID07 | RENAMED | PROVEN bytes / STRONG INFERENCE role | `ID07.c:9-16` | `ID07.decomp.c` (header; body retained as halt_baddata; call site renamed) | `$A9A0` GetResource; JT `$272`→seg9 HLock, `$4fa`→ID02 `FUN_0000024a` memmove, `$3a`→ID01 switch helper @0xbe; writes A5−0xf46[1..120] | NULL handle / count bounds; ID01 switch helper not yet inventoried as function | 109 (2026-10-16) | Token diff = rename only; Capstone; CODE0 JT parse; 32 hashes OK |
| `FUN_00000190` (ID07) | `init_string_pointer_groups` | ID07 | RENAMED | PROVEN copy / STRONG INFERENCE role | `ID07.c:20-44` | `ID07.decomp.c` | `load_str129_string_table`; writes A5−0x221e/−0xffe/−0xfae/−0xf86; caller ID02 file 0x2c0a | Meaning of each string group | 110 (2026-10-16) | Token diff = rename only; byte search; 32 hashes OK |
| `FUN_00002bbc` (ID02) | `initialize_application` | ID02 | RENAMED | PROVEN bytes / STRONG INFERENCE role | `ID02.c:1552-1564` | `ID02.decomp.c` (header; truncated C retained; caller renamed) | Toolbox init traps; ID09 glue (MaxApplZone, MoreMasters, FlushEvents, SetEventMask, NewPtrClear, NewHandleClear, SysEnvirons); ID07 strings; 'MENU' 2, 'HEL1' 127/128 | seg4 file 0x3d42 check; `$AA28`; HEL1 record layouts; helpers 0x2192/0x27e4/0x2e36/0x2eaa | 111 (2026-10-16) | Token diff = rename only; Capstone + JT resolution; 32 hashes OK |
| `FUN_0000309a` (ID02) | `main` | ID02 | RENAMED | PROVEN entry chain / STRONG INFERENCE role | `ID02.c:1650-1660` | `ID02.decomp.c` (header; truncated C retained) | ID01 entry JSR (A5,$4b2); `initialize_application`; ID08 overlay loader; UnloadSeg 4/8/5; loop on `FUN_00002fd4` | Helpers 0x1b42, 0x30fa, 0x35e4; A5−0x13ae/−0x14c4/−0x102e meanings | 112 (2026-10-16) | Token diff = rename only; Capstone + JT resolution; 32 hashes OK |
| `FUN_00002fd4` (ID02) | `poll_and_dispatch_event` | ID02 | RENAMED | PROVEN bytes / STRONG INFERENCE role | `ID02.c:1641-1646` | `ID02.decomp.c` (header; truncated C retained) | GetNextEvent; switch helper; callees 0x2f1e mouseDown, 0x36a2 menu cmd, 0x4db0 redraw, 0x2fa0 activate, 0x29f2, 0x3174, seg4 0x432 | Callee semantics; A5−0x14c6 flag; 68020-only EXTB.L vs 68000 support | 113 (2026-10-16) | Token diff = rename only; Capstone 000+020 decode; 32 hashes OK |
| `FUN_000036a2` (ID02) | `do_menu_command` | ID02 | RENAMED | PROVEN bytes / STRONG INFERENCE role | `ID02.c:1759-1764` | `ID02.decomp.c` (header: all five menus) | HiWord/LoWord; ID01 switch helper; desk accessories; SystemEdit; seg4/seg8 JT callees; local 0x2da0, 0x2eaa, 0x35e4, 0x4fc | Option byte meanings; menu titles; 0x2a44/0x27e4 roles; seg4 callee roles | 115 (2026-10-16) | Token diff = rename only; switch tables parsed; 32 hashes OK |
| `FUN_00002a44` (ID02) | `apply_settings_to_live_options` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1487-1546` | `ID02.decomp.c` (header with S→live map) | HEL1 127 S; live A5−0x12ee..−0x12d0; callbacks A5−0x1092/−0x104e/−0x1096; gate A5−0x1006, A5−0x137a==8; FUN_00004db0 | Callback targets; gate meanings; option semantics | 116 (2026-10-16) | Token diff = rename only; entry bytes match C; 6 callers by byte scan; 32 hashes OK |
| `FUN_00002f1e` (ID02) | `handle_mouse_down` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1613-1618` | `ID02.decomp.c` | FindWindow/MenuSelect/SystemClick/TrackGoAway/HideWindow; do_menu_command | — | 127 (2026-10-16) | Switch table parsed; token diff = renames |
| `FUN_00002fa0` (ID02) | `handle_activate_event` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1624-1634` | `ID02.decomp.c` | InvalRect(portRect) of main_window | — | 127 (2026-10-16) | Bytes match C + truncated tail |
| `FUN_00004db0` (ID02) | `redraw_main_window` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2721-2736` | `ID02.decomp.c` (header; call site renamed) | gates A5−0x14c6/−0x1006/−0x12f8; Hide/ShowCursor; UnloadSeg 3; overlay callback A5−0x109e; FUN_00004c18, FUN_00000930, 0x4d96, 0xa26 | Callee roles; callback target | 128 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00004c18` (ID02) | `check_device_color_state_changed` | ID02 | RENAMED | STRONG INFERENCE (purpose confirmed iter 130) | `ID02.c:2643-2688` | `ID02.decomp.c` | device table A5−0x136e[1..3]; FUN_000048ae; FUN_00004b62; JT $182 (seg3 0x6c1c); callback A5−0x1096 | FUN_000048ae tail; JT $182 role | 129 (2026-10-16) | C matches bytes; token diff = renames |
| `FUN_000048ae` (ID02) | `build_palette_index_map` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2547` | `ID02.decomp.c` | Get/SetGDevice; PmForeColor; thePort fgColor; depth A5−0x2cc; collision A5−0x102a; fnptr A5−0x1122 → 0x488a / 0xc68 | Uninitialised limit for other depths; selected routines' roles | 130 (2026-10-16) | Capstone; token diff = renames |
| `FUN_000046b4` (ID02) | `rebuild_all_palette_index_maps` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2484-2506` | `ID02.decomp.c` | build_palette_index_map; FUN_00004b62; FUN_00000d24 | A5−0x103a role | 131 (2026-10-16) | C matches bytes; token diff = renames |
| `FUN_00004738` (ID02) | `configure_palette_entries` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2520-2532` | `ID02.decomp.c` | SetEntryUsage/SetEntryColor; palettes A5−0x14ae/−0x14aa; RGB tables A5−0x350/−0x320/−0x302 | Callers | 131 (2026-10-16) | Capstone (Ghidra truncated) |
| `FUN_0000488a` (ID02) | `clear_ctab_size_callback` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2536-2545` | `ID02.decomp.c` | CurrentA5 $904; A5−0x14b2 block | +6 field meaning | 131 (2026-10-16) | Bytes match C |
| `FUN_000049fe` (ID02) | `lookup_palette_index_for_rgb_level` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2561-2632` | `ID02.decomp.c` | RGB tables A5−0x350 / *(A5−0x14a6)[A5−0x14a2]; mode A5−0x137a | Behaviour for modes ≠ 1/4/8 | 132 (2026-10-16) | C + prologue bytes; token diff = renames |
| `FUN_00000d24` (ID02) | `close_and_dispose_port` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:697-704` | `ID02.decomp.c` (+1 call site) | ClosePort $A87D; ID09 DisposPtr glue | — | 133 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00000d3a` (ID02) | `blit_offscreen_frame_to_window` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:708-741` | `ID02.decomp.c` | CurrentA5; FUN_00000ca6; CopyBits; rects A5−0x14f2/−0x14ea; JT $322 | Who receives LEA $322(A5) at ID02 0x1b6a; mode 2/3 meaning | 134 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00001b14` (ID02) | `freemem_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1106-1111` | `ID02.decomp.c` (header also documents unexported 0x1b42 table installer) | CurrentA5; ID09 FreeMem glue | Ghidra return-value error noted | 135 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00001a04` (ID02) | `dispose_handle_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | CurrentA5; ID09 DisposHandle glue | — | 136 (2026-10-16) | Capstone + JT; token diff = renames |
| `FUN_00001a28` (ID02) | `realloc_and_clear_handle_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | CurrentA5; ID09 ReallocHandle/MemError/HLock/clear/HUnlock glue | — | 136 (2026-10-16) | Capstone + JT; token diff = renames |
| `FUN_00001a84` (ID02) | `hlock_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | CurrentA5; ID09 HLock glue | — | 136 (2026-10-16) | Capstone + JT; token diff = renames |
| `FUN_00001aa8` (ID02) | `hunlock_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | CurrentA5; ID09 HUnlock glue | — | 136 (2026-10-16) | Capstone + JT; token diff = renames |
| `FUN_00001acc` (ID02) | `hpurge_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | CurrentA5; ID09 HPurge glue | — | 136 (2026-10-16) | Capstone + JT; token diff = renames |
| `FUN_00001af0` (ID02) | `hnopurge_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | CurrentA5; ID09 HNoPurge glue | — | 136 (2026-10-16) | Capstone + JT; token diff = renames |
| `FUN_000019a2` (ID02) | `new_handle_clear_or_die_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:994-1008` | `ID02.decomp.c` | NewHandleClear; MemError; fatal_memory_error_exit | Ghidra return error noted | 137 (2026-10-16) | Capstone; token diff = renames |
| `FUN_000019e2` (ID02) | `fatal_memory_error_exit` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1014-1031` | `ID02.decomp.c` (+2 call sites) | DisposPtr overlay; FUN_00004318; FUN_00001d48(str 93); ExitToShell | FUN_00004318 / FUN_00001d48 roles | 137 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00001d48` (ID02) | `show_caution_alert_with_number` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1157-1174` | `ID02.decomp.c` (+2 call sites) | c2pstr/p2cstr; ParamText; FUN_0000442e; CautionAlert 258; JT $4ba | A5 empty-string words; FUN_0000442e | 138 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00001c8a` (ID02) | `format_int_decimal_pstring` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1115-1150` | `ID02.decomp.c` (+1 call site) | — | — | 138 (2026-10-16) | C complete |
| `FUN_00004318` (ID02) | `shutdown_sound` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2381-2394` | `ID02.decomp.c` (+2 call sites) | FUN_00004242 ×3; low-mem $0196; FUN_00003d36; SndDisposeChannel | $0196 identity | 138 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00004242` (ID02) | `silence_sound_channel` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2343` | `ID02.decomp.c` (+3 calls) | FUN_00003d50; channel records A5−0x7d0 (0x238 each); A5−0xc26 | Buffer content at A5−0xc26 | 139 (2026-10-16) | Bytes match C |
| `FUN_00003d36` (ID02) | `clear_sound_buffer_to_silence` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2108` | `ID02.decomp.c` (+2 calls) | low-mem SoundBase $0266 | — | 139 (2026-10-16) | Capstone; Ghidra constant error noted |
| `FUN_00003d50` (ID02) | `alloc_sound_buffer_node` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2124-2148` | `ID02.decomp.c` (14 call sites) | channel free list (+4), node 0x1c bytes | Node field semantics | 140 (2026-10-16) | C + bytes; token diff = renames |
| `FUN_00003dd0` (ID02) | `init_sound_system` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2170-2230` | `ID02.decomp.c` (+1 call) | channel records; silence buffer; JT 0x412/0x41a/0x422; low-mem $0196; FUN_00003aae/39a8/3bc4 | $0196 vector identity; truncated tail | 140 (2026-10-16) | C + bytes |
| `FUN_000039a8` (ID02) | `vbl_sound_handler_ch0_unrolled` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1768` | `ID02.decomp.c` | JT 0x41a; ch0 resample ×8; Lvl1DT[1] | Variant differences; end-of-buffer logic | 141 (2026-10-16) | Capstone feature scan; token diff = renames |
| `FUN_00003aae` (ID02) | `vbl_sound_handler_ch0_variant` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1868` | `ID02.decomp.c` | JT 0x412; ch0 resample ×2; Lvl1DT[1] | Variant differences; end-of-buffer logic | 141 (2026-10-16) | Capstone feature scan; token diff = renames |
| `FUN_00003bc4` (ID02) | `vbl_sound_handler_two_channel` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1990` | `ID02.decomp.c` | JT 0x422; ch0+ch1 mix; writes $0196; Lvl1DT[1] | Variant differences; end-of-buffer logic | 141 (2026-10-16) | Capstone feature scan; token diff = renames |
| `FUN_00003db8` (ID02) | `select_two_channel_sound_handler` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2154` | `ID02.decomp.c` | $0196 = A5−0x35c if arg == 1; Lvl1DT[1] | Variant differences; end-of-buffer logic | 141 (2026-10-16) | Capstone feature scan; token diff = renames |
| `FUN_00003f54` (ID02) | `play_sample_on_channel` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2231-2260` | `ID02.decomp.c` | alloc_sound_buffer_node; select_two_channel_sound_handler; service slot −0x10de | Release of sustain loop | 142 (2026-10-17) | C complete; token diff = renames |
| `FUN_00004050` (ID02) | `enqueue_sample_on_channel` | ID02 | RENAMED | STRONG INFERENCE (purpose HYPOTHESIS) | `ID02.c:2266` | `ID02.decomp.c` | as play_sample_on_channel without head store; slot −0x10da | Reachability of queued nodes | 143 (2026-10-17) | C complete; token diff = renames |
| `FUN_0000412e` (ID02) | `set_sound_playback_rate` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2299-2317` | `ID02.decomp.c` | rate clamp; A5−0xc2a/−0xc2e/−0xc32; slot −0x10d6 | — | 144 (2026-10-17) | C complete; JT slot confirmed; token diff = renames |
| `FUN_000041a6` (ID02) | `release_channel_loop` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2321-2340` | `ID02.decomp.c` | alloc silence node; rewrite continuations; slot −0x10ce | — | 144 (2026-10-17) | C complete; JT slot confirmed; token diff = renames |
| `FUN_000042b0` (ID02) | `is_channel_playing` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:2360-2374` | `ID02.decomp.c` | buffer != silence; slot −0x10d2 | — | 144 (2026-10-17) | C complete; JT slot confirmed; token diff = renames |
| `FUN_00000c68` (ID02) | `apply_pending_color_entries_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:674` | `ID02.decomp.c` | SetEntries on A5−0x14b2 table; slot −0x1122 | — | 145 (2026-10-17) | Capstone; token diff = renames |
| `FUN_00001876` (ID02) | `blit_image_clipped_to_region` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:964` | `ID02.decomp.c` | region clip via FUN_000016aa; CopyBits from port A5−0x1496 | — | 145 (2026-10-17) | Capstone; token diff = renames |
| `FUN_0000195c` (ID02) | `blit_image_clipped_to_region_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:973` | `ID02.decomp.c` | CurrentA5 thunk; slot −0x111a | — | 145 (2026-10-17) | Capstone; token diff = renames |
| `FUN_0000197c` (ID02) | `run_segment3_entry_and_unload_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:984` | `ID02.decomp.c` | JT $17a + UnloadSeg 3; slot −0x111e | — | 145 (2026-10-17) | Capstone; token diff = renames |
| `FUN_00000a42` (ID02) | `draw_thick_line_pixel_index_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:640` | `ID02.decomp.c` | thePort fgColor; PenSize/MoveTo/LineTo; slot −0x1116 | — | 146 (2026-10-17) | Capstone; JT confirmed; token diff = renames |
| `FUN_00000a86` (ID02) | `draw_thick_xor_line_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:652` | `ID02.decomp.c` | ForeColor/PenMode srcXor/PenSize/MoveTo/LineTo; slot −0x1112 | — | 146 (2026-10-17) | Capstone; JT confirmed |
| `FUN_00000ad0` (ID02) | `paint_view_horizon_bands_a5safe` | ID02 | RENAMED | STRONG INFERENCE (purpose HYPOTHESIS) | `ID02.c:663` | `ID02.decomp.c` | view rect A5−0x1202..−0x11fc; clip A5−0x13b6; PaintRect/OpenPoly/PaintPoly; slot −0x110a | Arg meanings | 147 (2026-10-17) | Capstone; token diff = renames |
| `FUN_000015cc` (ID02) | `set_draw_color_index` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:884` | `ID02.decomp.c` (+1 call) | fgColor or B&W JT $1ca | 1-bit branch | 147 (2026-10-17) | C + bytes |
| `FUN_00000f52` (ID02) | `close_port_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | ClosePort; slot −0x10fe | — | 148 (2026-10-17) | Capstone; JT confirmed; token diff = renames |
| `FUN_00000f74` (ID02) | `swap_port_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | SetPort, returns old thePort; slot −0x1102 | — | 148 (2026-10-17) | Capstone; JT confirmed; token diff = renames |
| `FUN_00000fa0` (ID02) | `paint_rect_color_index_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | colour index + PaintRect + PenPat; slot −0x10fa | — | 148 (2026-10-17) | Capstone; JT confirmed; token diff = renames |
| `FUN_00000fd2` (ID02) | `paint_polygon_rgb_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | RGB from 0xRRGGBBxx; poly with y negated; FillPoly or RGBForeColor+PaintPoly; slot −0x10f6 | — | 148 (2026-10-17) | Capstone; JT confirmed; token diff = renames |
| `FUN_00000e3e` (ID02) | `blit_pixels_via_port_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | baseAddr + CopyBits to port/thePort; slot −0x10ee | — | 149 (2026-10-17) | Capstone; token diff = renames |
| `FUN_00000e9e` (ID02) | `open_offscreen_cport_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | OpenCPort, pixmap rowBytes|0x8000/base/bounds, portRect, RectRgn; slot −0x1106 | — | 149 (2026-10-17) | Capstone; token diff = renames |
| `FUN_00000ca6` (ID02) | `new_offscreen_cport` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | NewPtrClear(0x6c) + OpenCPort + pixmap/portRect/visRgn; JT $402 | — | 149 (2026-10-17) | Capstone; token diff = renames |
| `FUN_000014e6` (ID02) | `swap_mmu_mode_a5safe` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:856` | `ID02.decomp.c` | ID09 swapmmumode_glue on A5−0x1000; slot −0x10c6 | — | 150 (2026-10-17) | C + bytes |
| `FUN_000011ec` (ID02) | `draw_notched_frame_pair_a5safe` | ID02 | RENAMED | STRONG INFERENCE mechanics / UNKNOWN purpose | `ID02.c:830` | `ID02.decomp.c` | build_notched_frame_poly ×2 (rect A5−0x119c); grey indices; slot −0x10ea | Shape meaning | 151 (2026-10-17) | Capstone |
| `FUN_000010ce` (ID02) | `build_notched_frame_poly` | ID02 | RENAMED | STRONG INFERENCE mechanics | `ID02.c:819` | `ID02.decomp.c` | OpenPoly; pnSize; Line/LineTo | Tail not fully listed | 151 (2026-10-17) | Capstone |
| `FUN_00001308` (ID02) | `draw_text_in_columns_a5safe` | ID02 | RENAMED | STRONG INFERENCE mechanics / HYPOTHESIS purpose | `ID02.c:841` | `ID02.decomp.c` | FillRect QD patterns; TextFace/CharWidth/DrawString/DrawText; GetPen/Move columns A5−0x14d2/−0x14d0/−0x14ce; slot −0x110e | Arg layout | 152 (2026-10-17) | Condensed Capstone reading |
| `FUN_0000001e` (ID02) | `abs_long` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | JT $4da | — | 162 (2026-10-17) | C + bytes; token diff = renames |
| `FUN_00001632` (ID02) | `set_back_color_index` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | bkColor / A5−0x13b8 | — | 162 (2026-10-17) | C + bytes; token diff = renames |
| `FUN_00001656` (ID02) | `design_x_to_screen` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | JT $3ca; +width/2 | — | 162 (2026-10-17) | C + bytes; token diff = renames |
| `FUN_00001680` (ID02) | `design_y_to_screen` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | JT $382; +height/2 | — | 162 (2026-10-17) | C + bytes; token diff = renames |
| `FUN_00002db8` (ID02) | `wait_for_click_or_key` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | GetNextEvent loop; returns on mouseDown/keyDown/autoKey; JT $4aa | — | 173 (2026-10-17) | Capstone + table |
| `FUN_00004d34` (ID02) | `process_pending_update_events` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | updateMask loop → redraw_main_window; JT $462 | — | 173 (2026-10-17) | Capstone |
| `FUN_00002e36` (ID02) | `show_resource_file_error_box` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c:1581` | `ID02.decomp.c` (header also documents unexported quit_application at 0x2eaa) | dBox window; STR#129 117/118; Button wait | seg4 0x516 / 0x4f0 roles | 174 (2026-10-17) | Capstone + resource dump |
| `FUN_000007b0` (ID06) | `init_raster_target` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c:494` | `ID06.decomp.c` | target record A5−0x1cce; centre A5−0x1cca/−0x1cc8 | Field roles | 153 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000598` (ID06) | `alloc_row_table` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c:405` | `ID06.decomp.c` | A5−0x1cd2 + n×12 row entries | Field roles | 153 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000666` (ID06) | `init_edge_pool` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c:443` | `ID06.decomp.c` | A5−0x1cd6 0x5e9c pool, sentinels | Field roles | 153 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000512` (ID06) | `free_row_table` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c:382` | `ID06.decomp.c` | frees A5−0x1cd2 buffers | Field roles | 153 (2026-10-17) | C complete; token diff = renames |
| `FUN_0000087a` (ID06) | `set_raster_target_base` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c:541` | `ID06.decomp.c` | target +0 = base | Field roles | 153 (2026-10-17) | C complete; token diff = renames |
| `FUN_000008a2` (ID06) | `set_active_row_count` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | clamp to height; slot −0x1304 | Node/attribute semantics | 154 (2026-10-17) | C complete; JT confirmed; token diff = renames |
| `FUN_0000096e` (ID06) | `reset_edge_table` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | clear buckets, reset pool, toggle +0x14; slot −0x1310 | Node/attribute semantics | 154 (2026-10-17) | C complete; JT confirmed; token diff = renames |
| `FUN_000009d8` (ID06) | `add_polygon_edges` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | clip + slope + 0x28-byte nodes into row buckets; slot −0x130c | Node/attribute semantics | 154 (2026-10-17) | C complete; JT confirmed; token diff = renames |
| `FUN_00000e10` (ID06) | `rasterize_and_present` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | renderer callback JT $192 (ID06 0x318) + banded blit via JT $322; slot −0x1308 | Node/attribute semantics | 154 (2026-10-17) | C complete; JT confirmed; token diff = renames |
| `FUN_0000026c` (ID06) | `init_row_table_fields` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | callback, shift 11, stride, 8-row table pointers | Node/attribute semantics | 154 (2026-10-17) | C complete; JT confirmed; token diff = renames |
| `FUN_00000318` (ID06) | `render_scanline_spans` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c:236` | `ID06.decomp.c` | active edge list, parity/priority polygon list, pattern longs; in-code state 0x39e..0x3e1 | Pattern/colour index details | 155 (2026-10-17) | C + bytes (BRA over data) |
| `FUN_00000d84` / `FUN_00000dca` (ID06) | `rebase_edge_rows_for_band` / `restore_edge_rows_after_band` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c:808/825` | `ID06.decomp.c` | node +0x22 rebasing per band | — | 155 (2026-10-17) | C complete |
| `FUN_000001dc` (ID06) | `alloc_aligned_clear` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | FreeMem/MaxMem/NewPtrClear, 4-byte aligned + header | — | 157 (2026-10-17) | C complete; token diff = renames |
| `FUN_0000024c` (ID06) | `free_aligned` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | DisposPtr(header) | — | 157 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000116` (ID06) | `rgb_to_bw_pattern` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | luma 19/38/7 → 64-level pattern A5−0x1ed6 | — | 157 (2026-10-17) | C complete; token diff = renames |
| `FUN_0000017c` (ID06) | `lookup_colour_map` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | table *(A5−0x1ede)[i] | — | 157 (2026-10-17) | C complete; token diff = renames |
| `FUN_000001a2` (ID06) | `reverse_lookup_colour_map` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | inverse search | — | 157 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000004` (ID06) | `init_pattern_tables` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | masks + 64 patterns + grey map | — | 158 (2026-10-17) | C complete; token diff = renames |
| `FUN_000000b0` (ID06) | `alloc_pattern_tables` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | alloc 0xc00 / 0x200 then init | — | 158 (2026-10-17) | C complete; token diff = renames |
| `FUN_000000f4` (ID06) | `get_pattern_table` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | ensure + return A5−0x1eda | — | 158 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000916` (ID06) | `get_raster_target_size` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | width/height out-params | — | 158 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000942` (ID06) | `realloc_row_table` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | row table + edge pool rebuild | — | 158 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000d02` (ID06) | `add_rect_polygon` | ID06 | RENAMED | STRONG INFERENCE | `ID06.c` | `ID06.decomp.c` | 4-point polygon via add_polygon_edges | — | 158 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000056` (ID03) | `scale_design_480_min10` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | (A5−0x149e·v+5)/480, ≥10 | A5−0x149e identity | 159 (2026-10-17) | C complete; token diff = renames |
| `FUN_0000008a` (ID03) | `scale_design_4800` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | A5−0x149e·v/4800; 13 call sites | A5−0x149e identity | 159 (2026-10-17) | C complete; token diff = renames |
| `FUN_000000a6` (ID03) | `scale_design_4800_pen_centred` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | minus pnSize.h/2 | A5−0x149e identity | 159 (2026-10-17) | C complete; token diff = renames |
| `FUN_000000c8` (ID03) | `max3_int` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | max of three | A5−0x149e identity | 159 (2026-10-17) | C complete; token diff = renames |
| `FUN_000000f4` (ID03) | `nearest_palette_index_rgb` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | Chebyshev nearest of 8 base + first-better extended entry | A5−0x149e identity | 159 (2026-10-17) | C complete; token diff = renames |
| `FUN_00000006` (ID03) | `set_scaled_text_style` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | TextFace + scaled TextSize by mode | — | 160 (2026-10-17) | Capstone (Ghidra truncated); token diff = renames |
| `FUN_000002a8` (ID03) | `new_offscreen_bw_port` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | 1-bit bitmap + OpenPort/SetPortBits/PortSize/RectRgn | — | 160 (2026-10-17) | Capstone (Ghidra truncated); token diff = renames |
| `FUN_0000033c` (ID03) | `dispose_offscreen_bw_port` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | ClosePort + DisposPtr bits + port | — | 160 (2026-10-17) | Capstone (Ghidra truncated); token diff = renames |
| `FUN_00000912` (ID03) | `draw_vector_number` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | stroke font A5−0x1fde[digit]; scale_design_4800_pen_centred | Loop tail not exported | 161 (2026-10-17) | C (truncated) |
| `FUN_0000035e` (ID03) | `draw_spinning_disc_indicator` | ID03 | RENAMED | STRONG INFERENCE mechanics | `ID03.c` | `ID03.decomp.c` | ovals, clip region, 4-phase spoke A5−0x2112, size A5−0x2114; 5 callers in FUN_00000514 | What it depicts | 163 (2026-10-17) | Full Capstone decode |
| `FUN_00000514` (ID03) | `draw_ring_with_status_indicators` | ID03 | RENAMED | STRONG INFERENCE mechanics / HYPOTHESIS purpose | `ID03.c` | `ID03.decomp.c` | black disc + grey ring; up to 5 spinning indicators at cos45 offsets by flag bits | Bit-4 position; caller | 164 (2026-10-17) | Capstone |
| `FUN_00000a3c` (ID03) | `antialias_downsample_bw_3x` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | 7×7 Gaussian-like kernel /969; nearest_palette_index_rgb; MoveTo+Line(0,0) pixel plot; out buffer | x0/y0 h/v roles | 166 (2026-10-17) | Full Capstone decode |
| `FUN_00003c02` (ID03) | `draw_instrument` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | bezel ring + screws; type 0..9 switch to per-gauge drawers; record A5−0x12a2+type·16 | Gauge identities; tail | 167 (2026-10-17) | Capstone + switch table parsed |
| `FUN_00001876` (ID03) | `draw_altimeter` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | label STR#129 slot 65 "ALTITUDE"; fn ptr A5−0x2118; draw_vector_number | Needle math | 168 (2026-10-17) | Capstone + resource dump |
| `FUN_00001538` (ID03) | `begin_instrument_supersample` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` (11 call sites) | new_offscreen_bw_port 1× or 3× | — | 168 (2026-10-17) | C (truncated) |
| `FUN_00001b48` (ID03) | `draw_airspeed_indicator` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | instrument type 1; label "AIR SPEED" | Drawing internals | 169 (2026-10-17) | STR#129 label scan |
| `FUN_00002d1c` (ID03) | `draw_turn_and_bank_indicator` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | instrument type 2; label "TURN BANK" | Drawing internals | 169 (2026-10-17) | STR#129 label scan |
| `FUN_00001fee` (ID03) | `draw_climb_indicator` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | instrument type 3; label "CLIMB" | Drawing internals | 169 (2026-10-17) | STR#129 label scan |
| `FUN_00002600` (ID03) | `draw_manifold_pressure_gauge` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | instrument type 4; label "Manifold Pressure" | Drawing internals | 169 (2026-10-17) | STR#129 label scan |
| `FUN_000022fe` (ID03) | `draw_tachometer` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | instrument type 5; label "RPM" | Drawing internals | 169 (2026-10-17) | STR#129 label scan |
| `FUN_00002950` (ID03) | `draw_direction_indicator` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | instrument type 6; label "DIRECTION" | Drawing internals | 169 (2026-10-17) | STR#129 label scan |
| `FUN_00004c42` (ID03) | `draw_flaps_indicator` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | label FLAPS; bezel at 0x4c58 | Internals | 171 (2026-10-17) | STR#129 slot scan |
| `FUN_00004ecc` (ID03) | `draw_ammo_counter` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | label AMMO; bezel at 0x4ee2 | Internals | 171 (2026-10-17) | STR#129 slot scan |
| `FUN_0000532e` (ID03) | `draw_fuel_gauge` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | label Fuel; bezel at 0x5346 | Internals | 171 (2026-10-17) | STR#129 slot scan |
| `FUN_00003d42` (ID04) | `check_system_requirements` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | SysEnvirons; hasColorQD; processor ≥ 68020; slot 61 alert; JT $f2 | — | 172 (2026-10-17) | C + bytes |
| `FUN_000003c2` (ID04) | `run_with_temporary_window` | ID04 | RENAMED | STRONG INFERENCE mechanics | `ID04.c` | `ID04.decomp.c` | NewWindow "Hellcats" inset 100; Show / ID02 0x2db8 / Hide | Purpose of ID02 0x2db8 | 172 (2026-10-17) | Capstone |
| `FUN_000004f0` (ID04) | `ask_save_changes` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | ALRT 257 Save / Cancel / Don't Save; JT $ba | — | 175 (2026-10-17) | Capstone + ALRT/DITL dump |
| `FUN_00000516` (ID04) | `confirm_end_mission` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | ALRT 259 Cancel / End Mission; mission state A5−0x12f8 ≥ 3, A5−0x14c4 == 0; JT $13a | — | 175 (2026-10-17) | Capstone + ALRT/DITL dump |
| `FUN_00000560` (ID04) | `confirm_erase_high_scores` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | ALRT 260 Cancel / Erase | — | 175 (2026-10-17) | Capstone + ALRT/DITL dump |
| `FUN_00000588` (ID04) | `compute_pilot_score` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | 12 tallies ×12 weights (A5−0xf5e); HEL1 128 records | Tally 10/11 meaning | 176 (2026-10-17) | C complete + resource dump |
| `FUN_00000f4e` (ID04) | `rank_pilots_by_score` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | scores + sorted order for 20 pilots | Tie-break / JT $512 role | 177 (2026-10-17) | C |
| `FUN_00001106` (ID04) | `reset_pilot_record` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | clear +0x20..+0x26 and tallies | Tie-break / JT $512 role | 177 (2026-10-17) | C |
| `FUN_00001a0e` (ID04) | `build_rank_and_name_string` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | rank group + separator + name | Tie-break / JT $512 role | 177 (2026-10-17) | C |
| `FUN_000031aa` (ID04) | `conclude_mission` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | mission-over flag A5−0x14c4; status A5−0x12b4 → record +0x20; JT $da | FUN_00003124 / 2de6 / 3178 roles | 178 (2026-10-17) | C + JT callers |
| `FUN_00003124` (ID04) | `play_named_sound_async` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | GetNamedResource('snd ', A5−0x2128); SndNewChannel; SndPlay async | Sound name | 179 (2026-10-17) | Capstone |
| `FUN_00003178` (ID04) | `stop_named_sound` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | SndDisposeChannel; HUnlock; ReleaseResource | — | 179 (2026-10-17) | Capstone |
| `FUN_00002de6` (ID04) | `show_mission_summary_dialog` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | DLOG 133 "Mission Summary"; 12-tally loop; local item helpers | Item helpers 0xec/0x06/0xc4/0x54/0x78/0x1b8/0x17e6 | 180 (2026-10-17) | Capstone + DLOG/DITL dump |
| `FUN_00000006` (ID04) | `disable_dialog_control` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + HiliteControl 255 | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_0000002e` (ID04) | `enable_dialog_control` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + HiliteControl 0 | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_00000054` (ID04) | `hide_dialog_control` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + HideControl | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_00000078` (ID04) | `show_dialog_control` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + ShowControl | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_0000009c` (ID04) | `set_dialog_item_text` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + SetIText | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_000000c4` (ID04) | `set_dialog_control_title` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + SetCTitle | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_000000ec` (ID04) | `set_dialog_user_item_proc` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + SetDItem with a ProcPtr | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_00000120` (ID04) | `frame_dialog_item_box` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + InsetRect -2, PenSize 1, FrameRect | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_0000016e` (ID04) | `draw_default_button_outline` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + user item via JT $12a; item A5-0x225e; FrameRoundRect 16 | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_000001f2` (ID04) | `draw_grey_user_item` | ID04 | RENAMED | PROVEN (bytes) | `ID04.c` (halt_baddata stub) | `ID04.decomp.c` | GetDItem + user item via JT $142; FillRect gray A5-0x1624 | — | 181 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_000017e6` (ID04) | `create_scrolling_text_item` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` (halt_baddata) | `ID04.decomp.c` | TENew -> A5-0x223a; NewControl scrollBarProc -> A5-0x2236; user item JT $92 | Caller path for text fill; JT $92 proc (0x14f2) | 182 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_0000189c` (ID04) | `dispose_scrolling_text_item` | ID04 | RENAMED | PROVEN | `ID04.c` (halt_baddata) | `ID04.decomp.c` | TEDispose + DisposeControl | Callers | 182 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_000018b0` (ID04) | `append_line_to_scrolling_text` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` (halt_baddata) | `ID04.decomp.c` | strlen (ID02 0x3e8) + TEInsert ×2 + 0x158c scroll update | Separator byte A5-0x213a; callers | 182 (2026-10-17) | dis.py on ID04.bin; CODE0 JT parse; token diff = renames |
| `FUN_000014a0` (ID04) | `draw_scrolling_text_item` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | EraseRect viewRect, TEUpdate, frame | — | 183 (2026-10-17) | dis.py on ID04.bin; CODE0 JT; ID01 switch table bytes; token diff = renames |
| `FUN_000014f2` (ID04) | `scrolling_text_user_item_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | Pascal user item, JT $92 | — | 183 (2026-10-17) | dis.py on ID04.bin; CODE0 JT; ID01 switch table bytes; token diff = renames |
| `FUN_0000150e` (ID04) | `sync_text_scroll_to_control` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | TEScroll by ctl value × lineHeight | — | 183 (2026-10-17) | dis.py on ID04.bin; CODE0 JT; ID01 switch table bytes; token diff = renames |
| `FUN_00001562` (ID04) | `update_scroll_bar_maximum` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | SetCtlMax(nLines − visible) | — | 183 (2026-10-17) | dis.py on ID04.bin; CODE0 JT; ID01 switch table bytes; token diff = renames |
| `FUN_0000158c` (ID04) | `scroll_text_to_show_selection` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | centre line holding selStart | — | 183 (2026-10-17) | dis.py on ID04.bin; CODE0 JT; ID01 switch table bytes; token diff = renames |
| `FUN_00001638` (ID04) | `fit_text_view_to_box` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | viewRect = box − 16, whole lines, TECalText | — | 183 (2026-10-17) | dis.py on ID04.bin; CODE0 JT; ID01 switch table bytes; token diff = renames |
| `FUN_000016c4` (ID04) | `scroll_bar_action_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $16a TrackControl action; parts 20..23; also documents unexported click handler 0x1752 | — | 183 (2026-10-17) | dis.py on ID04.bin; CODE0 JT; ID01 switch table bytes; token diff = renames |
| `FUN_000018e0` (ID04) | `get_mission_kill_report_state` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | 0/1/2 from A5-0x12f8, -0x14c0, -0x12ba and ten kill words A5-0x12ce | State 2 meaning | 184 (2026-10-17) | dis.py on ID04.bin; STR# 129 / DITL 133 dump; token diff = renames |
| `FUN_0000192e` (ID04) | `update_summary_dialog_buttons` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | enables items 1/3; moves default ring A5-0x225e to item 1 | A5-0x12f0 / -0x2228 / -0x2230 roles | 184 (2026-10-17) | dis.py on ID04.bin; STR# 129 / DITL 133 dump; token diff = renames |
| `FUN_00002d86` (ID04) | `set_score_item_text` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | "Score: " (STR# 58) + compute_pilot_score; strcpy/strcat ID02 0x2c8/0x2d8; ID09 0x432/0x416 | — | 185 (2026-10-17) | dis.py; STR# dump; token diff = renames |
| `FUN_00001f5e` (ID04) | `draw_aircraft_kill_markers` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | tally[0]+tally[1] (≤24) markers in a 6-column grid; red PaintOval in a frame | Lifetime vs mission count | 186 (2026-10-17) | dis.py; DITL 133 placement; token diff = renames |
| `FUN_000020e8` (ID04) | `aircraft_kill_markers_user_item_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | Pascal user item, JT $ea, item 7 of DLOG 133 | — | 186 (2026-10-17) | dis.py; CODE0 JT |
| `FUN_00001bc8` (ID04) | `draw_targets_destroyed_row` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | skips types 2/4/8; 7 rows; "name sep n … n×weight" right-aligned | Separator text A5-0x2136 | 188 (2026-10-17) | dis.py; token diff = renames |
| `FUN_00001d9e` (ID04) | `draw_targets_destroyed_list` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $aa user item 6; also documents unexported draw_mission_awards (0x1dde, JT $152, cicn 512–519) | — | 187 (2026-10-17) | dis.py; CODE0 JT; DITL/cicn dump |
| `FUN_00000220` (ID04) | `draw_percent_bar_item` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | percentage bar A5-0x225c (0..100), dkGray / white | — | 193 (2026-10-17) | dis.py; CODE0 JT; token diff = renames |
| `FUN_000002c0` (ID04) | `percent_bar_user_item_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $8a user item; documents unexported set_radio_group_selection 0x2dc | — | 193 (2026-10-17) | dis.py; CODE0 JT; token diff = renames |
| `FUN_00000362` (ID04) | `get_radio_group_selection` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | first set control of an item list, else -1 | — | 193 (2026-10-17) | dis.py; CODE0 JT; token diff = renames |
| `FUN_00000a8e` (ID04) | `fuel_slider_dialog_filter` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | Return/Enter, slider tracking (StillDown/GetMouse), update events | — | 194 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL 129 / 132 dump; token diff = renames |
| `FUN_00000bda` (ID04) | `scenario_selection_filter_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $112 filter, DLOG 129, slider item 5 | — | 194 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL 129 / 132 dump; token diff = renames |
| `FUN_00000e48` (ID04) | `refuel_dialog_filter_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $14a filter, DLOG 132, slider item 3 | — | 194 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL 129 / 132 dump; token diff = renames |
| `FUN_000009ee` (ID04) | `draw_select_mission_title` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $11a user item 4 of DLOG 129; STR# 64 centred, size 24 | — | 197 (2026-10-17) | dis.py; CODE0 JT; token diff = renames |
| `FUN_0000116a` (ID04) | `prune_inactive_pilots_beyond_ten` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | clears non-Active records after the best ten; WriteResource roster | — | 197 (2026-10-17) | dis.py; CODE0 JT; token diff = renames |
| `FUN_0000044e` (ID04) | `show_scenery_open_error_alert` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | ParamText + StopAlert(256) "Unable to open Hellcats scenery file"; JT $fa | — | 198 (2026-10-17) | dis.py; CODE0 JT; ALRT/DLOG/DITL dump; token diff = renames |
| `FUN_00000478` (ID04) | `show_paused_dialog` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | DLOG 131 "Paused", wait for key down + up; JT $122 | — | 198 (2026-10-17) | dis.py; CODE0 JT; ALRT/DLOG/DITL dump; token diff = renames |
| `FUN_000005e4` (ID04) | `duty_roster_filter_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $c2 filter; documents unexported run_duty_roster_dialog 0x644 (JT $132, DLOG 130) | — | 198 (2026-10-17) | dis.py; CODE0 JT; ALRT/DLOG/DITL dump; token diff = renames |
| `FUN_00003260` (ID04) | `draw_map_grid_and_centre_mark` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | 4 x 4 grid + centre cross; A5-0x214e = 1 | A5-0x1052 target | 199 (2026-10-17) | dis.py; CODE0 JT; STR# 59; token diff = renames |
| `FUN_00003352` (ID04) | `plot_map_symbol_callback` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $72 callback: DrawChar at map coordinates (CurrentA5) | A5-0x1052 target | 199 (2026-10-17) | dis.py; CODE0 JT; STR# 59; token diff = renames |
| `FUN_000033d6` (ID04) | `draw_map_view_item` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | blue sea, A5-0x1052(scale, JT $72), scale text " mi./grid" item 7 | A5-0x1052 target | 199 (2026-10-17) | dis.py; CODE0 JT; STR# 59; token diff = renames |
| `FUN_000035f8` (ID04) | `map_view_user_item_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $b2; documents unexported track_map_bearing_and_distance 0x3614 | — | 200 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL dump; token diff = renames |
| `FUN_00003902` (ID04) | `map_dialog_filter_proc` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $d2; documents unexported run_map_dialog 0x3976 (JT $10a, DLOG 137 zoom) | — | 200 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL dump; token diff = renames |
| `FUN_00003a56` (ID04) | `poll_click_or_key_event` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | 1 for mouseDown / keyDown / autoKey | — | 200 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL dump; token diff = renames |
| `FUN_00003a8c` (ID04) | `show_about_dialog` | ID04 | RENAMED | STRONG INFERENCE | `ID04.c` | `ID04.decomp.c` | DLOG 127 / 138 (1-bit), vers 1 text; tail not decoded | — | 200 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL dump; token diff = renames |
| `FUN_00001200` (ID04) | `draw_high_scores_table` | ID04 | RENAMED | PROVEN | `ID04.c` | `ID04.decomp.c` | JT $e2 user item 10 of DLOG 134; documents unexported run_high_scores_dialog 0x137a (JT $102) | — | 201 (2026-10-17) | dis.py; CODE0 JT; DLOG/DITL 134; token diff = renames |
| `FUN_000032b8` (ID03) | `draw_gyro_instrument` | ID03 | RENAMED | STRONG INFERENCE (HYPOTHESIS which gyro) | `ID03.c` | `ID03.decomp.c` | type 8; handles A5-0x11dc "GyroInstrument" / A5-0x11d4 "GyroFlags" | body details | 202 (2026-10-17) | dis.py on ID03.bin; AddResource names in ID03 0x5b5e..0x5d44; token diff = renames |
| `FUN_00003832` (ID03) | `make_inset_face_oval_region` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | oval region of the face inside the bezel | body details | 202 (2026-10-17) | dis.py on ID03.bin; AddResource names in ID03 0x5b5e..0x5d44; token diff = renames |
| `FUN_000038fc` (ID03) | `draw_artificial_horizon` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | type 9; region clip, rotated line; handle A5-0x11f6 "HorizonInstrument" | body details | 202 (2026-10-17) | dis.py on ID03.bin; AddResource names in ID03 0x5b5e..0x5d44; token diff = renames |
| `FUN_00005ab6` (ID03) | `store_panel_bitmaps_as_resources` | ID03 | RENAMED | PROVEN | `ID03.c` | `ID03.decomp.c` | HEL2 200–500 + config A5-0x13ae; error -> A5-0x14a0 (ID04 0x432 alert); documents release routine 0x59f4 | — | 203 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00005c36` (ID03) | `open_cport_on_buffer` | ID03 | RENAMED | PROVEN | `ID03.c` | `ID03.decomp.c` | OpenCPort on a caller buffer (rowBytes, baseAddr, bounds) | redraw path after 0x5f20 | 204 (2026-10-17) | dis.py on ID03.bin; CODE0 JT; token diff = renames |
| `FUN_00005cb6` (ID03) | `close_port_glue` | ID03 | RENAMED | PROVEN | `ID03.c` | `ID03.decomp.c` | ClosePort | redraw path after 0x5f20 | 204 (2026-10-17) | dis.py on ID03.bin; CODE0 JT; token diff = renames |
| `FUN_00005cc4` (ID03) | `prepare_instrument_panel` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | JT $17a; panel scale A5-0x149e; Bitmap Cache lookup by display configuration | redraw path after 0x5f20 | 204 (2026-10-17) | dis.py on ID03.bin; CODE0 JT; token diff = renames |
| `FUN_00005860` (ID03) | `compute_panel_screen_addresses` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | screen byte addresses base + y*rowBytes + x/(8/depth) | — | 205 (2026-10-17) | Ghidra C / dis.py; token diff = renames |
| `FUN_00006c1c` (ID03) | `remap_cached_panel_colours` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | JT $182; re-colours a cached panel; palette indices via lookup_palette_index_for_rgb_level | — | 205 (2026-10-17) | Ghidra C / dis.py; token diff = renames |
| `FUN_0000077e` (ID03) | `draw_vector_glyph_string_centred` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | centred stroke-font string; glyph table A5-0x20b0 (6 glyphs) | — | 206 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_0000146a` (ID03) | `composite_instrument_bitmap` | ID03 | RENAMED | PROVEN | `ID03.c` | `ID03.decomp.c` | CopyBits (1-bit) or antialias_downsample_bw_3x into the panel port A5-0x1496 | — | 206 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00001844` (ID03) | `finish_instrument_supersample` | ID03 | RENAMED | PROVEN | `ID03.c` | `ID03.decomp.c` | SetPort(panel), composite, dispose_offscreen_bw_port | — | 206 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00003f24` (ID03) | `draw_bevelled_frame` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | four shaded polygons between outer and inner rects | — | 207 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00004110` (ID03) | `draw_numbered_bevel_box` | ID03 | RENAMED | PROVEN | `ID03.c` | `ID03.decomp.c` | black box, bevel, vector-font number | — | 207 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00004790` (ID03) | `draw_percent_scale_gauge` | ID03 | RENAMED | STRONG INFERENCE (HYPOTHESIS role) | `ID03.c` | `ID03.decomp.c` | vertical 0–100 scale, ten ticks, labels 100 / 0; record A5-0x1186 | which control | 208 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00004b32` (ID03) | `draw_split_display_box` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | framed box split into halves A5-0x119c / A5-0x1194 (used by ID02 overlay drawing) | which indicator | 209 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00004304` (ID03) | `draw_panel_section_with_numbered_boxes` | ID03 | RENAMED | STRONG INFERENCE mechanics / UNKNOWN purpose | `ID03.c` | `ID03.decomp.c` | dark area A5-0x11aa, line loops, bevel, boxes 1 / 3 / 15 -> A5-0x11c6 / -0x11be / -0x11b6 | meaning | 210 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_000054fe` (ID03) | `draw_landing_gear_indicator` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | STR# 78 "GEAR" label, three lamp positions A5-0x1174..-0x1164 | — | 211 (2026-10-17) | Ghidra C + dis.py; token diff = renames |
| `FUN_00005718` (ID03) | `dial_point_at_angle` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | degrees -> 1/0x4000 turn; cos A5-0x2118 / sin A5-0x211c, 4.12 | — | 211 (2026-10-17) | Ghidra C + dis.py; token diff = renames |
| `FUN_00005158` (ID03) | `draw_arc_scale_ticks` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | 10-degree arc ticks via cos / sin pointers; documents unexported gauge 0x532e | — | 212 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_000071a2` (ID03) | `remap_panel_colours_identity` | ID03 | RENAMED | STRONG INFERENCE | `ID03.c` | `ID03.decomp.c` | identity 256-entry table -> remap_cached_panel_colours | — | 212 (2026-10-17) | dis.py on ID03.bin; token diff = renames |
| `FUN_00000038`..`FUN_000002ee` (ID02, 20 functions) | `ansi_div`, `ansi_ldiv`, `ansi_isalnum` … `ansi_isxdigit`, `ansi_toupper`, `ansi_tolower`, `ansi_memcpy`, `ansi_memmove`, `ansi_strcpy`, `ansi_strcat`, `ansi_strcmp` | ID02 | RENAMED | PROVEN (mem/str) / STRONG INFERENCE (ctype names) | `ID02.c` | `ID02.decomp.c` | C runtime; ctype table A5-0x1608 | — | 213 (2026-10-17) | complete Ghidra C + iteration 185 bytes; token diff = renames |
| `FUN_0000030c`..`FUN_00000412` (ID02, 9 functions) | `ansi_strchr`, `ansi_strcspn`, `ansi_strpbrk`, `ansi_strrchr`, `ansi_strspn`, `ansi_strstr`, `ansi_strtok`, `ansi_strncpy`, `ansi_strncat` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | C runtime; strtok save pointer A5-0x1508 | — | 214 (2026-10-17) | complete Ghidra C; token diff = renames |
| `FUN_0000045a` (ID02) | `begin_overlay_session` | ID02 | RENAMED | STRONG INFERENCE mechanics | `ID02.c` | `ID02.decomp.c` | UnloadSeg 4, memory + sound, hooks A5-0x1082 / -0x107e; documents end_overlay_session 0x4a4 | hook targets in the overlay | 215 (2026-10-17) | dis.py on ID02.bin / ID09 glue; token diff = renames |
| `FUN_000004c6` (ID02) | `ensure_free_memory_and_init_sound` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | FreeMem < 500000 -> MaxMem; init_sound_system | hook targets in the overlay | 215 (2026-10-17) | dis.py on ID02.bin / ID09 glue; token diff = renames |
| `FUN_00000930` (ID02) | `call_overlay_session_hooks` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | hooks A5-0x1082, -0x107e, -0x107a(a, b), -0x1076 | hook targets in the overlay | 215 (2026-10-17) | dis.py on ID02.bin / ID09 glue; token diff = renames |
| `FUN_000004fc` (ID02) | `run_flight_session` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` (halt_baddata) | `ID02.decomp.c` | overlay hooks -0x106e / -0x106a / -0x1086 / -0x107a; result switch -> conclude_mission / quit / pause | per-key table at 0x650 | 216 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_0000150a` (ID02) | `get_blended_fill_pattern` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | depth 1: dither of the fg / bg colour average; else gray | — | 217 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_000016aa` (ID02) | `draw_view_frame_outline` | ID02 | RENAMED | STRONG INFERENCE mechanics | `ID02.c` | `ID02.decomp.c` | outline of the design rect x ±3200, y 670..2400 | — | 217 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_00001dd4` (ID02) | `show_sound_error_dialog_once` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | DLOG 139 "Sound Error", once (A5-0xd12) | — | 218 (2026-10-17) | dis.py on ID02.bin; ID09 glue; DLOG dump; token diff = renames |
| `FUN_00001e32` (ID02) | `show_creating_panel_dialog` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | DLOG 128 "Creating Instrument Panel" | — | 218 (2026-10-17) | dis.py on ID02.bin; ID09 glue; DLOG dump; token diff = renames |
| `FUN_00001e68` (ID02) | `release_sound_slots` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | 20 slots A5-0xd62: RecoverHandle(p - 0x14), HPurge, HUnlock | — | 218 (2026-10-17) | dis.py on ID02.bin; ID09 glue; DLOG dump; token diff = renames |
| `FUN_00001edc` (ID02) | `load_named_sound_into_slot` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | GetNamedResource snd, memory check 0x3000, purgeable, slot store | — | 218 (2026-10-17) | dis.py on ID02.bin; ID09 glue; DLOG dump; token diff = renames |
| `FUN_00001f8e` (ID02) | `load_game_sounds` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | loads 11 named sounds into slots; memory-dependent slot 0; error dialog | — | 219 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_000020be` (ID02) | `lock_sound_slots` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | HLock + slot = *h + 0x14 | — | 219 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_0000212a` (ID02) | `reset_overlay_state` | ID02 | RENAMED | HYPOTHESIS name | `ID02.c` | `ID02.decomp.c` | clears overlay data areas, calls overlay entry (A5-0x1388, TickCount) | — | 219 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_0000435e` (ID02) | `position_window_on_screen` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | centre horizontally, 1/3 down under the menu bar, MoveWindow | — | 219 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_00002192` (ID02) | `scan_display_devices` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` (halt_baddata) | `ID02.decomp.c` | main / right / left device records A5-0x1358 / -0x1342 / -0x132c | low-memory $0CB2 meaning | 220 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_000027e4` (ID02) | `configure_display_from_main_device` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | depth 1 / 4 / 8 check (STR# 116 alert), screen globals, menu-bar adjustment | layout routine 0x2334 | 221 (2026-10-17) | dis.py; STR# dump; token diff = renames |
| `FUN_000029f2` (ID02) | `refresh_display_if_changed` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | main device / depth change -> reconfigure, hook A5-0x1096 | — | 221 (2026-10-17) | dis.py; token diff = renames |
| `FUN_00002334` (ID02) | `layout_game_window_and_view` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` (halt_baddata) | `ID02.decomp.c` | view size option 1..4 (full, 1/2, 3/4, 1/4 width), menu bar hiding, NewCWindow, palettes, ID06 raster set-up | exact height arithmetic | 222 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_000030fa` (ID02) | `install_menus` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | MENU 1..5, Apple menu DRVR, DrawMenuBar | — | 223 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_00003174` (ID02) | `update_menu_items` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | FrontWindow DA test, enable / disable items | — | 223 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_00003590` (ID02) | `set_menu_item_enabled` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | EnableItem / DisableItem, DrawMenuBar for item 0 | — | 223 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_000035bc` (ID02) | `set_view_size_option` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | settings +0xe, relayout | — | 223 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_0000442e` (ID02) | `position_alert_template` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | JT $47a; centres ALRT template rect | — | 224 (2026-10-17) | dis.py on ID02.bin; CODE0 JT; token diff = renames |
| `FUN_00004582` (ID02) | `centre_window_on_screen` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | JT $472; MoveWindow centred | — | 224 (2026-10-17) | dis.py on ID02.bin; CODE0 JT; token diff = renames |
| `FUN_00004610` (ID02) | `detach_window_palette` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | SetPalette(window, NULL) | — | 224 (2026-10-17) | dis.py on ID02.bin; CODE0 JT; token diff = renames |
| `FUN_0000462c` (ID02) | `select_palette_for_depth` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | palette + RGB table per depth 1 / 4 / 8 | — | 224 (2026-10-17) | dis.py on ID02.bin; CODE0 JT; token diff = renames |
| `FUN_00002ee4` (ID02) | `copy_pascal_string` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | length byte + bytes | — | 225 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_000035e4` (ID02) | `start_new_mission` | ID02 | RENAMED | STRONG INFERENCE | `ID02.c` | `ID02.decomp.c` | roster + scenario dialogs, reset mission state, run_flight_session | — | 225 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_00004d6a` (ID02) | `handle_update_event` | ID02 | RENAMED | PROVEN | `ID02.c` | `ID02.decomp.c` | JT $492; Begin/EndUpdate around redraw_main_window; documents restore_screen_globals 0x4d96 | — | 225 (2026-10-17) | dis.py on ID02.bin; token diff = renames |
| `FUN_00000110`..`FUN_000001c2` (ID01, 6 functions) | `rt_udiv32`, `rt_umod32`, `rt_sdiv32`, `rt_smod32`, `rt_sdivmod32_core`, `rt_udivmod32_core` | ID01 | RENAMED | PROVEN | `ID01.c` | `ID01.decomp.c` | 32-bit divide runtime; header documents start-up, A5-world DATA / ZERO / DREL loading, switch helpers, multiply | — | 226 (2026-10-17) | dis.py on ID01.bin; token diff = renames |
| `FUN_00000334` | `any_mission_kills_recorded` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 12 kill words DAT_0001b5a0+0xba..+0xd0 | — | 227 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000003fa` | `load_player_fuel_and_bombs` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | fuel % +0xb6 -> two tanks +0x67d/+0x67e; bombs +0xb9 -> +0x67c | — | 227 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00000488` | `tally_destroyed_entity` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | kill counter +0xb8 + 2*type; friendly kills +0xd2 | — | 227 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000004f8` | `transform_through_node_chain` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hierarchical transform of an object through its parent nodes | — | 228 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000005fa` | `traverse_scene_tree` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | recursive scene graph walk with callback | — | 228 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000006a6` | `for_each_mission_scene_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | walk from the current mission scene root | — | 228 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000006ec` | `collect_map_features` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | scene visitor: land outlines (hook +0x292), type-0x70 list, facility 0x12/0x13 list | — | 229 (2026-10-17) | Ghidra C; DITL 137 legend; token diff vs HEAD = renames |
| `FUN_00000954` | `plot_mission_map_symbols` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | target of host A5-0x1052; plots A / B / C / T | — | 229 (2026-10-17) | Ghidra C; DITL 137 legend; token diff vs HEAD = renames |
| `FUN_0000b190` | `clip_polygon_x_min` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | Sutherland-Hodgman edge clip, x >= DAT_00020aee | — | 230 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_0000b242` | `clip_polygon_x_max` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | Sutherland-Hodgman edge clip, x <= DAT_00020aec | — | 230 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_0000b2f4` | `clip_polygon_y_min` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | Sutherland-Hodgman edge clip, y >= DAT_00020aea | — | 230 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_0000b3aa` | `clip_polygon_y_max` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | Sutherland-Hodgman edge clip, y <= DAT_0001b73e | — | 230 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00000aba` | `nearest_type80_centroid_visitor` | Pacific Conflict | RENAMED | STRONG INFERENCE mechanics | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | nearest face centroid of type-0x80 objects | role | 231 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00000bea` | `point_near_camera_or_type80_object` | Pacific Conflict | RENAMED | HYPOTHESIS name | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | metric thresholds 0x33900 / 0x40741 | role | 231 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00000c4c` | `anchor_point_visitor` | Pacific Conflict | RENAMED | STRONG INFERENCE mechanics | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | kind-1 node pose or nearest ground airfield point | role | 231 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00000d6a` | `find_anchor_point` | Pacific Conflict | RENAMED | HYPOTHESIS name | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | mode 0 / 1 over the scene | role | 231 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00000db0` | `ensure_handle_allocated` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | NewHandleClear / realloc when purged, HNoPurge via host services | — | 232 (2026-10-17) | Ghidra C + service table; token diff vs HEAD = renames |
| `FUN_00000e0a` | `lock_handle_nopurge` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | HLock + HNoPurge via host services | — | 232 (2026-10-17) | Ghidra C + service table; token diff vs HEAD = renames |
| `FUN_00000e32` | `unlock_handle_purgeable` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | HUnlock + HPurge via host services | — | 232 (2026-10-17) | Ghidra C + service table; token diff vs HEAD = renames |
| `FUN_00000e5a` | `lock_overlay_buffers` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | HLock of the four panel bitmap handles via host services | — | 232 (2026-10-17) | Ghidra C + service table; token diff vs HEAD = renames |
| `FUN_00000ea0` | `allocate_session_buffers` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | host hook A5-0x1082 | — | 233 (2026-10-17) | Ghidra C; hook table; token diff vs HEAD = renames |
| `FUN_00000f92` | `lock_session_buffers` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | host hook A5-0x107e | — | 233 (2026-10-17) | Ghidra C; hook table; token diff vs HEAD = renames |
| `FUN_00001094` | `unlock_session_buffers` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | host hook A5-0x1076 | — | 233 (2026-10-17) | Ghidra C; hook table; token diff vs HEAD = renames |
| `FUN_00001112` | `overlay_main_entry` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | installs the overlay hook table A5-0x10a2..-0x104e | — | 233 (2026-10-17) | Ghidra C; hook table; token diff vs HEAD = renames |
| `FUN_00003ac4` | `start_mission_scene` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x109a; scene entry, anchor point, camera | — | 234 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000739a` | `copy_player_pose_to_camera` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | camera position / angles from the player | — | 234 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00006598` | `overlay_frame_step` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x107a per frame; body partly decoded | — | 234 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00007310` | `begin_flight_for_rank` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x106e; rank table DAT_0001b2b4 | — | 234 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00006ed6` | `update_view_clip_bounds` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x109e; view half height, clip y-max DAT_0001b73e | — | 235 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000038f4` | `respawn_player_at_anchor` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x108a; player back on the nearest airfield | — | 235 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000740a` | `process_flight_input_and_outcome` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x106a; key switch (arrows, + -, digits, letters, P = 4, Esc = 3) and outcome code builder | per-key actions; outcome codes | 236 (2026-10-17) | Ghidra C outline; token diff vs HEAD = renames |
| `FUN_00006ff6` | `configure_renderer_for_display` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x10a2; view size and depth-specific renderer selection | depth-specific tables | 237 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00004210` | `refresh_object_colours_for_depth` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x1096; per-depth object colouring | — | 238 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000041ec` | `recolour_kind2_object` | Pacific Conflict | RENAMED | HYPOTHESIS name | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | kind-2 objects: FUN_00003da8 + FUN_00003ea0 | — | 238 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00004916` | `set_object_faces_bw_pattern` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | face +4 = host pattern table [index] | — | 238 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00003da8` | `update_object_distance_band` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | band +0x30 from thresholds DAT_0001b190 | — | 239 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00003e02` | `update_record_distance_band` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | same for record +4 | — | 239 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00003e5c` | `snapshot_face_colours` | Pacific Conflict | RENAMED | HYPOTHESIS name | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | copy face colours after the face list | — | 239 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00003ea0` | `shade_object_faces` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | flat shading with light vector, haze blend at depth 8 | — | 239 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000147a` | `queue_face_palette_entry` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | owner table + pending ColorSpec at host +0x72 | — | 240 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00001548` | `write_face_palette_slot` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | queue + mark slot on other monitors | — | 240 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000159e` | `assign_face_colour` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | depth 1 luminance pattern, depth 4 table, depth 8 dynamic palette slot (200, round-robin) | — | 240 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000011e6` | `widen_printf_format` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | %d -> %ld, %x -> %lx into DAT_00020b4c | — | 241 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00001254` | `overlay_printf` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | host service +0x262 (A5-0x1126) | — | 241 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00001294` | `reset_palette_owner_tables` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 0x400-byte owner tables per device | — | 241 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00001300` | `init_depth8_colour_state` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | depth-8 set-up | — | 241 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000131c` | `init_depth4_colour_state` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | depth-4 set-up from device records | — | 241 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000640c` | `spawn_cloud_layer` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hook A5-0x104e; ten camera-relative objects or retire type 0x1d | cloud reading | 242 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00019aa2` | `spawn_camera_relative_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | pool spawn at camera + offset | cloud reading | 242 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00019b30` | `follow_camera_offset` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | keep object at camera + offset | cloud reading | 242 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000018d6` | `overlay_initialise` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | RNG seed, subsystem init, light vector | — | 243 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00001958` | `heap_sbrk` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | arena = host A5-0x1040 work buffer | — | 243 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00001974` | `heap_new_size_class_block` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 1 << n bytes, header = class | — | 243 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_0000199a` | `heap_add_large_block` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | n * 8 bytes into the large-block list | — | 243 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000019b0` | `heap_add_large_block_tail` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | false split of heap_add_large_block | — | 243 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00003732` | `overlay_init_noop` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | empty | — | 244 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00003734` | `init_code_pointer_tables` | Pacific Conflict | RENAMED | STRONG INFERENCE mechanics | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | two 2048-entry code-address tables | — | 244 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00003266` | `init_span_table_32ba` | Pacific Conflict | RENAMED | STRONG INFERENCE mechanics | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | self-modifying table at 0x3242 | — | 244 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00003412` | `init_span_table_3466` | Pacific Conflict | RENAMED | STRONG INFERENCE mechanics | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | table at 0x33ee | — | 244 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000035b4` | `init_span_table_3608` | Pacific Conflict | RENAMED | STRONG INFERENCE mechanics | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | table at 0x3590 | — | 244 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_0001771a` | `set_view_distance` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | range + 2 * range | — | 244 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00017736` | `cycle_view_distance` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | Tab key: 0xc15c0 / 0x26ac0 / 0xce40 | — | 244 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000032ba` | `fill_span_rows_4bit_a` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | depth-4 run-list span filler | variant differences | 245 (2026-10-17) | Ghidra C; renderer selection in configure_renderer_for_display; token diff vs HEAD = renames |
| `FUN_00003466` | `fill_span_rows_4bit_b` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | variant b | variant differences | 245 (2026-10-17) | Ghidra C; renderer selection in configure_renderer_for_display; token diff vs HEAD = renames |
| `FUN_00003608` | `fill_span_rows_4bit_c` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | variant c | variant differences | 245 (2026-10-17) | Ghidra C; renderer selection in configure_renderer_for_display; token diff vs HEAD = renames |
| `FUN_000037b4` | `fill_span_rows_8bit` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | depth-8 span filler via the 2048-entry code tables | — | 246 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00001b4c` | `heap_zero_payload_tail` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | false split | — | 246 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00001be4` | `heap_realloc_grow_only_tail` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | false split | — | 246 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00001c04` | `copy_object_vertex_buffer` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | +0x44 -> +0x4c, 12-byte vertices | — | 246 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00002e12` | `noop_stub_2e12` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | empty | — | 247 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00004e06` | `reset_object_to_template_pose` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | position from the scene template, template chain transform | — | 247 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00004e4e` | `reset_object_to_template_pose_tail` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | false split | — | 247 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_00006e74` | `reset_span_row_lists` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | one background span per row | — | 248 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00006ece` | `clear_flag_00020ae4` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | one store | — | 248 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000823e` | `process_flight_input_tail` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | false split of the key handler | — | 248 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00008784` | `set_state_word_1b86c` | Pacific Conflict | RENAMED | HYPOTHESIS name | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 2 / 1 by argument | — | 248 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00005832` | `dispatch_overlap_collisions` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 1-D sweep over metric +/- radius, type handler +0x16 | — | 249 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000058ec` | `build_visible_object_list` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | view-space transform and pyramid cull into DAT_0001c9dc | — | 249 (2026-10-17) | complete Ghidra C; token diff vs HEAD = renames |
| `FUN_000053f8` | `collect_near_objects` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | active array: view candidates, deactivation / retirement | — | 250 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000555a` | `collect_far_objects` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | world array: view candidates, collision list | — | 250 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00005a14` | `update_altitude_detail_bands` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | power-of-two altitude band; land outline rebuild | DAT_0001bdac / DAT_0001bdb0 shape roles | 251 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00004958` | `build_land_outline_at_detail` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | tolerance-simplified, clipped, de-duplicated outline | shift / limit argument roles | 251 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00005e28` | `update_ground_scatter_objects` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 64 ground points near a low camera; up to 7 scenery objects | option +0xac meaning | 252 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000052dc` | `deactivate_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | frees shape buffers / group child list | FUN_00014af2 role | 252 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013346` | `surface_type_at_point` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | face code under (x, z), default DAT_0001bda8+0x16 | FUN_0001320a / FUN_00013070 internals | 252 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013070` | `point_in_polygon_xz` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | even-odd crossing test, words +2 / +10 | — | 253 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001310e` | `point_in_polygon_yz` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | same on words +6 / +10 | called by point_in_face_by_axis (iteration 262) | 253 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001320a` | `project_face_vertices_xz` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | shifted, origin-relative x / z | — | 253 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000131ac` | `project_face_vertices_xy` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | x / y variant | called by point_in_face_by_axis (iteration 262) | 253 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013268` | `project_face_vertices_yz` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | y / z variant | called by point_in_face_by_axis (iteration 262) | 253 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00014af2` | `release_fractal_reference` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | refcounted shared block at +0x2c ("Deactivating Fractal") | _DAT_0001c1bc role | 253 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000132c8` | `point_over_face_xz` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | entity x / z inside a face (result dropped by Ghidra) | no caller in exported C | 254 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00014bea` | `carry_attached_objects` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | rotate / lower nearby type 7 / 8 / 0x1a / 0x1b entities with an object | ship reading [HYPOTHESIS] | 254 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001562e` | `clip_polygon_y_nonneg` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | Sutherland-Hodgman clip at y = 0 | — | 255 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00015762` | `sink_object_shape_at_waterline` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | rotate / lower template shape, clip faces at y = 0, 1 if anything remains | — | 255 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00014d86` | `step_sinking_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | timed angle / drop steps, removal and mission flags when sunk | controller layout partly inferred | 255 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00015580` | `create_sinking_controller` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 0x56-byte controller, definition DAT_0001b524[key] | how the controller is linked / called | 256 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000155d8` | `tick_sinking_controller` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | step when word +0x4c set | caller (handler table) | 256 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00014f48` | `apply_hit_to_sinkable_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | hit counter +0x32; list / capsize rates; 15 steps after 30 frames | 1-hit branch structure | 257 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001530e` | `create_firing_ship_controller` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 300-byte record, 20 shots | caller | 257 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00015356` | `tick_firing_ship_controller` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | gun faces (+0x17 == 1), 1/256 random fire, else sinking | AA reading [HYPOTHESIS] | 257 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000150c8` | `create_flagship_controller` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | create entry of type 0x15 (3 hits); first kept in _DAT_0001b864 | which ship [HYPOTHESIS] | 258 (2026-10-17) | Ghidra C + definition table bytes; token diff vs HEAD = renames |
| `FUN_000155ec` | `create_basic_ship_controller` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | create entry of types 0x18 / 0x17 | — | 258 (2026-10-17) | Ghidra C + definition table bytes; token diff vs HEAD = renames |
| `FUN_000092e4` | `advance_frame_and_tick_controllers` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | frame counter, time-window flags, controller ticks (definition +2) | DAT_0001b870 states | 259 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000947c` | `apply_controller_velocities` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | position += controller velocity (+6 & 0x20) | — | 259 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000094d2` | `tick_flagged_object_controllers` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | DAT_0001b870 == 3 variant, objects +5 & 4 only | state 3 meaning | 259 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001429c` | `handle_player_contact` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | player overlap → contact record, definition +0x12 handler | FUN_000135a0 / 135e8 / 14198 | 259 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001358c` | `contact_pair_hash` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | a ^ (b << 2), low byte | — | 260 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000135a0` | `find_contact_record` | Pacific Conflict | RENAMED | PROVEN | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 256-slot linear probe of DAT_0001bdbc | — | 260 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000135e8` | `create_shape_contact_record` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | per-face record for plain shapes | face entry fields | 260 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001383c` | `create_fractal_contact_record` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 0x3e-byte record for fractal objects | — | 260 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013980` | `fractal_height_at` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | height from fractal data at (x, z) | interpolation details | 260 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00014198` | `handle_terrain_contact` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | player ground height → controller +0x2e | — | 260 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013ee0` | `test_object_collision` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | face-plane crossing test via contact records | FUN_0001665a, FUN_0001346c | 261 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013cdc` | `test_terrain_collision` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | below fractal ground → collision | FUN_00014830 | 261 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013e4e` | `test_proximity_collision` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | both 0x100000, 3/4 distance < range | — | 261 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013eae` | `test_player_vs_type0e_proximity` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | player vs template type 0xe | type 0xe identity | 261 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00014348` | `dispatch_collision` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | definition +0x12 handlers; pair table DAT_0001b43c | handler 0x14346 | 262 (2026-10-17) | Ghidra C (+ pair table bytes); token diff vs HEAD = renames |
| `FUN_0001346c` | `point_in_face_by_axis` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | axis code 0 / 1 / 2 → yz / xz / xy test | axis word source (in_stack) | 262 (2026-10-17) | Ghidra C (+ pair table bytes); token diff vs HEAD = renames |
| `FUN_00012fd2` | `point_in_polygon_xy` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | even-odd test on +2 / +6 | — | 262 (2026-10-17) | Ghidra C (+ pair table bytes); token diff vs HEAD = renames |
| `FUN_000167f4` | `bullet_hits_aircraft` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 0xe vs 1..4: 1/8 damage + retire | — | 263 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001665a` | `bullet_hits_shape` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | retire bullet; type 0x1b 1/16 flag | controller +0x3c use | 263 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00016724` | `apply_random_aircraft_damage` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | random damage bit in +0x684 (flags_685) | meaning of each bit | 263 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000095ac` | `play_game_sound` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | priority play on channel 1 via host play_sample_on_channel | switch grouping | 264 (2026-10-17) | Ghidra C + host A5 mapping; token diff vs HEAD = renames |
| `FUN_000096ae` | `stop_game_sound` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | release_channel_loop when current | — | 264 (2026-10-17) | Ghidra C + host A5 mapping; token diff vs HEAD = renames |
| `FUN_000096f4` | `update_game_sounds` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | event flags → sounds; engine pitch on channel 0 | event meanings | 264 (2026-10-17) | Ghidra C + host A5 mapping; token diff vs HEAD = renames |
| `FUN_00011c58` | `spawn_effect` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | effect pool object, kind init table, explosion sound countdowns, 16-entry event log | log use (replay?) | 266 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00010650` | `update_aircraft_damage_state` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | damage stages → smoke / fire effects; player bit 0 → pilot Dead + Ugh | stage bits 6..9 exact | 266 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00011b96` | `replay_logged_effects` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | re-spawns logged effects of the current frame | — | 267 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_00011c2c` | `mark_effect_log_end` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 0x7fffffff sentinel in the effect log | — | 267 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_00011b48` | `register_effect_template` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | create handler: effect template slots DAT_0002626e[0..3] | FUN_00011afe role | 267 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_0001203a` | `init_effect_kind0_flat_ring` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 6-vertex expanding ring | visual identity | 268 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000120ca` | `init_effect_kind1_column` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 3 spreading + 1 rising vertex | splash? [HYPOTHESIS] | 268 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00011efc` | `init_effect_kind2_burst` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 12-vertex random burst | — | 268 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001217e` | `init_effect_kind3_debris_explosion` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | burst + 13 debris vertices | +0x36 / +0x33 use | 268 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00012768` | `tick_effect` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | animator, lifetime +0x36, retire | — | 269 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_000123ce` | `animate_effect_kind0_ring` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | ring; spawns kind 1 at lifetime 0x47 | — | 269 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_00012466` | `animate_effect_kind0_ring_tail` | Pacific Conflict | RENAMED | PROVEN (false split) | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | tail of 0x123ce | — | 269 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_00012486` | `animate_effect_kind1_column` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | rising vertex with gravity | — | 269 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_00012296` | `animate_effect_kind2_burst` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | halving velocities, colour fade | FUN_000115fc | 269 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_00012528` | `animate_effect_kind3_debris` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | debris with gravity until grounded | FUN_000175de | 269 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_00012738` | `face_object_to_camera` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | billboard attitude | — | 269 (2026-10-17) | Ghidra C + table bytes; token diff vs HEAD = renames |
| `FUN_000127aa` | `effect_pre_render_hook` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | definition +0xe of key 8; kind 2 billboard | — | 270 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_000115fc` | `spawn_smoke_plume` | Pacific Conflict | RENAMED | HYPOTHESIS | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | timed plume from template DAT_000260e8 | visual identity | 270 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_000115da` | `register_smoke_template` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | create handler storing DAT_000260e8 | FUN_000115b0 | 270 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_00011670` | `attach_trailing_plume` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | plume with 8 trail points linked to an aircraft | — | 270 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_000175de` | `spawn_ground_mark` | Pacific Conflict | RENAMED | HYPOTHESIS | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 6-vertex scaled mark, expires after 2700 frames | visual identity | 270 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_0000a75e` | `transform_and_project_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | pre-render hook, object→camera matrix, transform + project used vertices | — | 271 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000a676` | `project_prepared_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | project already transformed vertices | who fills +0x4c | 271 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000ac72` | `render_visible_objects` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | three render passes; polygon emit FUN_00009ef8 / 9da6, flush FUN_0000a2f2 | pass details | 271 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00009ae0` | `face_is_back_facing` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | normal · (camera − v0) < 1 | — | 272 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00009da6` | `emit_faces_bsp` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | back-to-front BSP traversal | — | 272 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00009d34` | `emit_face_chain` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | chain +0x12 emission | — | 272 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00009ef8` | `emit_faces_in_order` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | root faces + chains | — | 272 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00009fc4` | `emit_faces_unnumbered` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | as above, no draw order | — | 272 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000a2f2` | `submit_object_faces` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | clip / output / camera-penetration collision | FUN_0000b028, FUN_0000a512, *DAT_00020ab4 | 272 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000a512` | `transform_face_vertices` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | lazy per-vertex transform + projection | — | 273 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000b028` | `clip_face_near_plane` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | clip at z = 5, project intersections | — | 273 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000a16e` | `output_face_colour` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | screen clip → FUN_00009b8c | FUN_0000a07e | 273 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000a220` | `output_face_bw` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | screen clip → host add_polygon_edges | — | 273 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00009b8c` | `add_face_edges_to_rows` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | edge records into row buckets DAT_0001eaac | — | 274 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000a07e` | `track_ground_plane_horizon` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | ground-plane corners + horizon edge | users of DAT_0001bd90 / 0001bda0.. | 274 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000b4b6` | `draw_sky_and_ground` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | horizon edge → sky / ground background fill | fill loop details | 275 (2026-10-17) | Ghidra C (partial read for 0xb4b6); token diff vs HEAD = renames |
| `FUN_0000b460` | `reset_background_rows` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | default span per row | — | 275 (2026-10-17) | Ghidra C (partial read for 0xb4b6); token diff vs HEAD = renames |
| `FUN_00002e14` | `scan_convert_edge_rows` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | active edge list per row, draw-order resolve, runs to DAT_0001b794 / 798 | inner loop not yet annotated block by block (degraded Ghidra C) | 276 (2026-10-17) | Ghidra C structure + globals; token diff vs HEAD = renames |
| `FUN_0000d00c` | `update_view_readouts_and_overlays` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 4 numeric readouts via host +0x27a, or sky + HUD drawers | readout 3; FUN_0000ba2a..ccca roles | 277 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001443a` | `sort_group_parts_by_distance` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | distance sort, haze blend (0x7d, 0x84, 0xa8), draw order | — | 277 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000c572` | `draw_gauge_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | erase / redraw a needle line, cached ends | — | 278 (2026-10-17) | Ghidra C + instrument record offsets; token diff vs HEAD = renames |
| `FUN_0000c664` | `update_altimeter_needles` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 0, two hands | FUN_00001db8 / 1d56 register args | 278 (2026-10-17) | Ghidra C + instrument record offsets; token diff vs HEAD = renames |
| `FUN_0000c80c` | `update_airspeed_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 1, +0x62a | — | 278 (2026-10-17) | Ghidra C + instrument record offsets; token diff vs HEAD = renames |
| `FUN_0000c8d6` | `update_direction_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 6, camera heading | — | 278 (2026-10-17) | Ghidra C + instrument record offsets; token diff vs HEAD = renames |
| `FUN_0000c948` | `update_climb_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 3, DAT_0001bc80 | — | 278 (2026-10-17) | Ghidra C + instrument record offsets; token diff vs HEAD = renames |
| `FUN_0000c9c2` | `update_tachometer_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 5, +0x66a RPM | — | 278 (2026-10-17) | Ghidra C + instrument record offsets; token diff vs HEAD = renames |
| `FUN_0000ca44` | `update_manifold_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 4, +0x672 | — | 278 (2026-10-17) | Ghidra C + instrument record offsets; token diff vs HEAD = renames |
| `FUN_0000cc12` | `update_flaps_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | +0x67b | flaps vs gear assignment by needle count | 279 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000ccca` | `update_gear_needles` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | +0x679, three needles | — | 279 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000ce1c` | `update_ammo_needle` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | +0x682 | — | 279 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000cec4` | `update_fuel_needles` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | +0x67d / +0x67e | — | 279 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00017b68` | `update_radar_scope` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | heading-up blips from DAT_0001b51c | which objects are tracked | 279 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_000176b2` | `add_radar_track` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | ≤ 6 tracks within 2 × range | callers | 280 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001776a` | `reset_radar_tracks` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | clears track / blip counts | — | 280 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000c1aa` | `update_heading_tape` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | strip scrolled by heading | copy loop details | 280 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000ba2a` | `draw_panel_frame_lines` | Pacific Conflict | RENAMED | HYPOTHESIS | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | colour runs at host +0x238..+0x258 | what the lines are | 280 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000fe96` | `aircraft_notice_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | definition +0x16 of aircraft: radar tracks, AI target acquisition | AI states 0x110d4 / 0x11162 | 281 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_0000b49e` | `reset_overlay_display_state` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | radar / background / tape caches reset | — | 281 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_0000e0a4` | `aircraft_destroy` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | free +0x616, release target | — | 282 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_0000e0ce` | `aircraft_create` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | player vs AI set-up, bombs, fuel | FUN_0000dff0, FUN_00018956 | 282 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_0000e5aa` | `aircraft_tick` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | state handler + 75-frame replay ring | — | 282 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_0000fe0a` | `aircraft_collision` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | damage bit 0x400 on both; ships FUN_00012b66 | — | 282 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_000110f4` | `ai_attack_or_fly` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | pursue target (FUN_0001820a) or fly | — | 282 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_00011182` | `ai_fly` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | per-kind fly handler DAT_0001b3f4 | — | 282 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_0000dff0` | `init_aircraft_controller` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 0x6b0-byte controller defaults (ammo 675, bombs 2, gear down, gravity -0x5b) | — | 283 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000df5e` | `fill_pose_history` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | 75 replay entries = start position | — | 283 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000fb2a` | `animate_landing_gear` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | gear faces hidden / rotated from +0x679 | LAB_00002440_4 matrix builder | 283 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0000f810` | `player_slew_mode` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | control-S toggled free-move state handler | purpose (debug?) | 284 (2026-10-17) | Ghidra C + entry bytes; token diff vs HEAD = renames |
| `FUN_00012b66` | `apply_blast_damage` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | radius damage to world objects; tally with credit | stack args; other callers | 285 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00018956` | `spawn_object_shadow` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | ground object linked to an aircraft; option +0xb0 | — | 285 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_0001820a` | `ai_pursue_target` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | aim at the target pose N frames ago (rank lag); manoeuvre states | second half of the function | 285 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00011db4` | `spawn_destruction_effect` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | air burst / water splash / ground debris by surface | surface codes other than 0x10 | 286 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00013452` | `surface_type_under_object` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | surface code at the object position | — | 286 (2026-10-17) | Ghidra C; token diff vs HEAD = renames |
| `FUN_00012a2a` | `bomb_tick` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 0xc tick with replay ring | FUN_000128b6 motion | 287 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_00012d34` | `bomb_detonation` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | impact effect, target / friendly counters, delayed blast | FUN_00016b9e | 287 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_00018c96` | `tick_flak_gun` | Pacific Conflict | RENAMED | STRONG INFERENCE | `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | type 0x1a: scheduled flak bursts + blast damage | targeting maths | 287 (2026-10-17) | Ghidra C + definition bytes; token diff vs HEAD = renames |
| `FUN_00000728` (ID05) | `ansi_rand` | ID05 | RENAMED | PROVEN | `ID05.c:130-137` | `ID05.decomp.c` | seed A5−0x6c | — | 118 (2026-10-16) | LCG constants match bytes (MULU.L/ADDI.L); token diff = renames |
| `FUN_00000746` (ID05) | `ansi_srand` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:141-148` | `ID05.decomp.c` | seed A5−0x6c | No callers found | 118 (2026-10-16) | Token diff = renames |
| `FUN_000007f6` (ID05) | `poison_overlay_bytes` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:191-207` | `ID05.decomp.c` | `ansi_rand`; table A5−0xb4; caller ID08 0x246 | Copy-protection purpose HYPOTHESIS | 118 (2026-10-16) | DIVUL.L decoded (68020); JT $53a resolved |
| `FUN_0000085e` (ID05) | `restore_poisoned_overlay_bytes` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:211-232` | `ID05.decomp.c` | table A5−0xb4; gates A5−0xbc/−0xc0; caller ID08 0x29e | Gate writers unknown | 118 (2026-10-16) | JT $55a resolved; single caller |
| `FUN_00000934` (ID05) | `record_code_index_equals` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:261-268` | `ID05.decomp.c` (header also documents unexported 0x964 routine and 0x8b2 stub) | ID08 callers 0x282/0x2b2; gates A5−0xbc/−0xc0 | Table contents A5−0xba; key A5−0x2c; n/rec origin | 119 (2026-10-16) | Bytes match C; token diff = renames; 32 hashes OK |
| `FUN_00000754` (ID05) | `encode_base26_6chars` | ID05 | RENAMED | PROVEN | `ID05.c:152-168` | `ID05.decomp.c` | callers 0xb00/0xb98/0xbce | Purpose of encoded values | 120 (2026-10-16) | DIVS.L #26 bytes; token diff = renames |
| `FUN_000007a8` (ID05) | `decode_base26_6chars` | ID05 | RENAMED | PROVEN | `ID05.c:172-187` | `ID05.decomp.c` | callers 0xb1c/0xbb4/0xbea | — | 120 (2026-10-16) | MULU.L #26 bytes; token diff = renames |
| `FUN_00000a62` (ID05) | `random_28bit_value` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:278-287` | `ID05.decomp.c` | caller 0x442 | Field semantics | 121 (2026-10-16) | C mechanics; callers by byte scan; token diff = renames |
| `FUN_00000a90` (ID05) | `pack_fields_to_code_buf68` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:291-306` | `ID05.decomp.c` | caller 0x498; buf A5−0x68 | Field semantics | 121 (2026-10-16) | C mechanics; callers by byte scan; token diff = renames |
| `FUN_00000b10` (ID05) | `unpack_fields_from_code` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:310-323` | `ID05.decomp.c` | no caller found | Field semantics | 121 (2026-10-16) | C mechanics; callers by byte scan; token diff = renames |
| `FUN_00000b84` (ID05) | `encode_code28_to_buf54` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:327-334` | `ID05.decomp.c` | ID05 0x4b2; ID08 0x276/0x2a6 (JT $552) | Field semantics | 121 (2026-10-16) | C mechanics; callers by byte scan; token diff = renames |
| `FUN_00000ba8` (ID05) | `decode_code_to_long_a` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:338-345` | `ID05.decomp.c` | no caller found | Field semantics | 121 (2026-10-16) | C mechanics; callers by byte scan; token diff = renames |
| `FUN_00000bc2` (ID05) | `encode_long_to_buf40` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:349-356` | `ID05.decomp.c` | caller 0x4ce | Field semantics | 121 (2026-10-16) | C mechanics; callers by byte scan; token diff = renames |
| `FUN_00000bde` (ID05) | `decode_code_to_long_b` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:360-367` | `ID05.decomp.c` | caller 0x674 | Field semantics | 121 (2026-10-16) | C mechanics; callers by byte scan; token diff = renames |
| `FUN_000002c8` (ID05) | `code_dialog_filter` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:99-104` | `ID05.decomp.c` (header: routine A filter + unexported routine B 0x3ba code builder) | Dialog traps; codec wrappers; FUN_000000c8/0214/0270; ID09 GetVol/p2cstr; ID02 strcmp/strcpy | Routine B caller; A5−0xca / −0xd66 strings; FUN_00000214/0270 roles | 122 (2026-10-16) | Capstone 68020; token diff = renames; 32 hashes OK |
| `FUN_00000160` (ID05) | `read_DATA128_pair` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:51-58` | `ID05.decomp.c` | GetResource/HNoPurge/HPurge/ReleaseResource; callers ID08 0x26c (JT $582) | Meaning of the two longs | 123 (2026-10-16) | Capstone; JT/BSR scan; token diff = renames |
| `FUN_000001bc` (ID05) | `write_DATA128_pair` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:64-69` | `ID05.decomp.c` | GetResource/HNoPurge/HPurge/ReleaseResource; callers ID08 0x2c4 (JT $57a) | Meaning of the two longs | 123 (2026-10-16) | Capstone; JT/BSR scan; token diff = renames |
| `FUN_00000214` (ID05) | `read_TEXT128_pair` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:75-82` | `ID05.decomp.c` | GetResource/HNoPurge/HPurge/ReleaseResource; callers ID05 0x3f4, 0x458 | Meaning of the two longs | 123 (2026-10-16) | Capstone; JT/BSR scan; token diff = renames |
| `FUN_00000270` (ID05) | `write_TEXT128_pair` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:88-93` | `ID05.decomp.c` | GetResource/HNoPurge/HPurge/ReleaseResource; callers ID05 0x44a, 0x718 | Meaning of the two longs | 123 (2026-10-16) | Capstone; JT/BSR scan; token diff = renames |
| `FUN_00000006` (ID05) | `center_template_rect_on_screen` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:12-19` | `ID05.decomp.c` | GetResource; screenBits A5−0x1680..−0x167a; GetMBarHeight (ID09 0x19c) | Callers; template type | 124 (2026-10-16) | Capstone; token diff = renames |
| `FUN_000000c8` (ID05) | `get_machine_screen_fingerprint` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:23-45` | `ID05.decomp.c` | SysEnvirons; GetGDevice ($AA32) pixmap; screenBits | — | 124 (2026-10-16) | Capstone; truncated colour branch documented |
| `FUN_000004e4` (ID05) | `get_dialog_item_text_upper` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:110-115` | `ID05.decomp.c` | GetDItem/GetIText; ctype A5−0x1608; ID02 FUN_000001ce | toupper confirmation | 125 (2026-10-16) | Capstone; token diff = renames |
| `FUN_00000560` (ID05) | `run_protection_dialog` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:121-126` | `ID05.decomp.c` | DLOG 1000 / ALRT 1001; code_dialog_filter; matcher 0x964; DATA/TEXT pairs; caller ID08 0x298 (JT $572) | Field UI meaning; table source | 125 (2026-10-16) | Capstone; JT resolution; token diff = renames |
| `FUN_000008d6` (ID05) | `pick_random_protection_challenge` | ID05 | RENAMED | STRONG INFERENCE | `ID05.c:244-257` | `ID05.decomp.c` | ansi_rand; table A5−0xba/−0xb6 | — | 125 (2026-10-16) | C + caller 0x5a6 |

All other inventoried functions: **NOT_STARTED** (see inventory JSON).

## Iteration log

### Iteration 1 — 2026-10-15

- Created all ten `*.decomp.c` outputs by copying immutable `.c` sources.
- Recorded SHA-256 of 32 protected originals.
- Inventoried **731** Ghidra `FUN_*` / related definitions across ten C files.
- Reconstructed `FUN_00000020` → `overlay_patch_template_u16_pair`.
- Corrected prior “loader base” framing: call sites pass `0x195` / `0x1d5`; binary is two `MOVE.W` stores 0x4A apart.

**Next iteration target:** `FUN_0000e792` Block 1 — `flags_685` RNG perturbation on `0x662`/`0x666` (continues `update_aircraft_entity`).

### Iteration 2 — 2026-10-15

- Reconstructed `FUN_00000032` → `copy_block_return_dst`.
- Proven 68k wrapper: `(dst, src, n)` → `FUN_0001a63e(src, dst, n)`; returns `dst`.
- Renamed 23 in-overlay call sites (all inside / around `FUN_00000054`).

### Iteration 3 — 2026-10-15

- Renamed `FUN_00000054` → `overlay_init_template_pointer_tables`.
- Annotated Block A (4 × `0x4A` clones): proven walk from `0x1A790`, slot store `(A5, A0.L*4)` with `A5=DAT_0001b524`.
- Flagged `FUN_00001a48` as incomplete in Ghidra (no D0 write, yet callers use D0 as dest).

### Iteration 4 — 2026-10-15

- Proven `$1A48` is mid-label of `FUN_000019d0` (heap free/coalesce), not malloc.
- Renamed `FUN_000019d0` → `heap_free_coalesce`, `FUN_00001a48` → `heap_roving_cursor_store` (**BLOCKED** ABI), `FUN_00001a68` → `heap_alloc`.
- Documented call-site conflict: JSRs to `$1A48` use malloc-like D0 convention the bytes do not implement.

### Iteration 5 — 2026-10-15

- Annotated `FUN_00000054` Blocks B–D: 16 fixed slots (`0x1A`/`0x20`), 5×`0x1C` keyed clones, 5 trailing `0x1A` slots.
- Proven `PEA $20.W` length (not address-of `FUN_00000020`); full src→`DAT_0001b538`…`1b59c` map.

### Iteration 6 — 2026-10-15

- Renamed `FUN_000016e2` → `init_mission_object_tables`.
- Proven flow: template init → resolve root via `FUN_00004690` → `heap_alloc` child×`0x18` table → relocate/resolve children → publish globals.

### Iteration 7 — 2026-10-15

- Renamed `FUN_00004690` → `instantiate_object_from_desc` (template factory at `DAT_0001b524[type]+6`).
- Renamed `FUN_000045ba` → `alloc_object_from_desc` (kinds 2→0x52, 3→0x34).
- Renamed `FUN_00001b6c` → `heap_alloc_cleared`.

### Iteration 8 — 2026-10-15

- Renamed `FUN_00001b38` → `heap_zero_payload` (header-derived size).
- Renamed `FUN_0001a716` → `memzero` (CLR.B/CLR.L fill) — **PROVEN**.

### Iteration 9 — 2026-10-15

- Renamed `FUN_000044e8` → `run_simulation_tick`.
- Proven four-pass entity dispatch (path args 0,0,1,1) + mission gates; aligns with `tick_FUN_000044e8_contract.md`.

### Iteration 10 — 2026-10-15

- Renamed `FUN_000044a4` → `dispatch_entity_tick`.
- Renamed `FUN_0000435a` → `apply_entity_mission_rates` (phase-scaled table rates; path-0 kind-2 subloop).

### Iteration 11 — 2026-10-15

- Renamed `FUN_00005df8` → `clear_pending_entity_slots` (7× `DAT_0001bc64` + `FUN_0000528a`).
- Renamed `FUN_00006fb8` → `reset_distance_base_globals` (six stores of `100000000`).

### Iteration 12 — 2026-10-15

- Renamed `FUN_0000e792` → `update_aircraft_entity`.
- Annotated Block 0: prologue, template `field_40` adjust, contact early-out (status bit → return).

### Iteration 13 — 2026-10-15

- Annotated `update_aircraft_entity` Block 1: `flags_685` bit2/bit3 RNG jitter on `movement_662`/`movement_666` with abs clamps; status bit0 force `{0,0xFF80}`.
- Annotated Block 1b: `movement_669` gate, `status_1a0` accumulate vs template `+0x1e`, optional `67d`/`67e` decrement via `FUN_00011564`.
- Confidence: **PROVEN** for control-flow and constants (binary @0xE8A0–0xE9xx / NOTES); semantic roles of 662/666 remain STRONG INFERENCE labels from flight contract.

### Iteration 14 — 2026-10-15

- Renamed helper trio: `FUN_0000e42a`→`table_lerp_1b2c0`, `FUN_0000e468`→`damp_short_if_below_0x200`, `FUN_0000e570`→`scale_template_field_38`.
- Annotated Block 2a (prep + `local_34`) and Block 2b (designated-entity `0x66e`/`0x672`/`0x66a` smoothing + `0x669` clear).
- Noted: `local_46` uses literal `0x666`, not entity `+0x666`; e468 output distinct from raw e42a.

### Iteration 15 — 2026-10-15

- Annotated Block 3a: `movement_626` speed step for all entities (0xCA8 branch, template `+0x34/+0x36/+0x44`, gain from `iVar20`).
- Annotated Block 3b: reverse-flight clamps when `field_63e!=0` && `dir_679=='-'`; `local_48` recompute; player clears `DAT_0001b858`; `attitude_22` (`local_2a`) update.
- Confidence: **PROVEN** formulas (contract/NOTES); physical meaning of 626 still STRONG INFERENCE (speed-like accumulator).

### Iteration 16 — 2026-10-15

- Renamed `FUN_0000e4a4` → `compute_template_force_from_626`.
- Annotated Block 4a (force→`0x63a` via `field_19e`), 4b (e468 linear + quadratic drag), 4c (`0x636` thrust, grounded `0x18e`, stall/`field_190`/`DAT_0001b868`).
- Noted `FUN_0000e512` as likely Ghidra register-spill twin (untouched).

### Iteration 17 — 2026-10-15

- Renamed `FUN_000025a8`→`build_attitude_matrix`, `FUN_000028dc`→`transform_vecs12_by_matrix3`.
- Annotated Block 5a (matrix + position commit `param_1[2..4]`) and Block 5b (`field_63e` touchdown / leave-ground + pitch follow-on).

### Iteration 18 — 2026-10-15

- Renamed `FUN_0000e372`→`isqrt_floor`, `FUN_00001f22`→`attitude_from_velocity`.
- Annotated Block 6a (airborne recommit), 6b (grounded `field_0b` switch), 6c (`LAB_0000f47c` attitude/speed epilogue).

### Iteration 19 — 2026-10-15

- Annotated Block 7a (`67b`/`679` char epilogue), 7b (weapon phases `19d`/`676`/`677` → `12840`/`15d20`/`19430`), 7c (`flags_685&2` ammo + `bVar6` rough-landing cleanup).
- Primary control-flow of `update_aircraft_entity` now annotated end-to-end (Blocks 0–7c). Not VERIFIED.

### Iteration 20 — 2026-10-15

- Renamed `FUN_00011564`→`overlay_rng_next`, `FUN_000114ca`→`overlay_rng_mul_mix`, `FUN_0001150a`→`overlay_rng_init`.
- Documented `FUN_00011544` bytes as `overlay_rng_warmup_epilogue`; rewrote Ghidra-labeled call sites to `overlay_rng_next` **[INFERRED≡next]** per NOTES/binary LEA evidence.

### Iteration 21 — 2026-10-15

- Renamed `FUN_0000528a`→`dispatch_entity_cleanup`, `FUN_000051ec`→`retire_entity`.
- Annotated gate/branches and full retirement side effects; updated `clear_pending_entity_slots` comments.

### Iteration 22 — 2026-10-15

- Renamed `FUN_00005116`→`spawn_mission_pool_object`, `FUN_00012840`→`spawn_weapon_entity`.
- Annotated free-slot scan/fill/gate and weapon post-spawn field writes (`0x610`/`0x61c`/`+0x20..24`).

### Iteration 23 — 2026-10-15

- Renamed `FUN_00015d20`→`spawn_ordnance_oriented`, `FUN_00015bf6`→`spawn_ordnance_scattered`, `FUN_0000262e`→`build_attitude_matrix_x`.
- Annotated matrix→RNG scatter→`DAT_0002664a` pool spawn path for field_676 ordnance.

### Iteration 24 — 2026-10-15

- Renamed `FUN_00019430`→`spawn_special_weapon_entity`.
- Annotated pool spawn via `DAT_00026780`, field writes (`610`/`614`/`618`/`61c`), and 0xD-vertex `>>3` scale loop into `0x622`/`656`/`68a`.
- e792 weapon trio (`12840`/`15d20`/`19430`) now all renamed.

### Iteration 25 — 2026-10-15

- Renamed `FUN_0000e40c`→`fold_angle_pm_0x2000` (fold into [-0x2000,+0x2000] via ±0x4000).
- Used by e792 landing gentleness, LAB_0000f47c yaw blend, and many attitude deltas.

### Iteration 26 — 2026-10-15

- Renamed `FUN_0001a63e`→`memmove_block` (src,dst,n; overlap-aware forward/backward copy).
- Updated `copy_block_return_dst` / `spawn_ordnance_scattered` references; clarified `&DAT_00000012` ≡ length `0x12`.

### Iteration 27 — 2026-10-15

- Renamed `FUN_00001ba8`→`heap_realloc_grow_only`, `FUN_00001b84`→`heap_calloc`.
- Annotated header-capacity check, grow-only realloc (alloc+copy+free), used by mission pool +10.

### Iteration 28 — 2026-10-15

- Renamed `FUN_000046da`→`instantiate_mission_pool_slot`.
- Annotated desc resolve → alloc → identity → optional factory → rates → distance gate (`04e6e` vs deferred queue).

### Iteration 29 — 2026-10-15

- Renamed `FUN_00002e08`→`abs_int` (signed 32-bit absolute value).
- Updated ~48 call sites; used throughout flight clamps / magnitude gates.

### Iteration 30 — 2026-10-15

- Annotated `FUN_00002de8`: Ghidra false entry at mid-epilogue of `FUN_00002d10` (xyz commit when D3/D4 zero).
- Call sites (19× LEA+JSR) behave as `abs_int` [INFERRED]; bytes do not implement abs. Marked BLOCKED.

### Iteration 31 — 2026-10-15

- Renamed `FUN_00004e6e`→`activate_near_range_object`.
- Annotated kind-2 list/`+0x44`/`+0x4c` alloc (size `(36+3a)*0xC` via `$1A48`), kind-3 child table, 02bd8 flag gate.

### Iteration 32 — 2026-10-15

- Renamed `FUN_00004808`→`build_object_poly_buffers`.
- Annotated `+0x48` poly table (0x20 records), per-poly index alloc at `+0x18`, optional bit1 trailer.

### Iteration 33 — 2026-10-15

- Renamed `FUN_00002bd8`→`apply_template_chain_xform`.
- Annotated template-chain walk, null-aux xyz commit vs mesh path into `+0x44`.

### Iteration 34 — 2026-10-15

- Renamed `FUN_00002d10`→`apply_template_chain_xform_always`.
- Confirmed Capstone always-`0253e`; no `+0x34` shift; false `02de8` is its epilogue.

### Iteration 35 — 2026-10-15

- Renamed `FUN_0000253e`→`build_attitude_matrix_3ang` (`0202a(a,b,c,0)`→`024f8`).
- Distinguished from 4-angle `build_attitude_matrix` / `_x` and twin `02464`.

### Iteration 36 — 2026-10-15

- Renamed `FUN_000024f8`→`finalize_attitude_matrix_3ang` (`20ce4=0x2408`; `020e6` + two `01d02`).
- Sole caller is `build_attitude_matrix_3ang`.

### Iteration 37 — 2026-10-15

- Renamed `FUN_00002ada`→`transform_int3_vecs_by_matrix3` (int[3]×3×3 s16, product>>12).
- Distinguished from packed-short `transform_vecs12_by_matrix3`.

### Iteration 38 — 2026-10-15

- Renamed `FUN_00001c5c`→`translate_int3_vecs` (count× add dx/dy/dz to int[3] verts).
- Noted sibling `FUN_00001cac` multiplies instead.

### Iteration 39 — 2026-10-15

- Renamed `FUN_00001cac`→`scale_int3_vecs` (count× MULS.L sx/sy/sz).
- No BSR/JSR/LEA refs to `$1CAC` in overlay (callers unknown).

### Iteration 40 — 2026-10-15

- Renamed `FUN_0000202a`→`load_attitude_angle_sincos` (4× cos/sin → `DAT_0001d7ee…1d7fc`).
- Capstone uses real `$1DD8`/`$1D76` (not false mid-labels).

### Iteration 41 — 2026-10-15

- Renamed `FUN_00001d76`→`sin_fixed14`, `FUN_00001dd8`→`cos_fixed14` (table lerp `>>6`).
- Marked `FUN_00001d56` / `FUN_00001db8` BLOCKED false entries (+0x20 before real sin/cos).

### Iteration 42 — 2026-10-15

- Renamed `FUN_00001d02`→`matmul3x3_s16` (3×3 s16 product, each dot `>>12`).
- Confirmed false `01d56` is the `ASR.L` at `@0x1D56` inside this function.

### Iteration 43 — 2026-10-15

- Renamed `FUN_000020e6`→`fill_attitude_rotation_bases` (Rx/Ry/Rz-style from angles 1–3).
- Noted `FUN_000021a0` fills 4th-angle basis at `DAT_0001d78c`.

### Iteration 44 — 2026-10-15

- Renamed `FUN_000021a0`→`fill_attitude_rotation_basis_4` (~Ry from angle4 into `DAT_0001d78c`).
- Noted sibling `FUN_000021e0` writes ~Rx into the same slot.

### Iteration 45 — 2026-10-15

- Renamed `FUN_00002562`→`finalize_attitude_matrix_4ang` (`R4×Rz×Rx×Ry` via three `matmul3x3_s16`).
- Completes the `build_attitude_matrix` rename chain.

### Iteration 46 — 2026-10-15

- Renamed `FUN_000021e0`→`fill_attitude_rotation_basis_4_rx` (~Rx from angle4 into `DAT_0001d78c`).
- Twin of `fill_attitude_rotation_basis_4` (~Ry) for the X-axis path.

### Iteration 47 — 2026-10-15

- Renamed `FUN_000025d6`→`compose_attitude_matrix_x` (bases + Rx + three matmuls, tag `0x2468`).
- Completes the `build_attitude_matrix_x` rename chain.

### Iteration 48 — 2026-10-15

- Renamed `FUN_00003b98`→`update_object_camera_metric` (abs camera deltas → `obj+0x10`).
- Metric `max + ((sum of other two)>>2)`; LEA `$2DE8` ≡ `abs_int`.

### Iteration 49 — 2026-10-15

- Renamed `FUN_00003c00`→`compute_camera_abs_metric` (three world args; return-only metric).
- Marked `FUN_00003be0` BLOCKED as false mid-label of `update_object_camera_metric`.

### Iteration 50 — 2026-10-15

- Renamed `FUN_00002428`→`finalize_attitude_matrix_3ang_alt` (untagged; alt matmul order).
- Sole caller `FUN_00002464` (3-angle build wrapper; next rename candidate).

### Iteration 51 — 2026-10-15

- Renamed `FUN_00002464`→`build_attitude_matrix_3ang_alt` (`0202a`→alt finalize).
- Completes the untagged 3-angle attitude build chain.

### Iteration 52 — 2026-10-15

- Renamed `FUN_00002488`→`compose_attitude_matrix_x_alt` (bases+Rx+3 matmuls; no `$2468`).
- Sole caller `FUN_000024d6` (4-angle build wrapper; next rename candidate).

### Iteration 53 — 2026-10-15

- Renamed `FUN_000024d6`→`build_attitude_matrix_x_alt` (`0202a`→alt X compose).
- Completes the untagged X-axis 4-angle attitude build chain.

### Iteration 54 — 2026-10-15

- Renamed `FUN_00002654`→`compose_attitude_matrix_6ang` (tag `$26e0`; 02220 + five matmuls).
- Wrapper `FUN_000026cc` / basis fill `FUN_00002220` / sincos `FUN_000020a0` next.

### Iteration 55 — 2026-10-15

- Renamed `FUN_00002220`→`fill_attitude_rotation_bases_5_6` (`1d774`≈Rx, `1d75c`≈Ry).

### Iteration 56 — 2026-10-15

- Renamed `FUN_000020a0`→`load_attitude_angle_sincos_5_6` (ang5/6 → `1d7ea…1d7e8`).

### Iteration 57 — 2026-10-15

- Renamed `FUN_000026cc`→`build_attitude_matrix_6ang` (completes tagged 6-angle chain).

### Iteration 58 — 2026-10-15

- Renamed `FUN_00002700`→`compose_attitude_matrix_6ang_alt` (untagged; reversed matmul order).
- Sole caller `FUN_0000276e` next.

### Iteration 59 — 2026-10-15

- Renamed `FUN_0000276e`→`build_attitude_matrix_6ang_alt` (completes untagged 6-angle chain).

### Iteration 60 — 2026-10-15

- Renamed `FUN_000027a2`→`invoke_tagged_attitude_compose_neg_sins4` (neg sins 1–4; JSR tag).
- Documented `$2408`/`$2468`/`$26e0` writers into `DAT_00020ce4`.

### Iteration 61 — 2026-10-15

- Renamed `FUN_000027cc`→`invoke_tagged_attitude_compose_neg_sins6` (neg sins 1–6; JSR tag).
- Completes the tagged attitude re-compose / sin-flip pair.

### Iteration 62 — 2026-10-15

- Resolved `DAT_00020ce4` tag landings (NOTES): `$2468`/`$26e0` secondary build entries; `$2408` mid-`FUN_0000229e` (OPEN).
- No new renames; documentation + invoke-header update only.

### Iteration 63 — 2026-10-15

- Renamed `FUN_0000229e`→`build_attitude_matrix_from_dir_roll` (dir+roll→matrix; hosts `$2408`).
- `$2408` = first matmul PEA mid-frame; not a supported re-entry for global sin flips.

### Iteration 64 — 2026-10-15

- Renamed `FUN_00002802`→`transform_int3_vecs_asr_by_1d744` (ASR + fixed view matrix).

### Iteration 65 — 2026-10-15

- Renamed `FUN_000028a6`→`rotate_int3_vecs_by_3ang` (`0253e`→`02ada` wrapper).

### Iteration 66 — 2026-10-15

- Renamed `FUN_00002976`→`transform_vecs12_to_int3_by_matrix3` (vecs12 in, int3 out).

### Iteration 67 — 2026-10-15

- Renamed `FUN_00002a0e`→`transform_listed_object_vecs12_by_1d744` (object list × view matrix).
- Marked `FUN_00002aba` BLOCKED (false mid-label).

### Iteration 68 — 2026-10-15

- Renamed ID08 `FUN_00000006`→`load_overlay_from_resource` (A5 resource-load chain; header only).
- First non-Pacific Conflict `.decomp.c` semantic rename.

### Iteration 69 — 2026-10-15

- Renamed ID08 `FUN_00000348`→`alloc_and_read_resource_payload` (size→alloc→read).

### Iteration 70 — 2026-10-15

- Renamed ID08 `FUN_00000338`→`sysbeep_and_exit_to_shell` (`_SysBeep(100)` + `_ExitToShell`).
- Replaced Ghidra `halt_baddata` stub with Capstone-backed description.

### Iteration 71 — 2026-10-15

- Renamed ID08 `FUN_0000039c`→`bootstrap_window_and_load_overlay` (window/`HELL`/JSR→loader).
- **ID08 complete:** all 4 inventoried functions renamed.

### Iteration 72 — 2026-10-15

- Documented `$E352` / `LAB_0000e350_2` as false mid-label of `isqrt_floor` (+0x20 family).
- Annotated `isqrt_floor` header; NOTES section added.

### Iteration 73 — 2026-10-15

- Verified invoke callsite `@0xA890`: A6 from `@0xA75E`; tag `$2408` after 3ang build.
- `$2408 = finalize_attitude_matrix_3ang_alt − 0x20` [PROVEN]; intended target [STRONG INFERENCE].
- `@0x66F6`: after 6ang build; `$26e0` mid-wrapper stack contract unsatisfied [PROVEN].

### Iteration 74 — 2026-10-15

- Renamed `FUN_0000e3b2`→`acos_scaled_dot3` (scaled dot3 → `FUN_00001e3a`).
- `FUN_00001e3a` identified as cos-table inverse (next rename).

### Iteration 75 — 2026-10-15

- Renamed `FUN_00001e3a`→`acos_fixed14` (inverse of `cos_fixed14` / `DAT_0001ad6c`).

### Iteration 76 — 2026-10-16

- Renamed `FUN_00001ebc`→`atan_fixed14` (inverse on `DAT_0001af6c` longs; mid-biased angle).

### Iteration 77 — 2026-10-16

- Renamed `FUN_000102d6`→`atan2_fixed14` (2-arg heading; same quadrants as attitude heading).

### Iteration 78 — 2026-10-16

- Renamed `FUN_000109ba`→`apply_relative_heading_steer` (atan2/fold → entity +0x61e; calls `10558`).

### Iteration 79 — 2026-10-16

- Renamed `FUN_00010558`→`enqueue_control_inputs_avg4` (4-sample rings → +0x662/+0x664/+0x666).

### Iteration 80 — 2026-10-16

- Renamed `FUN_00010b2e`→`steer_entity_toward_point` (`10360` + `apply_relative_heading_steer`).

### Iteration 81 — 2026-10-16

- Renamed `FUN_00010360`→`build_relative_steer_sample` (Δxyz→body frame + attitude cmds).

### Iteration 82 — 2026-10-16

- Renamed `FUN_00010cb2`→`max_ai_throttle_maybe_invert_679` (+0x668=9; conditional +0x679 negate).

### Iteration 83 — 2026-10-16

- Renamed `FUN_00010c2c`→`adjust_ai_throttle_vs_speed` (target vs +0x62a → throttle +0x668).

### Iteration 84 — 2026-10-16

- Renamed `FUN_00010cd8`→`invert_ai_bias_67b_if_positive` (neg +0x67b if >0).

### Iteration 85 — 2026-10-16

- Renamed `FUN_00010b84`→`ai_bootstrap_climb_phase` (pitch toward 0x2c0; true when altΔ>2000).

### Iteration 86 — 2026-10-16

- Renamed `FUN_00010ce8`→`tick_ai_climb_then_waypoint` (script +0x616: climb phase → waypoint steer).

### Iteration 87 — 2026-10-16

- Renamed `FUN_00010d68`/`10da8`/`10de8`→`ensure_ai_script_{1b2e0,1b310,1b340}_tick`.

### Iteration 88 — 2026-10-16

- Renamed `FUN_00010e28`→`ai_script_try_fire_burst` (timegate + RNG spawn_weapon; 1 when ammo 0).

### Iteration 89 — 2026-10-16

- Renamed `FUN_00010ecc`→`tick_ai_1b310_approach_fire` (1b310 tick + phase 1→2→3 fire).

### Iteration 90 — 2026-10-16

- Renamed `FUN_00010f68`→`tick_ai_1b370_mission` (DAT_0001b370 multi-phase climb/fire/steer).

### Iteration 91 — 2026-10-16

- Renamed `FUN_00019fba`→`try_begin_landing_approach` (267xx glide path; install +0x32=0x1A186).

### Iteration 92 — 2026-10-16

- Renamed `FUN_00019c5e`→`find_nearest_runway_approach_ends` (scan pads 'p'/4 → two XYZ ends).

### Iteration 93 — 2026-10-16

- Renamed `FUN_00019c26`→`store_xyz_asr` (A1 ← (x,y,z) >> scale).

### Iteration 94 — 2026-10-16

- Capstone-reverified `update_aircraft_entity` Block 1; cross-linked +0x662/+0x666
  to `enqueue_control_inputs_avg4` channel map; noted flags_685 bit0 gate.

### Iteration 95 — 2026-10-16

- Renamed `FUN_0001a1a6`→`tick_landing_approach_glide`; documented `$1A186` as
  `$1A1A6−0x20` false mid-label (installed by `try_begin_landing_approach`).

### Iteration 96 — 2026-10-16

- Documented `flags_685` bitfield + control channel map (+0x662/4/6) in `docs/STRUCTS.md`.

### Iteration 97 — 2026-10-16

- Renamed `FUN_00000354`→`probe_nearest_facility_kind` (0x12→0x100, 0x13→0x200).

### Iteration 98 — 2026-10-16

- Annotated `tick_landing_approach_glide` phases (lead, Y clamp, throttle bands,
  lateral offset, touchdown restore, abort band).

### Iteration 99 — 2026-10-16

- Renamed `FUN_00003c48`→`approx_dist3_from_abs` and `FUN_00003c68`→`approx_dist3_xyz`
  (max+|others|>>2 distance approx).

### Iteration 100 — 2026-10-16

- Resumed existing work; all ten output files already existed and were preserved.
- Renamed ID09 `FUN_00000432` and its three locals; annotated input bounds,
  output, overlap direction, zero-length case, global dependencies and uncertainty.
- Evidence: `ID09.c:135-142`; independent reverse-engineering and QA agents agreed.
  Full-file comparison after removing comments and reversing four identifier renames
  matches the original (632 tokens). No binary address mapping was assumed.
- Isolated helper compiled with `cc -std=c99 -Wall -Wextra -Werror` using explicit
  8-bit byte / 16-bit ushort aliases. All 768 cases (length 0..255, zero/255/varying
  payloads) matched a memmove-based reference, including return pointer and canary
  bytes. Harness: `/tmp/hellcats-id09-iteration100.c` (temporary).
- Status remains RENAMED: these checks establish preservation of exported C,
  not the original runtime ABI or instruction-level correspondence.
- Corrected inventory omissions for five multiline signatures; historical entries
  and previous reconstruction edits remain intact. See inventory correction below.
- Two unrelated ID05 RNG test binary artifacts changed during this session;
  they were not edited or reverted by this iteration.

### Iteration 101 — 2026-10-16

- Inspected the clean starting worktree and verified all 32 protected checksums.
- Annotated `ID09.c:37-65` in the existing reconstruction: eight-word clear,
  raw selector result codes, signed-word tests, and the side effect inside `&&`.
- Preserved every token outside comments, including the repeated word-2 clear.
  No semantic names assigned to unresolved global addresses or record fields.
- Separate analysis agrees on C-level behavior. Plain-char signedness, overlapping
  global widths and binary correspondence remain unresolved; no binary offset
  was inferred from a Ghidra address. Whole function remains INVESTIGATING.
- Scope: comments in `ID09.decomp.c`, symbol map and this checkpoint only.
- Validation: complete ID09 token stream unchanged versus iteration-100 baseline;
  independent QA and protected hashes pass. Full translation-unit compilation
  remains unsuitable because original Ghidra register/jumptable/type artifacts
  are retained. No VERIFIED promotion.

### Iteration 102 — 2026-10-16

- Preserved the uncommitted iteration-101 changes and verified all 32 protected
  checksums before editing. Continued `ID09.c:66-83` in the existing output.
- Documented distinct signed-word/bit-12 and unsigned-threshold gates for output
  bytes +8/+9; kept byte stores separate under the intended big-endian layout.
- Recovered reverse lookup mechanics: five bytes before `DAT_00000059`, first
  reverse-order match maps to 5..1, no match to 0. The scalar declaration does
  not establish valid C pointer provenance; no inferred array was substituted.
- Documented the gated source-byte copy to +0x0d and word copy to +0x0e, including
  later overwrite and unresolved aliasing. Record and hardware names remain UNKNOWN.
- Validation: independent analysis/review; whole-file comment-stripped tokens
  identical to the iteration-101 baseline; protected checksums and diff whitespace
  checks pass. No compilation claim for the malformed Ghidra translation unit.
- Modified only `ID09.decomp.c`, this checkpoint and `DECOMPILATION_SYMBOLS.md`.
  Function remains INVESTIGATING, with no count or VERIFIED-status change.

### Iteration 103 — 2026-10-16

- Preserved iterations 101-102 and verified all 32 protected hashes.
- Located terminal stack loop by unique signature in `ID09.bin` at physical
  offset 0x13e; hex export matches all 1100 bytes. Neighboring signatures
  corroborate the match without assuming runtime addresses are file offsets.
- Independent Capstone decoding confirms 61 word clears (122 bytes), final-stack
  +24 word write, omitted A-line/control-flow region, stack restoration and JMP(A1).
- Annotated exported C terminal block without replacing its truncated control flow.
  Wrote `ID09_TERMINAL_ANALYSIS.md` with bytes, physical offsets and ABI unknowns.
- Validation: comment-only token preservation, independent binary/QA review,
  protected hashes and diff checks. Function remains INVESTIGATING, not VERIFIED.
- Modified `ID09.decomp.c`, progress/symbol documents and the new evidence note.

### Iteration 104 — 2026-10-16

- Verified all 32 protected hashes; preserved existing iteration edits.
- Unique initialization signature locates binary file 0x68; byte decoding proves
  a pointer load from absolute $02ae and selector tests at pointer +8/+9.
- Physical file 0x2ae contains 0x216e000e: +8/+9 exactly produce the suspicious
  Ghidra labels. Erroneous file/runtime constant propagation is STRONG INFERENCE;
  actual pointer value and import configuration remain unknown.
- Found omitted signed-byte gate at file 0xc4 and output +7 write at 0xd2,
  corresponding to Ghidra's removed-block warning. Added discrepancy comments
  without changing executable tokens or introducing substitute globals.
- Added `ID09_SELECTOR_ANALYSIS.md` with exact searched signature, byte table,
  confidence distinctions and repair constraints. Independent analysis/QA,
  byte-table checks, protected hashes and diff checks pass.
- Function remains INVESTIGATING; counts unchanged. Modified ID09 reconstruction,
  progress/symbol maps and the new selector evidence note only.

### Iteration 105 — 2026-10-16

- Verified all 32 protected hashes; preserved uncommitted iterations 101-104.
- Decoded file 0xf8..0x10c: `MOVE.B $21e.w,D0`, unique `LEA $59(PC),A0`,
  `CMP.B -(A0)` / `DBEQ` / `ADDQ.W` / store to +0x0a. The five scanned bytes
  are a BRA-skipped data island at file 0x54..0x58: `03 13 0b 02 01`
  (0x01→5, 0x02→4, 0x0b→3, 0x13→2, 0x03→1, else 0). Ghidra loop equivalent.
- Function-level identification: record layout, low-memory globals and
  return 0xea84 (−5500 envNotPresent) match the Toolbox SysEnvirons glue
  fallback. Proposed `sysenvirons_glue_fallback` [STRONG INFERENCE]; identifier
  not renamed yet. Wrote `ID09_SYSENVIRONS_ANALYSIS.md`.
- Validation: comment-only token comparison, protected hashes. Still INVESTIGATING.

### Iteration 106 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-105.
- Decoded ID09.bin file 0x20..0x46 (not exported by Ghidra): ROM85 sign test,
  `$A346` GetOSTrapAddress($90) vs `$A746` GetToolTrapAddress($9F
  _Unimplemented), then `$A090` _SysEnvirons when implemented, else fall to
  0x48. Renamed `FUN_00000048` → `sysenvirons_glue_fallback` [STRONG INFERENCE];
  original identifier kept in header and inline comment. No call sites in any export.
- Annotated machineType codes (`ID09.c:44-64`) vs SysEnvRec constants and ROM
  version bytes as HYPOTHESIS.
- Noted file 0x04..0x1e: return-address-indexed BSR stubs feeding A-line `$ADEA`
  (likely `_Pack3` auto-pop, Standard File selectors) — HYPOTHESIS, not exported.
- Validation: comment-stripped token diff vs ID09.c shows only this rename and
  the prior FUN_00000432 rename; protected hashes OK. Not VERIFIED.

### Iteration 107 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-106.
- Decoded ID09.bin file 0x188..0x3c2. File coordinate matches Ghidra here
  (LINK at 0x2a6). `FUN_000002a6` = Pascal FSOpen glue: 50-byte IOParam on the
  stack, ioNamePtr/ioVRefNum set, version/permission/misc cleared, `$A000`
  _Open, ioRefNum → VAR arg, D0 → result, callee pops 10 bytes. Ghidra stopped
  decoding at the A-line word. Renamed to `fsopen_glue` [STRONG INFERENCE]; truncated C body kept.
- Segment ID09 is a Toolbox/File Manager glue library: unexported stubs for
  FSClose, FSRead/FSWrite, GetVol, GetEOF, GetFPos plus register-based OS
  trap shims at 0x18a..0x2a4 (HYPOTHESIS, documented in the header only).
- Validation: token diff vs ID09.c = renames only; protected hashes OK.

### Iteration 108 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-107.
- Decoded ID09.bin file 0x3c2..0x44a. `FUN_000003c2` = SwapMMUMode(VAR mode)
  glue: byte via VAR pointer → D0, `$A05D`, D0.B stored back, pops 4 bytes.
  Renamed `swapmmumode_glue` [STRONG INFERENCE]; truncated C body kept.
- Unexported neighbours (HYPOTHESIS): Pack6 IUMagString/IUMagIDString stubs
  (0x3d6/0x3dc), NumToString via Pack7 (0x404), c2pstr-like (0x416). The
  bytes at 0x432 match the existing `length_prefixed_bytes_to_c_string_in_place`
  (p2cstr-like): MOVEQ #0/MOVE.B/DBRA shift loop, CLR.B, return arg pointer.
- ID09: all 4 exported functions now RENAMED; none VERIFIED.
- Validation: token diff vs ID09.c = renames only; protected hashes OK.

### Iteration 109 — 2026-10-16

- Verified 32 protected hashes; ID07.decomp.c was an unmodified seed.
- Decoded ID07.bin 0x06..0x18e: GetResource('STR#',129), HLock, walk 120
  entries; "\p" prefix → Pascal string (memmove drops marker), else C string;
  "\r"/"\t" escapes via runtime switch helper; pointers to A5−0xf46[1..120].
  Ghidra failed on the inline switch table at file 0xda.
- Resolved A5 jump-table targets from ID00.bin (above/below/jtsize/jtoff header,
  entries offset/MOVE.W #seg/_LoadSeg; seg offset + 4-byte CODE header = file
  offset): `$272`→seg 9 file 0x270 (`$A029` HLock glue), `$4fa`→seg 2
  `FUN_0000024a` (overlap-safe memmove), `$3a`→seg 1 file 0xbe (switch helper).
- Renamed `FUN_00000006` (ID07 only) → `load_str129_string_table`
  [STRONG INFERENCE]; renamed its sole call site in FUN_00000190. Same-named
  `FUN_00000006` in other segments are distinct functions and untouched.
- Validation: token diff = rename only; protected hashes OK.

### Iteration 110 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-109.
- `FUN_00000190` (ID07) copies string-pointer slices 2..22, 94..99, 100..105,
  106..115 of A5−0xf46 into A5−0x221e, −0xffe, −0xfae, −0xf86. Renamed
  `init_string_pointer_groups` [STRONG INFERENCE].
- Caller found by byte search: ID02.bin file 0x2c0a `JSR $592(A5)` inside the
  truncated `FUN_00002bbc` (CODE 0 entry seg 7 off 0x18c). Readers located in
  ID04 (0x22e2; ID04.c:711; LEAs at 0x131a/0x1cba/0x1d14/0x2aac).
- ID07: both functions RENAMED. Validation: token diff = renames only; hashes OK.

### Iteration 111 — 2026-10-16

- Verified 32 protected hashes; ID02.decomp.c was an unmodified seed.
- Decoded ID02.bin 0x2bbc..0x2d9e with a JT-resolving disassembler
  (scratch tool, not in repo). `FUN_00002bbc` = application startup: heap
  setup, standard Toolbox Init* sequence, event mask, string tables (then
  UnloadSeg seg 7), seg-4 gate → ExitToShell, SysEnvirons (ID09 glue) →
  hasColorQD / CPU flags at A5−0x1388/−0x1387, optional colour-table
  allocation, 'MENU' 2 check, 'HEL1' 127 (0x12a bytes) and 128 (0x500 bytes)
  load-or-create, SetPort. Renamed `initialize_application` [STRONG INFERENCE];
  renamed call site in `FUN_0000309a` (ID02.c:1658).
- Links iterations 105-110: confirms ID09 dispatcher at file 0x20 is called as
  SysEnvirons(1,&rec) and ID07 is an init-only string segment.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 112 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-111.
- Proven entry chain: ID01.bin (CODE 0 JT entry 0) loads constant 0x4b2 and
  `JSR (A5,D1.W)` → JT $4b2 → ID02 `FUN_0000309a`, then ExitToShell.
- Decoded 0x309a..0x30f8: initialize_application, UnloadSeg seg 4, MaxMem
  glue, helper 0x1b42, A5−0x14c4=1, ID08 overlay loader (result kept),
  UnloadSeg seg 8 and seg 5, helper 0x30fa, conditional 0x35e4, then infinite
  loop on `FUN_00002fd4`. Renamed `main` [STRONG INFERENCE].
- Validation: token diff = renames only; protected hashes OK.

### Iteration 113 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-112.
- Decoded ID02.bin 0x2fd4..0x3098: HiliteMenu(0), SystemTask, two helpers,
  GetNextEvent(everyEvent), switch on evt.what (1 mouseDown → 0x2f1e;
  3/5 key with cmdKey → MenuKey → 0x36a2; 6 update of main window
  A5−0x14ca → Begin/EndUpdate around 0x4db0; 8 activate → 0x2fa0).
  Renamed `poll_and_dispatch_event` [STRONG INFERENCE].
- Finding: word 0x49C0 = EXTB.L D0 (68020+) appears twice; ID02 is compiled
  for 68020+ or relies on a CPU gate (seg4 check in initialize_application?) — open question.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 114 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-113.
- `FUN_000036a2` = menu command dispatcher: HiWord/LoWord of menuResult,
  switch on menu 1..5. Annotated menu 1 (Apple: item 1 → JT $162, others →
  OpenDeskAcc), menu 2 (13 items, incl. save HEL1 127 at item 2, quit helper
  0x2eaa at item 13, separators at 3/10/12), menu 3 (Edit → SystemEdit, else
  SysBeep(5)). Switch tables parsed programmatically. Renamed `do_menu_command`.
- Large function: menus 4 (0x37ec) and 5 (0x38ac) deliberately left for next pass.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 115 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-114.
- Completed `do_menu_command`: menus 4 and 5 are option menus over the
  HEL1 127 settings record S (BCHG #0 toggles at S+3/5/7/9/0x13/0x15/0x17/
  0x19/0x1b; radio word S+0x10 = 1..5; word S+0xe = 1/3/2 via FUN_000035bc),
  each setting dirty word A5−0x138a; menu 4 item 4 toggles non-persistent
  byte A5−0x102f. Common epilogue BSR 0x2a44. Comment-only edit.
- Validation: token diff = renames only (unchanged since 114); hashes OK.

### Iteration 116 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-115.
- `FUN_00002a44` (clean C) copies HEL1 127 settings words into live A5
  options (−0x12ee..−0x12d0, −0x103c); on change of selected fields and
  A5−0x1006 != 0, calls function pointers A5−0x1092 / −0x104e / −0x1096,
  then redraws via FUN_00004db0. Two fields gated by A5−0x137a == 8.
  Renamed `apply_settings_to_live_options` [STRONG INFERENCE]; documented
  the menu item → S word → live word map (odd-byte BCHG = bit 0 of BE word).
- Byte scan of ID02.bin found 6 PC-relative callers (0x6ce, 0x6f6, 0x716,
  0x218a, 0x2a20, 0x39a0).
- Validation: token diff = renames only; protected hashes OK.

### Iteration 117 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-116.
- Byte scan (d16(A5) operands, decoded at candidate starts) across ID01-ID09:
  A5−0x1092/−0x104e/−0x1096 are only read (ID02 0x2a3a, 0x2aec, 0x2b1a,
  0x2b50, 0x3694, 0x4d1a); no direct writer exists in the CODE segments.
  A5−0x1006 is written only by ID08 (0xd4 store, 0xf0/0xfe align, 0x226
  clear) = relocated overlay base. Pacific Conflict.c has no A5-relative
  references to these slots (its A5 is not the application A5 in Ghidra).
- Decoded ID08 0x236..0x29e (Ghidra-truncated tail): JT $53a(base, code
  size) [seg5 file 0x7f6], TickCount ($A975) → JT $542(A5−0x1cc4, 0x38,
  ticks) [seg5 0x8b8], then seg5 routines $582/$552/$54a/$532/$572.
  Recorded only; ID08.decomp.c not edited this iteration.
- Comment-only update to `apply_settings_to_live_options` header (ID02).
- Validation: token diff unchanged (renames only); protected hashes OK.
  No function status change.

### Iteration 118 — 2026-10-16

- Verified 32 protected hashes; ID05.decomp.c was an unmodified seed.
- JT $53a → ID05 `FUN_000007f6`: right after ID08 loads and relocates the
  overlay, 12 random bytes of the overlay code are saved to table A5−0xb4
  and overwritten with 0xFF. JT $55a → `FUN_0000085e` restores them (reverse
  order) only if word A5−0xbc or long A5−0xc0 is non-zero; called once, ID08
  0x29e, after seg5 calls $542/$582/$552/$54a/$532/$572. Copy-protection
  booby trap is HYPOTHESIS.
- `FUN_00000728` = ANSI rand LCG (seed A5−0x6c) [PROVEN]; `FUN_00000746` = srand.
- Decoded 68020 DIVUL.L $c(A6),D1:D0 (file 0x80a) = `% param_2`.
- Renamed 4 ID05 functions + 4 call sites. Token diff = renames only; hashes OK.

### Iteration 119 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-118.
- Gate writers found (68020-aware byte scan): A5−0xbc incremented only by the
  unexported stub at ID05 file 0x8b2 (JT $532), called by ID08 0x28c when
  `FUN_00000934` (JT $54a) returns nonzero. A5−0xc0 cleared/incremented only
  by unexported ID05 routine 0x964..0xa60 (called from ID05 0x69c), which
  counts table entries (A5−0xba, count A5−0xb6, 12-byte records) whose
  key-obfuscated string (key A5−0x2c, & 0x7f) and three words match the args.
- Renamed `FUN_00000934` → `record_code_index_equals` (rec[4]*20+rec[5]==n).
  Also noted ID05 `FUN_00000754`/`FUN_000007a8` = 6-letter base-26 encode/decode.
- Scratch disassembler switched to 68020 mode (ID02/ID05 use EXTB.L, MULU.L, DIVUL.L).
- Validation: token diff = renames only; protected hashes OK.

### Iteration 120 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-119.
- Bytes confirm `FUN_00000754` = signed base-26 6-letter encoder (DIVS.L #26)
  and `FUN_000007a8` = decoder (MULU.L #26, (s8)c − 'A'); renamed
  `encode_base26_6chars` / `decode_base26_6chars` [PROVEN] plus 6 call sites
  (wrappers at ID05 0xa90..0xbde, buffers A5−0x68/−0x54/−0x40).
- Decoded the 0x964 matcher call at ID05 0x69c: args (−0x262, −0x264, −0x266
  words of the caller frame; string = 0x4e4(ptr, 3)); result word stored to
  −0x26a(A6) and tested.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 121 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-120.
- Renamed seven ID05 codec wrappers (0xa62..0xbde) with mechanics-based names:
  random_28bit_value, pack_fields_to_code_buf68 / unpack_fields_from_code,
  encode_code28_to_buf54, encode_long_to_buf40, decode_code_to_long_a/_b.
- Callers by JT/BSR scan: ID05 0x442, 0x498, 0x4b2, 0x4ce, 0x674 (all inside
  the large truncated ID05 routine around 0x2c8..0x728); ID08 0x276/0x2a6 via
  JT $552 — at 0x276 the 6-letter string is the `rec` checked by
  record_code_index_equals (letters 5-6).
- Validation: token diff = renames only; protected hashes OK.

### Iteration 122 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-121.
- Ghidra's `FUN_000002c8` spans two routines. A (0x2c8..0x3b8): Pascal modal
  dialog filter — first-call default-button frame on item 1, OK dimmed while
  item 3 text empty, Return/Enter → item 1, Esc → item 2. Renamed
  `code_dialog_filter`. B (0x3ba..0x4e2, unexported): builds output code
  strings from FUN_000000c8 words and FUN_00000214 values via the codec
  wrappers; compares the GetVol name with A5−0xca and may re-randomise via
  FUN_00000270(0, random_28bit_value()).
- Validation: token diff = renames only; protected hashes OK.

### Iteration 123 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-122.
- ID05 0x160/0x1bc/0x214/0x270 (all truncated at $A9A0 in Ghidra) are
  read/write accessors for two longs in resources 'DATA' 128 and 'TEXT' 128
  (GetResource, HNoPurge, copy, [ChangedResource+WriteResource], HPurge,
  ReleaseResource). Renamed read/write_DATA128_pair, read/write_TEXT128_pair.
  Callers: ID08 0x26c/0x2c4 (DATA via JT $582/$57a), ID05 0x3f4/0x44a/0x458/0x718 (TEXT).
- ID05 now 19/24 RENAMED. Validation: token diff = renames; hashes OK.

### Iteration 124 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-123.
- `FUN_000000c8` = machine/screen fingerprint: SysEnvirons machineType, plus
  screen width/height/depth from the GDevice pixmap (Color QD) or screenBits
  (depth 1). These are the five words packed by pack_fields_to_code_buf68, so
  the protection code is machine-dependent [STRONG INFERENCE].
- `FUN_00000006` = centre a template rect horizontally, 1/3 down below the
  menu bar (GetMBarHeight glue). Both renamed; ID05 21/24 RENAMED.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 125 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-124.
- Decoded ID05 0x4e4..0x726. `FUN_000004e4` = dialog item text → upper-case
  C string (static A5−0x1c9). `FUN_00000560` = protection dialog driver
  (JT $572, called from ID08 0x298): skip if stored code already valid; else
  random challenge (w1..w3) via `FUN_000008d6`, DLOG 1000 with
  code_dialog_filter, item 2 → ExitToShell, item 3 answer checked by matcher
  0x964, item 4 decoded to *a, ALRT 1001 on failure; on success persists via
  write_TEXT128_pair. Manual look-up protection = STRONG INFERENCE.
- Renamed get_dialog_item_text_upper, run_protection_dialog,
  pick_random_protection_challenge. **ID05 is fully RENAMED (24/24).**
- Validation: token diff = renames only; protected hashes OK.

### Iteration 126 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-125.
- Wrote `docs/COPY_PROTECTION_FLOW.md`: full ID08 → ID05 protection chain
  (poison, seed/table init, DATA 128 check, dialog, restore, persist) with
  file offsets; ID08 offsets re-verified by decoding 0x24c..0x2d4.
- Decoded ID05 0x8b8 (Ghidra "Unable to decompile", not inventoried):
  `ansi_srand(ticks)`, table pointer A5−0xba = A5−0x1cc4, count A5−0xb6 = 56.
  Comment added above Ghidra's error block; inventory counts unchanged.
- Validation: ID05 token diff unchanged (34 rename hunks); hashes OK.

### Iteration 127 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-126.
- `FUN_00002f1e` = mouseDown handler: FindWindow part switch (menu bar →
  MenuSelect → do_menu_command; system window → SystemClick; go-away on main
  window → TrackGoAway + HideWindow; content/drag/grow ignored).
- `FUN_00002fa0` = activate handler: main window activation (activeFlag +
  changeFlag) → InvalRect(portRect). Both renamed; dispatcher header updated.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 128 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-127.
- `FUN_00004db0` (last ID02 function) = main-window redraw: gated by redraw
  flag, overlay base and A5−0x12f8; forces live option A5−0x12ea to 1 if 0;
  HideCursor, FUN_00004c18, UnloadSeg seg 3, overlay callback A5−0x109e,
  helpers 0x4d96 / FUN_00000930(0,1) / 0xa26, ShowCursor. Dead local flag
  (A5−0x12d4 && A5−0x1032) documented. Renamed `redraw_main_window` + 1 call site.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 129 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-128.
- `FUN_00004c18`: for up to 3 GDevice slots (A5−0x136e, 0x16 bytes each),
  fetches a fresh 256-word array via `FUN_000048ae` (Get/SetGDevice, depth
  4/8 start index) and compares to the stored copy; on change calls JT $182
  (slot 1) and refreshes, then overlay callback A5−0x1096. B&W path
  (A5−0x137a == 1) → FUN_00004b62. Renamed `check_device_color_state_changed`.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 130 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-129.
- Finished `FUN_000048ae`: for palette entries 0..12 (4-bit) / 0..216 (8-bit)
  calls PmForeColor ($AA97) and reads the resulting device index from
  thePort->fgColor, building map/inverse tables; detects duplicate indices
  (8-bit, entry < 200) → A5−0x102a; then picks function pointer A5−0x1122 =
  JT 0x46a (ID02 0x488a) or 0x33a (ID02 0xc68). Renamed
  `build_palette_index_map` (+3 call sites); confirms the palette purpose of
  check_device_color_state_changed.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 131 — 2026-10-16

- Verified 32 protected hashes; preserved uncommitted iterations 101-130.
- Renamed three palette helpers in ID02: `FUN_000046b4` →
  rebuild_all_palette_index_maps (per-slot build_palette_index_map, B&W path,
  releases A5−0x103a via FUN_00000d24); `FUN_00004738` → configure_palette_entries
  (SetEntryUsage/SetEntryColor for 4-bit palette A5−0x14ae and 8-bit palette
  A5−0x14aa; entries 0..0xc7 animated at 8-bit); `FUN_0000488a` →
  clear_ctab_size_callback (CurrentA5-safe; installed via JT 0x46a).
- Validation: token diff = renames only; protected hashes OK.

### Iteration 132 — 2026-10-16

- Working tree was clean at start: the user committed iterations 101-131
  (HEAD e92a20d). Verified 32 protected hashes; edits intact.
- `FUN_000049fe` = RGB grey-level (0..4) → palette index lookup in base table
  A5−0x350 then extended table *(A5−0x14a6); +200 in 8-bit mode. Renamed
  `lookup_palette_index_for_rgb_level`.
- `FUN_00004b62` (Ghidra "Unable to decompile", not inventoried) documented
  from bytes as init_standard_colour_indices: nine grey/black lookups stored to
  A5−0x11ae, −0x11ac, −0x118c, −0x1188, −0x118a, −0x117c, −0x117e, −0x11fa, −0x11f8.
- QA: an edit briefly dropped a quote from Ghidra's original comment line;
  restored, and a check confirms every original WARNING / "Unable to
  decompile" line is present verbatim.
- Validation: token diff = renames only; protected hashes OK.

### Iteration 133 — 2026-10-16

- Verified 32 protected hashes; uncommitted iteration 132 preserved.
- `FUN_00000d24` = ClosePort($A87D) + DisposPtr (JT $23a → ID09 0x218);
  renamed `close_and_dispose_port` with its call site. A5−0x103a therefore
  holds a pointer-allocated GrafPort.
- Noted `FUN_00000d3a` (CurrentA5-safe; builds a port when A5−0x103a == 0,
  rowBytes = ((width*depth + 15) >> 4) * 2) as next target.
- Validation: token diff = renames only; Ghidra comment lines intact; hashes OK.

### Iteration 134 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-133 preserved.
- `FUN_00000d3a` = blit a pixel buffer to the main window: lazily creates the
  offscreen port A5−0x103a via FUN_00000ca6 (rowBytes from width × depth,
  0x8000 PixMap flag), sets its baseAddr to the argument, computes src/dst
  rects (mode 2/3 shift by ∓A5−0x137e), then ForeColor black, BackColor
  white, CopyBits srcCopy. CurrentA5-safe. Renamed
  `blit_offscreen_frame_to_window`.
- References: JT $322; ID06 0xf18 JSR; ID02 0x1b6a LEA $322(A5) — address
  taken, candidate for the indirect overlay-callback installation (iteration 117).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 135 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-134 preserved.
- ID02 0x1b42 (unexported; main's helper) installs the overlay service table:
  34 JT entry addresses into A5−0x1122..−0x10a6 and A5−0x1310..−0x1304
  (incl. blit_offscreen_frame_to_window and several CurrentA5
  thunks), then allocates the overlay work buffer A5−0x1040 (320400 or
  220400 bytes by FreeMem). Wrote `docs/OVERLAY_SERVICE_TABLE.md` (generated
  from bytes + JT resolution). The A5−0x1092/−0x104e/−0x1096/−0x109e/−0x10a2
  callbacks are outside this table → overlay-written.
- Renamed `FUN_00001b14` → `freemem_a5safe` (Ghidra "return 0" is a
  decompiler error; kept). main's header updated.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 136 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-135 preserved.
- Renamed six CurrentA5 service thunks (slots −0x10be..−0x10aa) by their ID09
  glue targets: dispose_handle / realloc_and_clear_handle / hlock / hunlock /
  hpurge / hnopurge `_a5safe`. realloc_and_clear_handle: ReallocHandle,
  MemError ($0220) → FUN_000019e2, HLock, FUN_000002b0(*h, 0, size), HUnlock;
  Ghidra dropped the MemError value (dead-looking branch) - noted, kept.
- OVERLAY_SERVICE_TABLE.md names updated.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 137 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-136 preserved.
- `FUN_000019a2` = NewHandleClear(size) + MemError → fatal; returns handle
  (Ghidra return value wrong). Renamed `new_handle_clear_or_die_a5safe`.
- `FUN_000019e2` = fatal out-of-memory exit: dispose overlay image,
  FUN_00004318, FUN_00001d48(STR# 129 string 93 at A5−0xdd2, 0), ExitToShell.
  Renamed `fatal_memory_error_exit` (+2 call sites).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 138 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-137 preserved.
- Renamed `FUN_00001d48` → show_caution_alert_with_number (ParamText +
  CautionAlert 258; JT $4ba for ID08 errors), `FUN_00001c8a` →
  format_int_decimal_pstring, `FUN_00004318` → shutdown_sound (3× FUN_00004242,
  restore low-mem $0196, FUN_00003d36, SndDisposeChannel). 5 call sites renamed.
- Correction: ID05 run_protection_dialog header labelled $A985 as StopAlert;
  $A985 is _Alert ($A986 StopAlert, $A987 NoteAlert, $A988 CautionAlert).
  Fixed in ID05.decomp.c with a dated note.
- QA: first scripted pass aborted on an assertion (substring overlap) before
  writing ID02; re-run cleanly. Token diffs = renames only; Ghidra comment
  lines intact in ID02/ID05; hashes OK.

### Iteration 139 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-138 preserved.
- `FUN_00003d36` = clear_sound_buffer_to_silence: 0x80 into the 370-word
  hardware buffer at low-memory SoundBase ($0266). Ghidra replaced the pointer
  load with constant &DAT_66fa4e75 (decompiler error; expression kept).
- `FUN_00004242` = silence_sound_channel(ch 0..1): queue 370 samples from
  A5−0xc26 via FUN_00003d50 into channel record A5−0x7d0 + ch*0x238.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 140 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-139 preserved.
- `FUN_00003d50` = alloc_sound_buffer_node (pop from channel free list,
  fill {cursor, 0, buffer, start, end, next, continuation}); 14 call sites.
- `FUN_00003dd0` = init_sound_system (two 0x238-byte channel records with
  20 × 0x1c nodes, 1110-byte silence buffer, looping silence on both
  channels, routine pointers A5−0x360/−0x35c, one-time FUN_00003aae/39a8/3bc4,
  saves and replaces low-memory vector $0196).
- `FUN_00003db8` (if arg == 1, $0196 = A5−0x35c) left unnamed pending the
  $0196 identity.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 141 — 2026-10-16

- Verified 32 protected hashes; uncommitted iterations 132-140 preserved.
- Low-memory $0196 = Lvl1DT[1] (VIA CA1 vertical-blanking level-1 interrupt
  vector; Lvl1DT at $0192 per Inside Macintosh) [STRONG INFERENCE]. The game
  replaces it with its own sound-refill handler and restores it in shutdown_sound.
- Decoded the three handlers (JT 0x412/0x41a/0x422 → ID02 0x3aae/0x39a8/
  0x3bc4): reserved return slot + full register save, in-code A5 cache primed
  by a first call from init_sound_system (self-modifying), then RTS-chain to
  the previous vector; bodies resample channel 0 (and channel 1 for 0x3bc4)
  with a 32.32 step into SoundBase. Renamed vbl_sound_handler_ch0_unrolled /
  _ch0_variant / _two_channel, and FUN_00003db8 →
  select_two_channel_sound_handler.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 142 — 2026-10-17

- Working tree clean at start (user committed iterations 132-141). Verified
  32 protected hashes.
- Renamed `FUN_00003f54` → play_sample_on_channel (ch 0..1; optional
  sustain loop via a self-looping middle node, else sample + looping silence;
  service slot −0x10de).
- Wrote `docs/SOUND_SYSTEM.md` (hardware model, channel/node layout, globals,
  function table, VBL hook pattern, open questions). Service-table doc names
  updated.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 143 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 142 preserved.
- `FUN_00004050` = play_sample_on_channel minus the channel-head store;
  renamed `enqueue_sample_on_channel` (mechanics STRONG INFERENCE, purpose
  HYPOTHESIS). SOUND_SYSTEM.md and OVERLAY_SERVICE_TABLE.md updated.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 144 — 2026-10-17

- Working tree clean at start (user committed iterations 142-143); 32
  protected hashes verified.
- Renamed the remaining sound services: `FUN_0000412e` →
  set_sound_playback_rate (16.16 rate clamped 0.5x..3x), `FUN_000041a6` →
  release_channel_loop (appends silence and un-loops every node up to it —
  answers the sustain-release question), `FUN_000042b0` → is_channel_playing.
  JT slots $452/$44a/$43a confirmed. SOUND_SYSTEM.md / OVERLAY_SERVICE_TABLE.md
  updated.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 145 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 144 preserved.
- `FUN_00000c68` = apply_pending_color_entries_a5safe (SetEntries $AA3F on the
  A5−0x14b2 colour table, then ctSize = 0); default for slot −0x1122, with
  clear_ctab_size_callback as the collision 'discard' alternative.
- `FUN_00001876` = blit_image_clipped_to_region (OpenRgn/FUN_000016aa/
  CloseRgn clip, HGetState/HLock image A5−0x12b0, CopyBits via port
  A5−0x1496, restore clip); `FUN_0000195c` its CurrentA5 thunk (slot −0x111a);
  `FUN_0000197c` = run_segment3_entry_and_unload_a5safe (slot −0x111e).
- QA: source line refs initially taken from the decomp file; corrected to ID02.c.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 146 — 2026-10-17

- Working tree clean at start (user committed iterations 144-145); 32
  protected hashes verified.
- `FUN_00000a42` = draw_thick_line_pixel_index_a5safe (fgColor = raw index,
  PenSize 2, MoveTo/LineTo; slot −0x1116). `FUN_00000a86` =
  draw_thick_xor_line_a5safe (black, PenMode srcXor, PenSize 2, line,
  PenMode 0; slot −0x1112). Both truncated in Ghidra; decoded from bytes.
- `FUN_00000ad0` (slot −0x110a; clip region A5−0x13b6, rect globals
  A5−0x1202..−0x11fc, FUN_000015cc, PaintRect) deferred to the next pass.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 147 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 146 preserved.
- `FUN_00000ad0` = paint_view_horizon_bands_a5safe: clipped to view region
  A5−0x13b6, paints a top band, two quadrilaterals split along a tilted line
  (xA@y1 → xB@y2), and a bottom band, each in its own colour index
  (slot −0x110a). Sky/horizon/ground role = HYPOTHESIS.
- `FUN_000015cc` = set_draw_color_index (fgColor = index; 1-bit mode via JT
  $1ca). Caller list corrected to FUN_00000fa0 (initially cited a decomp line).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 148 — 2026-10-17

- Working tree clean at start (user committed iterations 146-147); 32
  protected hashes verified.
- Renamed four drawing/port services (all Ghidra-truncated, decoded from
  bytes): close_port_a5safe, swap_port_a5safe, paint_rect_color_index_a5safe,
  paint_polygon_rgb_a5safe (packed 0xRRGGBBxx colour; {x,y} long pairs with
  y negated; B&W FillPoly vs colour RGBForeColor + PaintPoly). JT slots
  $312/$352/$39a/$3f2 confirmed.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 149 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 148 preserved.
- Renamed offscreen-port helpers (all Ghidra-truncated): `FUN_00000e3e` →
  blit_pixels_via_port_a5safe (slot −0x10ee), `FUN_00000e9e` →
  open_offscreen_cport_a5safe (slot −0x1106), `FUN_00000ca6` →
  new_offscreen_cport (NewPtrClear 0x6c + OpenCPort; used by
  blit_offscreen_frame_to_window; +1 call site). Corrected a same-iteration
  hypothesis (ca6 duplicates rather than calls e9e).
- QA: first doc-update script had a syntax error and wrote nothing; re-run.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 150 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 149 preserved.
- `FUN_000014e6` = swap_mmu_mode_a5safe (CurrentA5; ID09 SwapMMUMode glue on
  byte A5−0x1000; slot −0x10c6).
- `FUN_000011ec` (slot −0x10ea) partially read: two FUN_000010ce polygons
  painted/filled/framed in standard grey indices, offset and repeated; marked
  INVESTIGATING (no rename). Counts: 1 INVESTIGATING.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 151 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 150 preserved.
- `FUN_000010ce` = build_notched_frame_poly(Rect): polygon with V-notches on
  both sides and chamfered bottom, sized from width/4 and pen size.
- `FUN_000011ec` resolved enough to rename: draw_notched_frame_pair_a5safe
  (same rect A5−0x119c built with pen 2 and pen 1, filled/framed in grey
  indices, drawn twice with a horizontal shift). Purpose still UNKNOWN.
  INVESTIGATING count back to 0.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 152 — 2026-10-17

- Working tree clean at start (user committed iterations 148-151); 32
  protected hashes verified.
- `FUN_00001308` = draw_text_in_columns_a5safe (FillRect with QD black/white
  patterns, TextFace/CharWidth, DrawString segments aligned with GetPen/Move to
  column origins A5−0x14d2/−0x14d0/−0x14ce; DrawText path when arg $18 == 0).
  Identified QD globals: white A5−0x1614, black A5−0x161c (below thePort
  A5−0x160c).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 153 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 152 preserved.
- ID06 identified as a self-contained rasterizer module with three A5
  structures: target record A5−0x1cce (base, width +8, height +0xa; centre
  A5−0x1cca/−0x1cc8), row table A5−0x1cd2 (one 12-byte entry per row),
  node pool A5−0x1cd6 (0x5e9c bytes, two linked sentinels).
- Renamed the set-up functions first (needed to read the service entries):
  init_raster_target, alloc_row_table, init_edge_pool, free_row_table,
  set_raster_target_base (+5 call sites). ID06.decomp.c was an unmodified seed.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 154 — 2026-10-17

- Working tree clean at start (user committed iterations 152-153); 32
  protected hashes verified.
- Renamed the four ID06 service entries plus a set-up helper:
  set_active_row_count (−0x1304), reset_edge_table (−0x1310),
  add_polygon_edges (−0x130c; scanline edge-table insertion with clipping and
  fixed-point slopes), rasterize_and_present (−0x1308; renderer callback JT
  $192 = ID06 FUN_00000318, banded output through ID02
  blit_offscreen_frame_to_window), init_row_table_fields.
- **All 34 overlay service-table slots are now named.**
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 155 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 154 preserved.
- `FUN_00000318` = render_scanline_spans: per row, insert bucket edges into a
  sorted active list, retire finished edges, toggle polygon parity and keep a
  priority-ordered open-polygon list, fill longs from the row pattern table
  with the topmost colour, step x by slope. Its state (Ghidra DAT_0000039e..)
  is a 0x44-byte zero block inside the code, skipped by BRA.B at 0x39c
  [PROVEN] (self-modifying data, persists across bands).
- `FUN_00000d84` / `FUN_00000dca` = rebase_edge_rows_for_band /
  restore_edge_rows_after_band.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 156 — 2026-10-17

- Verified 32 protected hashes; uncommitted iterations 154-155 preserved.
- Wrote `docs/RASTERIZER.md`: ID06 global structures, row-entry and
  edge-node layouts, API table with service slots, frame flow, in-code
  span-renderer state, open questions. Documentation only; no code changes.

### Iteration 157 — 2026-10-17

- Verified 32 protected hashes; uncommitted iterations 154-156 preserved.
- Renamed five ID06 helpers (complete C): alloc_aligned_clear (FreeMem <
  500000 → MaxMem; NewPtrClear(size+12) aligned to 4 with size/raw-pointer
  header; 7 call sites), free_aligned (4), rgb_to_bw_pattern (luma
  19/38/7 → 64 inverse-brightness patterns at A5−0x1ed6), lookup_colour_map
  (2) / reverse_lookup_colour_map (256-word table at *A5−0x1ede).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 158 — 2026-10-17

- Verified 32 protected hashes; uncommitted iterations 154-157 preserved.
- Renamed the last six ID06 functions: init_pattern_tables (32 edge masks,
  64 replicated 8-row patterns from A5−0x1ed6, 16-level grey map at
  *A5−0x1ede), alloc_pattern_tables, get_pattern_table,
  get_raster_target_size, realloc_row_table, add_rect_polygon.
  **ID06 is fully RENAMED (24/24).** RASTERIZER.md updated.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 159 — 2026-10-17

- Nine copies of the scheduled prompt were queued at once; one iteration run.
  Working tree clean at start (user committed iterations 154-158); 32
  protected hashes verified. ID03.decomp.c was an unmodified seed.
- ID03 `FUN_000032b8` (contains the 0x3788 / 0x3828 port calls) is a large
  Ghidra-truncated drawing routine; deferred until its helpers are named.
- Renamed five ID03 helpers (complete C): scale_design_480_min10,
  scale_design_4800 (13 call sites), scale_design_4800_pen_centred, max3_int,
  nearest_palette_index_rgb (Chebyshev distance; extended-table scan returns
  the first better entry - preserved). JT $4da = ID02 FUN_0000001e (abs),
  noted only (ID02 not edited this iteration).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 160 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 159 preserved.
- Renamed three Ghidra-truncated ID03 helpers from bytes: set_scaled_text_style
  (TextFace plain/bold + TextSize via scale_design_4800, by mode),
  new_offscreen_bw_port (1-bit bitmap, OpenPort/SetPortBits/PortSize/RectRgn;
  2 call sites), dispose_offscreen_bw_port.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 161 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 160 preserved.
- `FUN_00000912` = draw_vector_number (decimal digits drawn from stroke
  lists char *A5−0x1fde[d], centred at 6 units per digit, scaled).
- `FUN_0000035e` partially read (regions, PaintOval/FrameOval, grey index,
  ticks; ID02 JT $3ca/$382 unnamed) — INVESTIGATING, no rename.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 162 — 2026-10-17

- Verified 32 protected hashes; uncommitted iterations 159-161 preserved.
- ID02: `FUN_00001656` / `FUN_00001680` = design_x_to_screen /
  design_y_to_screen (scale by A5−0x149e/4800 plus half view width / height:
  A5−0x1372 / A5−0x1370); `FUN_00001632` = set_back_color_index;
  `FUN_0000001e` = abs_long. MULU.L-vs-signed multiply equivalence noted.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 163 — 2026-10-17

- Working tree clean at start (user committed iterations 159-162); 32
  protected hashes verified.
- Fully decoded ID03 `FUN_0000035e`: grey disc (PaintOval) with a black spoke
  that steps through vertical / two diagonals / horizontal, phase A5−0x2112
  advanced (phase+5)&3 per call, clipped to the oval outline region.
  Renamed draw_spinning_disc_indicator; INVESTIGATING count back to 0.
  Callers: 5 BSRs inside FUN_00000514.
- QA: the first scripted write failed (f-string brace error) after the docs
  were already updated; the ID03 edit was re-applied and re-validated so
  code and docs agree.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 164 — 2026-10-17

- Working tree clean at start (user committed iteration 163); 32 protected
  hashes verified.
- ID03 `FUN_00000514` = draw_ring_with_status_indicators: black disc, grey
  ring (pen w/10), then for flag bits 0..4 a spinning indicator offset by
  (d/2)·cos45 + 30 design units on the diagonals (constant 0xb50 >> 12).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 165 — 2026-10-17

- Working tree clean at start (user committed iteration 164); 32 protected
  hashes verified.
- Callers of draw_ring_with_status_indicators found by BSR scan: ID03 0x3c22,
  0x3c40, 0x4c58, 0x4ee2, 0x5346, 0x5516 (several instrument routines).
- `FUN_00000a3c` (≈2.6 KB, no Ghidra body) partially read: seven 1-bit source
  rows, per-pixel bit masks A5−0x1fb6[x&7], weighted vertical sums into an
  output buffer — supersampling/anti-alias HYPOTHESIS. INVESTIGATING; header
  comment only (no token change).
- Validation: token diff unchanged; Ghidra comments intact; hashes OK.

### Iteration 166 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 165 preserved.
- Finished ID03 `FUN_00000a3c`: per output pixel a 7×7 window of the 1-bit
  source with a symmetric Gaussian-like kernel (total weight 969 = 0x3c9),
  level = sum·0xffff/969 → grey RGB → nearest_palette_index_rgb →
  set_draw_color_index → plot with MoveTo + Line(0,0); source advances 3
  pixels / 3 rows per output pixel/row; optional index output buffer.
  Renamed antialias_downsample_bw_3x; INVESTIGATING back to 0.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 167 — 2026-10-17

- Working tree clean at start (user committed iterations 165-166); 32
  protected hashes verified.
- ID03 `FUN_00003c02` = draw_instrument(type, geometry...): bezel via
  draw_ring_with_status_indicators (flags 0x1b for type 6, else 0x0f), dark grey,
  then type switch 0..9 → FUN_00001876 / 1b48 / 2d1c / 1fee / 2600 / 22fe /
  2950 / (none) / 32b8 / 38fc, then per-type record A5−0x12a2 + 16·type.
  Ghidra decoded the switch table bytes as statements (noted, kept verbatim).
- Re-interpreted draw_spinning_disc_indicator as a bezel screw head
  (HYPOTHESIS, header updated; name kept because it describes the mechanics).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 168 — 2026-10-17

- Working tree clean at start (user committed iteration 167); 32 protected
  hashes verified.
- **STR# 129 text located**: `artifacts/reverse-engineering/resources/
  resource_dasm_Hellcats_app/…STR#_129_English Strings_<n>.txt`, files
  0-based (game slot = n + 1). Calibrated: slot 93 = "Out of memory.  Sorry"
  (confirms ID02 fatal_memory_error_exit), and "\p" prefixes match
  load_str129_string_table's Pascal marker.
- Instrument type 0 (`FUN_00001876`) label = slot 65 "ALTITUDE" → renamed
  draw_altimeter. `FUN_00001538` → begin_instrument_supersample (1× B&W or 3×
  supersampled B&W port; 11 call sites).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 169 — 2026-10-17

- Working tree clean at start (user committed iteration 168); 32 protected
  hashes verified.
- Scripted scan of each instrument drawer for STR# 129 pointer-table loads
  (A5−0xf46 + 4·slot) identified six more gauges by their labels: type 1 AIR
  SPEED, 2 TURN BANK, 3 CLIMB, 4 Manifold Pressure, 5 RPM, 6 DIRECTION.
  Renamed draw_airspeed_indicator, draw_turn_and_bank_indicator,
  draw_climb_indicator, draw_manifold_pressure_gauge, draw_tachometer,
  draw_direction_indicator. Types 8 / 9 (FUN_000032b8 / FUN_000038fc) load no
  label strings - still unnamed. draw_instrument switch comment updated.
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 170 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 169 preserved.
- Wrote `docs/INSTRUMENT_PANEL.md`: STR# 129 label table (slots 1, 61, 65-77),
  instrument types 0-9, drawing pipeline (supersample → gauge → anti-alias →
  dispose), bezel / screw hypothesis, open questions. Documentation only.
- New leads: slot 61 "Hellcats requires a Macintosh with color QuickDraw and a
  68020 or higher" (likely the seg-4 start-up gate in initialize_application;
  consistent with EXTB.L / MULU.L use); slots 75-77 FLAPS / AMMO / Fuel unused
  by types 0-6; slot 1 "Unable to store instrument panel to disk".

### Iteration 171 — 2026-10-17

- Verified 32 protected hashes; uncommitted iterations 169-170 preserved.
- Whole-binary scan for STR# 129 slots 1 / 61 / 75-77:
  - ID03 `FUN_00004c42` (FLAPS), `FUN_00004ecc` (AMMO), `FUN_0000532e` (Fuel) -
    renamed draw_flaps_indicator / draw_ammo_counter / draw_fuel_gauge (each
    also draws a bezel; outside the draw_instrument switch).
  - ID04 `FUN_00003d42` uses slot 61 ("requires color QuickDraw and a 68020");
    file 0x3d42 is JT $f2, the start-up gate in ID02 initialize_application.
  - ID04 `FUN_000003c2` uses slot 1 ("Unable to store instrument panel to disk").
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 172 — 2026-10-17

- Working tree clean at start (user committed iterations 169-171); 32
  protected hashes verified. ID04.decomp.c was an unmodified seed.
- `FUN_00003d42` = check_system_requirements (SysEnvirons; needs Color
  QuickDraw and processor >= env68020, else alert STR# 129 slot 61 and return
  0) - the JT $f2 start-up gate of initialize_application.
- `FUN_000003c2` = run_with_temporary_window (creates once a "Hellcats"
  window inset 100 px from the screen, shows it around JT $4aa = ID02 0x2db8,
  hides it).
- Correction: the STR# 129 slot-1 user ("Unable to store instrument panel to
  disk") is the unexported routine at ID04 0x432, not FUN_000003c2 (the
  iteration-171 scan attributed hits to the nearest preceding Ghidra entry).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 173 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 172 preserved.
- ID02 `FUN_00002db8` = wait_for_click_or_key (SystemTask/GetNextEvent loop;
  mouseDown/keyDown/autoKey return, update → redraw_main_window, activate →
  handle_activate_event) - what run_with_temporary_window shows the window
  around. `FUN_00004d34` = process_pending_update_events (updateMask loop).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 174 — 2026-10-17

- Working tree clean at start (user committed iterations 172-173); 32
  protected hashes verified.
- ID02 `FUN_00002e36` = show_resource_file_error_box (dBox window with
  "Can't open resource file." / "Click mouse to exit.", wait for Button).
- Unexported ID02 0x2eaa documented as quit_application: confirm via seg4
  0x516 (== 2), save prompt via seg4 0x4f0 when settings are dirty (1 save,
  2 cancel, else discard), HideWindow, ExitToShell.
- Validation: token diff = renames only; hashes OK.

### Iteration 175 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 174 preserved.
- ALRT/DITL resources are in the resource dump (ALRT 257 "Save Changes",
  258 "Error" = "^1 ^0.", 259 "Really End Mission", 260 "Erase Hi Score").
- Renamed ID04 alert wrappers: ask_save_changes (0x4f0, JT $ba; items Save /
  Cancel / Don't Save match quit_application's switch), confirm_end_mission
  (0x516, JT $13a; asks only while a mission is in progress, 2 = End
  Mission / proceed), confirm_erase_high_scores (0x560).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 176 — 2026-10-17

- Working tree clean at start (user committed iterations 172-175); 32
  protected hashes verified.
- ID04 `FUN_00000588` = compute_pilot_score (Σ 12 record tallies × 12 weights).
- Resource dump names HEL1 128 "Player and Score Data" (20 × 0x40 records;
  shipped empty) and HEL1 127 "Hellcats Saved Settings". The ID07 string groups
  are now identified: A5−0xffe = ranks (Ensign … Captain), A5−0xfae = pilot
  status (Active, Dead, Retired, POW, Discharged, MIA), A5−0xf86 = 10 target
  types (Fighter … Runway).
- Validation: token diff = renames only; hashes OK.

### Iteration 177 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 176 preserved.
- Collected every pilot-record access in the exported C and wrote
  `docs/PILOT_ROSTER.md` (20 × 0x40 layout: name +0x00, +0x20 word, rank
  +0x22, +0x24/+0x26, 12 tallies +0x28; related string groups; functions).
- Renamed ID04 rank_pilots_by_score (0xf4e), reset_pilot_record (0x1106),
  build_rank_and_name_string (0x1a0e).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 178 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 177 preserved.
- ID04 `FUN_000031aa` = conclude_mission (JT $da; called from ID02 0x8cc and
  do_menu_command menu 2 item 5): one-shot FUN_00003124 when status == 1
  (Dead) and an option is on, sets mission-over flag A5−0x14c4 for non-zero
  status, calls FUN_00002de6 / FUN_00003178, writes status A5−0x12b4 into the
  current pilot record +0x20. Record +0x20 = status now STRONG INFERENCE.
- Validation: token diff = renames only; hashes OK.

### Iteration 179 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 178 preserved.
- ID04 `FUN_00003124` = play_named_sound_async (GetNamedResource 'snd ' by
  the Pascal name at A5−0x2128, HLock, SndNewChannel, SndPlay async) and
  `FUN_00003178` = stop_named_sound (SndDisposeChannel, HUnlock,
  ReleaseResource). conclude_mission plays it once when the pilot dies.
  The dump lists named 'snd ' resources (Hit, Ditch, Explosion, Gear, ugh,
  Engine, ...); the exact name is in A5 initial data (not read).
- Validation: token diff = renames only; Ghidra comments intact; hashes OK.

### Iteration 180 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 179 preserved.
- ID04 `FUN_00002de6` = show_mission_summary_dialog: GetNewDialog(133);
  DLOG 133 "Mission Summary" (dump) has End Mission / OK / Skip Text buttons and
  "Mission Awards", "Targets Destroyed", "Total Aircraft Destroyed", "Score"
  texts; the 12-iteration loop matches the 12 pilot tallies (supports tallies =
  targets destroyed).
- Validation: token diff = renames only; hashes OK.

### Iteration 181 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180 work preserved.
- Ghidra could not decode ID04 0x06..0x21a (halt_baddata stubs); decoded the
  bytes. Ten Toolbox dialog wrappers built on GetDItem ($A98D):
  disable/enable_dialog_control (HiliteControl 255/0), hide/show_dialog_control,
  set_dialog_item_text (SetIText), set_dialog_control_title (SetCTitle),
  set_dialog_user_item_proc (SetDItem with a ProcPtr), frame_dialog_item_box,
  and two Pascal user-item procedures: draw_default_button_outline (JT $12a ->
  0x16e; item number in A5-0x225e, set by the unexported installer at 0x1b8)
  and draw_grey_user_item (JT $142 -> 0x1f2; FillRect with gray A5-0x1624).
- Validation: token diff = renames only (4416 tokens); Ghidra warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 182 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180–181 work preserved.
- ID04 0x17e6 = create_scrolling_text_item (TextEdit record A5-0x223a +
  scrollBarProc control A5-0x2236 beside the item box, user item JT $92 ->
  0x14f2); 0x189c = dispose_scrolling_text_item; 0x18b0 =
  append_line_to_scrolling_text (ID02 0x3e8 is strlen, then two TEInsert calls
  and the 0x158c scroll update). Used by the Mission Summary dialog.
- No direct JSR to 0x189c / 0x18b0 in ID04 bytes; caller path open.
- Validation: token diff = renames only; Ghidra warnings intact; 32 hashes OK.

### Iteration 183 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180–182 work preserved.
- Completed the ID04 scrolling-text component (TERec A5-0x223a, scroll bar
  A5-0x2236, visible lines A5-0x2232): draw_scrolling_text_item,
  scrolling_text_user_item_proc (JT $92), sync_text_scroll_to_control,
  update_scroll_bar_maximum, scroll_text_to_show_selection,
  fit_text_view_to_box, scroll_bar_action_proc (JT $16a; inline switch table
  at 0x16fe, parts 20..23; Ghidra decoded it as `*unaff_A4 |= …` stores).
- Documented the unexported click handler at 0x1752 (FindControl /
  TrackControl) inside the scroll_bar_action_proc header.
- Validation: token diff = renames only (33 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 184 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180–183 work preserved.
- ID04 0x18e0 = get_mission_kill_report_state: 0 when A5-0x12f8 == 2, 2 when
  A5-0x14c0 == 0 and A5-0x12ba > 0, 1 when any of ten words at A5-0x12ce is
  set. A 0 result makes confirm_end_mission skip its alert and makes the summary
  append STR# slot 50 "No new kills to report."; the ten words match the ten
  target types (kill counts, STRONG INFERENCE).
- ID04 0x192e = update_summary_dialog_buttons: enables items 1 (End Mission)
  and 3 (OK) by state; moves the default-button ring to item 1 with
  EraseRect / InvalRect and A5-0x225e = 1.
- Correction: the DITL dump numbers items from 0; Toolbox item n = dump item
  n−1 (item 1 End Mission, 2 ring user item, 3 OK, 4 Skip Text).
- Validation: token diff = renames only (35 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 185 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180–184 work preserved.
- Bytes 0x2104..0x2d84 sit inside Ghidra's `FUN_000020e8` range and hold two
  unexported functions, documented in a comment block in `ID04.decomp.c`:
  0x2104 (JT $ca) = Mission Summary ModalDialog filter (keyDown Return/Enter ->
  default item, mouseDown -> scroll-text click handler, updateEvt -> ID02
  0x4d6a, timer -> text step every A5-0x2230 ticks, A5-0x222c last tick);
  0x21d6 = text step state machine on A5-0x2222 (states 0..5, 100 =
  finished). Sparse switch-table format of ID01 JT $2a / $32: count, then
  (offset, value) pairs, then default offset, offsets relative to their own
  word.
- ID04 `FUN_00002d86` = set_score_item_text ("Score: " + pilot score).
- Validation: token diff = renames only (36 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 186 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180–185 work preserved.
- ID04 `FUN_00001f5e` = draw_aircraft_kill_markers: one framed red disc per
  aircraft destroyed (pilot tallies 0 + 1, Fighter + Bomber, capped at 24) in a
  6-column grid; drawn in item 7 of DLOG 133, directly under the "Total
  Aircraft Destroyed" label (DITL dump item 6).
- ID04 `FUN_000020e8` = aircraft_kill_markers_user_item_proc (JT $ea).
- Validation: token diff = renames only (38 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 187 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180–186 work preserved.
- Mission Summary user items (show_mission_summary_dialog 0x2e34..0x2e90):
  item 6 JT $aa = `draw_targets_destroyed_list` (`FUN_00001d9e`, rows via
  `draw_targets_destroyed_row` = `FUN_00001bc8`, types 2/4/8 skipped);
  item 5 JT $152 = unexported draw_mission_awards (0x1dde; record +0x26 bits
  0..7 -> cicn 512..519); item 7 JT $ea = aircraft kill markers; item 9
  JT $7a = `build_rank_and_name_string` (correction: it is a Pascal user item
  that also draws the string); item 15 JT $15a = unexported draw_rank_insignia
  (0x1b3e; cicn 256 + rank).
- Validation: token diff = renames only (40 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 188 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 180–187 work preserved.
- Decoded the body of `draw_targets_destroyed_row` (annotation only, no new
  rename): 23-pixel rows; label = target name + separator + count; points =
  count × weight[type] (A5-0xf5e, same weights as compute_pilot_score) drawn
  right-aligned. Counts come from the summary's local array (A5-0x2226 ->
  show_mission_summary_dialog -0x4a(A6)), which the text step increments
  together with A5-0x13a2.
- Validation: token diff unchanged (40 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 189 — 2026-10-17

- Phase A: working tree clean (user committed iterations 180–188); 32
  protected hashes OK.
- Decoded state 3 of the ID04 summary text step (0x2a2e..0x2b70, annotation
  in the iteration-185 comment block): for each target type with mission
  kills A5-0x12ce[t] = n, adds n to pilot tally[t], A5-0x13a2[t] and the
  summary counts, clears A5-0x12ce[t], appends "n name(s)" and redraws the
  score (item 14), the targets row (item 6) and the kill markers (item 7).
  After the last type: ChangedResource(roster) + UpdateResFile(A5-0x1002),
  state 4. Answers the roster write-back question.
- Validation: token diff unchanged (40 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 190 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189 work preserved.
- Decoded states 4 and 5 of the ID04 summary text step (annotation in the
  iteration-185 comment block): state 4 compares compute_pilot_score with the
  rank thresholds (longs at A5-0xfd6), promotes (record +0x22 = highest rank
  whose threshold <= score), saves the roster and queues STR# 53 or 54–55;
  state 5 prints the queued lines, then "You are (posthumously) promoted to
  the grade of <rank>" (STR# 56/57) and invalidates items 15 (insignia) and 9
  (rank + name) so they redraw. No promotion -> state 100 (finished).
- Validation: token diff unchanged (40 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 191 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–190 work preserved.
- Decoded states 1 and 2 of the ID04 summary text step (annotation): state 1
  prints queued lines, then goes to state 2 or ends with "Player's
  Cumulative History" (A5-0x2228 != -1). State 2 grants mission award bit
  (A5-0x12f8 - 3) in record +0x26 when the summary argument's low byte is 1
  and the pilot is not dead (saves the roster, redraws item 5), then prints
  "No new kills to report." (end) or "Now adding points…" / "==== Kills ===="
  and enters state 3. Noted an unreachable branch at 0x29d8..0x29f0.
- Validation: token diff unchanged (40 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 192 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–191 work preserved.
- Decoded state 0 of the ID04 summary text step (outcome narrative,
  annotation): outcome code = low byte of A5-0x2220 (switch 1..10: flight end,
  mission-in-progress summary, ditching, bail-out, disabled landing, landing,
  enemy-base landing); location / rescue lines from the high-byte flags and
  pilot status; friendly-fire handling (A5-0x12b6, record +0x24 offence
  count: warning, second warning, discharge; ≥ 5 friendly kills = executed);
  lost-aircraft lines and A5-0x12ba objective state. The whole summary text
  step (states 0–5) is now documented.
- Validation: token diff unchanged (40 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 193 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–192 work preserved.
- ID04 dialog helpers: `FUN_00000220` = draw_percent_bar_item (A5-0x225c,
  0..100, set by mouse tracking at 0xb3c and stored in settings word +0x22 of
  A5-0x13ac); `FUN_000002c0` = percent_bar_user_item_proc (JT $8a);
  `FUN_00000362` = get_radio_group_selection; unexported 0x2dc =
  set_radio_group_selection (documented in the 0x2c0 header).
- Validation: token diff = renames only (43 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 194 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–193 work preserved.
- ID04 `FUN_00000a8e` = fuel_slider_dialog_filter (shared ModalDialog filter
  core: Return/Enter -> item 1, slider tracking, update events);
  `FUN_00000bda` = scenario_selection_filter_proc (JT $112, DLOG 129
  "Scenario Selection", slider item 5); `FUN_00000e48` =
  refuel_dialog_filter_proc (JT $14a, DLOG 132 "Refuel", slider item 3).
  The percentage bar A5-0x225c is the fuel load ("Fuel: E … F"); radio
  buttons 0/1/2 are the bomb count.
- Validation: token diff = renames only (46 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 195 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–194 work preserved.
- Decoded the unexported Refuel dialog runner at ID04 0xe70 (JT $9a,
  annotation in the refuel_dialog_filter_proc header): GetNewDialog(132),
  default ring on user item 2, fuel bar item 3, bomb radio group (list at
  A5-0x2240, always preset to item 6), ModalDialog loop until OK, then bomb
  count A5-0x12d0 = selection - 4 and fuel A5-0x12d2 = A5-0x225c.
- Validation: token diff unchanged (46 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 196 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–195 work preserved.
- Decoded the unexported Scenario Selection runner at ID04 0xc02 (JT $82,
  annotation in the scenario_selection_filter_proc header): mission radio
  group (A5-0x2256, mission = item - 7), bomb group (A5-0x2246, bombs =
  item - 6), fuel bar; Cancel returns 0; OK goes through confirm_end_mission
  and writes settings +0x1e mission, +0x20 pilot, +0x22 fuel, +0x24 bombs
  (dirty flag A5-0x138a), then apply_settings_to_live_options and
  A5-0x12f8 = mission. Mission numbers: 2 Flight School, 3 Bomb Base,
  4 Capture Island, 5 Flying Fortress, 6 Scramble!, 7 Divine Wind,
  8 Flattop, 9 The Duel.
- Validation: token diff unchanged (46 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 197 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–196 work preserved.
- ID04 `FUN_000009ee` = draw_select_mission_title (JT $11a, "Select a
  Mission" title of DLOG 129); `FUN_0000116a` =
  prune_inactive_pilots_beyond_ten (keeps the ten best non-Active pilots,
  clears the rest, WriteResource on the roster).
- Validation: token diff = renames only (48 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 198 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–197 work preserved.
- ID04 `FUN_0000044e` = show_scenery_open_error_alert (ALRT 256);
  `FUN_00000478` = show_paused_dialog (DLOG 131); `FUN_000005e4` =
  duty_roster_filter_proc (JT $c2). Documented the unexported Duty Roster
  runner at 0x644 (JT $132, DLOG 130): ranks and prunes the roster, lists up
  to ten Active pilots (rank, editable name, score), "Dossier…" opens
  show_mission_summary_dialog for the selected pilot, OK saves renamed pilots
  and selects the current pilot.
- Validation: token diff = renames only (51 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 199 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–198 work preserved.
- ID04 map view: `FUN_00003260` = draw_map_grid_and_centre_mark,
  `FUN_00003352` = plot_map_symbol_callback (JT $72; DrawChar per object),
  `FUN_000033d6` = draw_map_view_item (blue sea, plotting through the function
  pointer A5-0x1052, scale text "<n> mi./grid" from settings +0x26).
- Validation: token diff = renames only (54 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 200 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–199 work preserved.
- ID04 map dialog (DLOG 137 "Map"): `FUN_000035f8` = map_view_user_item_proc
  (JT $b2), `FUN_00003902` = map_dialog_filter_proc (JT $d2); documented the
  unexported bearing / distance tool at 0x3614 (rubber-band line from the
  centre, bearing via A5-0x1056, distance via A5-0x105a, items 5 / 6) and the
  runner at 0x3976 (JT $10a; Zoom In / Out halve / double settings +0x26,
  1..256; skipped in Flight School). Legend letters + T C B A from DITL 137.
- `FUN_00003a56` = poll_click_or_key_event; `FUN_00003a8c` =
  show_about_dialog (DLOG 127, or 138 when A5-0x137a == 1 = 1-bit mode).
- Validation: token diff = renames only (58 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 201 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–200 work preserved.
- ID04 `FUN_00001200` = draw_high_scores_table (DLOG 134 "High Scores":
  rank, name, status, score for up to ten pilots); documented the unexported
  runner at 0x137a (JT $102; "Erase Nonactive…" resets every non-Active
  record after confirm_erase_high_scores and saves the roster).
- ID04 is now fully renamed: 59 / 59 Ghidra functions, plus unexported routines
  documented in comments (0x1b8, 0x2dc, 0x432, 0x644, 0xc02, 0xe70, 0x137a,
  0x1752, 0x1b3e, 0x1dde, 0x2104, 0x21d6, 0x3614, 0x3976).
- Validation: token diff = renames only (59 ID04 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 202 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–201 work preserved.
- ID03 instrument types 8 and 9: the cached instrument bitmaps are saved by
  ID03 0x5b5e..0x5d44 with AddResource (type HEL2) under STR# 129 names
  "Bitmap" (A5-0x12b0), "HorizonInstrument" (A5-0x11f6), "GyroInstrument"
  (A5-0x11dc), "GyroFlags" (A5-0x11d4), "Bitmap Cache" (A5-0x13b2). Type 9
  (`FUN_000038fc`, uses A5-0x11f6) = draw_artificial_horizon; type 8
  (`FUN_000032b8`, uses A5-0x11dc / -0x11d4) = draw_gyro_instrument;
  `FUN_00003832` = make_inset_face_oval_region.
- Validation: token diff = renames only (27 ID03 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 203 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 189–202 work preserved.
- ID03 `FUN_00005ab6` = store_panel_bitmaps_as_resources: replaces HEL2
  200 / 300 / 400 / 500 + configuration A5-0x13ae with the panel bitmaps
  ("Bitmap", "HorizonInstrument", "GyroInstrument", "GyroFlags"); on any
  ResError clears the "stored" flag +0xc of the "Bitmap Cache" entry
  (0x160 bytes per configuration) and sets A5-0x14a0, which the ID04 routine
  at 0x432 reports as "Unable to store instrument panel to disk" (closes the
  question from iteration 172). Documented the release routine at 0x59f4.
- Validation: token diff = renames only (28 ID03 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 204 — 2026-10-17

- Phase A: iterations 180–203 staged by the user (index), working tree
  otherwise clean; 32 protected hashes OK.
- ID03 `FUN_00005c36` = open_cport_on_buffer, `FUN_00005cb6` =
  close_port_glue, `FUN_00005cc4` = prepare_instrument_panel (JT $17a):
  panel scale A5-0x149e = 0.75 × half view width; Bitmap Cache (HEL2 127,
  4 × 0x160) entries keyed by 1-bit mode, A5-0x137e / -0x137c and view size;
  a matching stored entry restores the instrument records (A5-0x12a2) and
  reloads the HEL2 bitmaps instead of redrawing.
- Validation: token diff = renames only (31 ID03 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 205 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 204 work preserved.
- ID03 `FUN_00005860` = compute_panel_screen_addresses (screen byte
  addresses base A5-0x1382 + y × rowBytes A5-0x1378 + x / (8 / depth));
  `FUN_00006c1c` = remap_cached_panel_colours (JT $182). Correction:
  A5-0x137a is the pixel depth (1 / 4 / 8), "== 1" meaning 1-bit mode.
- Validation: token diff = renames only (33 ID03 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 206 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 204–205 work preserved.
- ID03 `FUN_0000077e` = draw_vector_glyph_string_centred (stroke font,
  glyph table A5-0x20b0; used by draw_direction_indicator);
  `FUN_0000146a` = composite_instrument_bitmap; `FUN_00001844` =
  finish_instrument_supersample (the end of the begin_instrument_supersample
  sequence, used by four gauges).
- Validation: token diff = renames only (36 ID03 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 207 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 204–206 work preserved.
- ID03 `FUN_00003f24` = draw_bevelled_frame, `FUN_00004110` =
  draw_numbered_bevel_box. `FUN_00004304` (caller of both, three numbered
  boxes at A5-0x11c6 / -0x11be / -0x11b6, tick loops) left NOT_STARTED:
  purpose not yet clear.
- Validation: token diff = renames only (38 ID03 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 208 — 2026-10-17

- Several queued loop prompts arrived together; ran one iteration.
- Verified 32 protected hashes; uncommitted iteration 204–207 work preserved.
- ID03 `FUN_00004790` = draw_percent_scale_gauge (vertical 0–100 scale with
  ten ticks and vector-font labels, drawn by the panel redraw path at
  0x681e; role open).
- Validation: token diff = renames only (39 ID03 renames); warnings intact;
  32 hashes OK.

### Iteration 209 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 204–208 work preserved.
- ID03 `FUN_00004b32` = draw_split_display_box: framed panel box whose inset
  rect is split into the halves A5-0x119c (drawn by ID02
  draw_notched_frame_pair_a5safe) and A5-0x1194 (read by ID02 0x1206).
- Validation: token diff = renames only (40 ID03 renames); warnings intact;
  32 hashes OK.

### Iteration 210 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 204–209 work preserved.
- ID03 `FUN_00004304` = draw_panel_section_with_numbered_boxes (descriptive
  name): dark panel area A5-0x11aa, two 26-step line loops, bevel, and three
  numbered bevel boxes 1 / 3 / 15 stored at A5-0x11c6 / -0x11be / -0x11b6;
  meaning open.
- Validation: token diff = renames only (41 ID03 renames); warnings intact;
  32 hashes OK.

### Iteration 211 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 204–210 work preserved.
- ID03 `FUN_000054fe` = draw_landing_gear_indicator (label STR# 78 "GEAR",
  three lamp positions); `FUN_00005718` = dial_point_at_angle (answers the
  open question on A5-0x2118: with A5-0x211c they are the cosine / sine
  function pointers, 4.12 fixed point, 0x4000 per turn).
- Validation: token diff = renames only (43 ID03 renames); warnings intact;
  32 hashes OK.

### Iteration 212 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 204–211 work preserved.
- ID03 `FUN_00005158` = draw_arc_scale_ticks (documents the unexported
  two-arc gauge at 0x532e); `FUN_000071a2` = remap_panel_colours_identity.
- ID03 is now fully renamed (45 / 45).
- Validation: token diff = renames only (45 ID03 renames); warnings intact;
  32 hashes OK.

### Iteration 213 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–212 work preserved.
- ID02 0x38..0x2ee is the C runtime library: div, ldiv, the eleven ANSI
  ctype tests on the class table A5-0x1608 (bits 0x80 lower, 0x40 upper,
  0x20 hex letter, 0x10 digit, 0x08 punct, 0x04 space char, 0x02 white
  space, 0x01 control), toupper, tolower, memcpy, memmove, strcpy, strcat,
  strcmp - renamed with an `ansi_` prefix (20 functions).
- Validation: token diff = renames only (87 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 214 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–213 work preserved.
- ID02 0x30c..0x412: strchr, strcspn, strpbrk, strrchr, strspn, strstr,
  strtok (save pointer A5-0x1508), strncpy, strncat - `ansi_` prefix,
  9 functions, all complete Ghidra C.
- Validation: token diff = renames only (96 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 215 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–214 work preserved.
- ID02 `FUN_0000045a` = begin_overlay_session (UnloadSeg 4, heap check,
  sound start, overlay hooks A5-0x1082 / -0x107e; documents the matching
  end at 0x4a4: shutdown_sound, hook A5-0x1076, DrawMenuBar);
  `FUN_000004c6` = ensure_free_memory_and_init_sound (ID09 glue: JT $212 =
  FreeMem $A01C, JT $21a = MaxMem $A11D); `FUN_00000930` =
  call_overlay_session_hooks.
- Validation: token diff = renames only (99 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 216 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–215 work preserved.
- ID02 `FUN_000004fc` = run_flight_session: the game loop around the overlay
  (set-up, begin_overlay_session, per-frame hook A5-0x107a(1, 1) with key /
  event dispatch to the hook A5-0x106a, frame counter A5-0x14fc), then
  end_overlay_session, pilot status saved to the roster, and a switch on the
  result (conclude_mission with "Resume", quit_application,
  show_paused_dialog, restart).
- Validation: token diff = renames only (100 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 217 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–216 work preserved.
- ID02 `FUN_0000150a` = get_blended_fill_pattern (JT $3e2; RGB tables
  A5-0x350 / *A5-0x14a6, 6 bytes per index); `FUN_000016aa` =
  draw_view_frame_outline.
- Validation: token diff = renames only (102 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 218 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–217 work preserved.
- ID02 sound resources and dialogs: `FUN_00001dd4` =
  show_sound_error_dialog_once (DLOG 139), `FUN_00001e32` =
  show_creating_panel_dialog (DLOG 128), `FUN_00001e68` =
  release_sound_slots, `FUN_00001edc` = load_named_sound_into_slot (20 slots
  at A5-0xd62). ID09 glue: JT $262 RecoverHandle, $272 HLock, $27a HUnlock,
  $282 HPurge, $28a HNoPurge.
- Validation: token diff = renames only (106 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 219 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–218 work preserved.
- ID02 `FUN_00001f8e` = load_game_sounds, `FUN_000020be` = lock_sound_slots,
  `FUN_0000212a` = reset_overlay_state (hypothesis name), `FUN_0000435e` =
  position_window_on_screen. ID09 JT $242 = GetPtrSize ($A021).
- Validation: token diff = renames only (110 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 220 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–219 work preserved.
- ID02 `FUN_00002192` = scan_display_devices: GetMainDevice / GetDeviceList
  walk; records for the main screen and for identical monitors directly to
  its right and left (A5-0x1358 / -0x1342 / -0x132c, 0x16 bytes each).
- Validation: token diff = renames only (111 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 221 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–220 work preserved.
- ID02 `FUN_000027e4` = configure_display_from_main_device (rejects depths
  other than 1 / 4 / 8 with STR# 116, then sets the screen globals);
  `FUN_000029f2` = refresh_display_if_changed.
- Validation: token diff = renames only (113 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 222 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–221 work preserved.
- ID02 `FUN_00002334` = layout_game_window_and_view: view size from settings
  +0xe (1 full, 2 half, 3 three quarters, 4 quarter of the screen width),
  menu-bar handling incl. the 512 x 342 compact-Mac case, game window
  NewCWindow A5-0x14ca and palettes A5-0x14ae / -0x14aa, view size
  A5-0x1372 / -0x1370, ID06 rasterizer set-up at depth 1.
- Validation: token diff = renames only (114 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 223 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–222 work preserved.
- ID02 menus: `FUN_000030fa` = install_menus (MENU 1..5 at A5-0xc4e..-0xc3e),
  `FUN_00003174` = update_menu_items, `FUN_00003590` =
  set_menu_item_enabled, `FUN_000035bc` = set_view_size_option.
- Validation: token diff = renames only (118 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 224 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–223 work preserved.
- ID02 `FUN_0000442e` = position_alert_template (JT $47a), `FUN_00004582` =
  centre_window_on_screen (JT $472, used by every ID04 dialog),
  `FUN_00004610` = detach_window_palette, `FUN_0000462c` =
  select_palette_for_depth (RGB table A5-0x14a6 = &A5-0x320 or &A5-0x302).
- Validation: token diff = renames only (122 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 225 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–224 work preserved.
- ID02 `FUN_00002ee4` = copy_pascal_string, `FUN_000035e4` =
  start_new_mission (Duty Roster -> Scenario Selection -> reset of the
  mission globals incl. 12 kill words -> run_flight_session),
  `FUN_00004d6a` = handle_update_event (JT $492; documents the unexported
  restore_screen_globals at 0x4d96).
- ID02 is now fully renamed (125 / 125). All CODE segments ID02..ID09 are
  renamed; remaining work: ID01 (6) and Pacific Conflict (331 + 6 BLOCKED).
- Validation: token diff = renames only (125 ID02 renames); warnings intact;
  32 hashes OK.

### Iteration 226 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–225 work preserved.
- ID01 (6 / 6): rt_udiv32, rt_umod32, rt_sdiv32 (JT $5a), rt_smod32 (JT
  $62), rt_sdivmod32_core, rt_udivmod32_core (DIVU.W-based 32 / 32 divide).
  The rt_udivmod32_core header also documents the unexported runtime code:
  start-up (A5 world built from DATA 0 / ZERO 0, DREL 0 relocations,
  ExitToShell), the three switch helpers (JT $2a / $32 / $3a) and the
  32 x 32 multiply at 0xda.
- All CODE segments ID01..ID09 are now fully renamed. Remaining: Pacific
  Conflict (331 NOT_STARTED + 6 BLOCKED).
- Validation: token diff = renames only (6 ID01 renames); warnings intact;
  32 hashes OK; git diff --check clean.

### Iteration 227 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–226 work preserved.
- Pacific Conflict `FUN_00000334` = any_mission_kills_recorded,
  `FUN_000003fa` = load_player_fuel_and_bombs, `FUN_00000488` =
  tally_destroyed_entity. Mission block DAT_0001b5a0: +0xb6 fuel %, +0xb8
  bombs (word; byte +0xb9), +0xba.. kill counters by type, +0xd2 friendly
  kills - the overlay side of the host summary data.
- Validation note: this file carries earlier parameter renames, so the token
  check is done against the HEAD version of Pacific Conflict.decomp.c (equal
  modulo the three new names); warnings intact; 32 hashes OK.

### Iteration 228 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–227 work preserved.
- Pacific Conflict scene graph: `FUN_000004f8` = transform_through_node_chain,
  `FUN_000005fa` = traverse_scene_tree (kind-3 nodes are groups),
  `FUN_000006a6` = for_each_mission_scene_object (root from the mission
  scene table DAT_0001b5a0 + 0x8c / + 0x90). FUN_00000954 visits every
  object with FUN_000006ec.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 229 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–228 work preserved.
- Pacific Conflict `FUN_00000954` = plot_mission_map_symbols: the overlay
  side of the host Map dialog (target of A5-0x1052). Plots A (airfield),
  C (carrier: elevated airfield near a facility), B (friendly base, kind
  0x13), and T (primary target) in missions 3 / 4, matching the DLOG 137
  legend; positions relative to the player and divided by the map scale.
  `FUN_000006ec` = collect_map_features (land outlines through the clippers
  FUN_0000b190..b3aa to hook +0x292, airfield and facility lists).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 230 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–229 work preserved.
- Pacific Conflict clippers: `FUN_0000b190` / `b242` / `b2f4` / `b3aa` =
  clip_polygon_x_min / x_max / y_min / y_max (Sutherland-Hodgman against
  the clip rectangle DAT_00020aee / aec / aea / DAT_0001b73e). Corrected the
  collect_map_features note: the y-max bound is swapped for the last clipper.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 231 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–230 work preserved.
- Pacific Conflict scene queries: `FUN_00000aba` =
  nearest_type80_centroid_visitor, `FUN_00000bea` =
  point_near_camera_or_type80_object (hypothesis name), `FUN_00000c4c` =
  anchor_point_visitor, `FUN_00000d6a` = find_anchor_point (mode 0: kind-1
  node pose; mode 1: nearest ground airfield point at height 67).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 232 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–231 work preserved.
- Key link: the overlay pointer DAT_0001b5a0 is the host A5 world at
  A5-0x1388 (the address passed by reset_overlay_state to the overlay entry).
  Checks: +0x90 = A5-0x12f8 mission, +0xb6 = A5-0x12d2 fuel %, +0xb8 =
  A5-0x12d0 bombs, +0xba = A5-0x12ce kills, +0xd2 = A5-0x12b6 friendly kills,
  +0x192 / +0x1ac / +0x1b4 / +0xd8 = the panel bitmap handles, +0x2c6.. +0x2e2
  = the host memory services A5-0x10c2 .. A5-0x10a6 [STRONG INFERENCE: every
  offset checked so far agrees].
- Pacific Conflict `FUN_00000db0` = ensure_handle_allocated, `FUN_00000e0a` =
  lock_handle_nopurge, `FUN_00000e32` = unlock_handle_purgeable,
  `FUN_00000e5a` = lock_overlay_buffers.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 233 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–232 work preserved.
- Pacific Conflict `FUN_00001112` = overlay_main_entry: stores the host
  globals pointer and fills the host hook slots A5-0x10a2 .. A5-0x104e with
  overlay entry points (stored as address - 0x20). Resolves the host hooks
  used by begin / end_overlay_session, run_flight_session, start_new_mission
  and the map dialog (sine / cosine / sqrt / angle / map plotter). Table in
  docs/OVERLAY_SERVICE_TABLE.md.
- `FUN_00000ea0` = allocate_session_buffers (hook A5-0x1082), `FUN_00000f92`
  = lock_session_buffers (A5-0x107e), `FUN_00001094` =
  unlock_session_buffers (A5-0x1076).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 234 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–233 work preserved.
- Pacific Conflict hook targets: `FUN_00003ac4` = start_mission_scene
  (A5-0x109a), `FUN_00007310` = begin_flight_for_rank (A5-0x106e),
  `FUN_00006598` = overlay_frame_step (A5-0x107a, body partly decoded),
  `FUN_0000739a` = copy_player_pose_to_camera (camera DAT_0001d838 / -834 /
  -830 and angles).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 235 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–234 work preserved.
- Pacific Conflict `FUN_00006ed6` = update_view_clip_bounds (hook A5-0x109e;
  sets the clip y-max DAT_0001b73e from the view height, 20 lines less when
  the instrument panel is shown), `FUN_000038f4` = respawn_player_at_anchor
  (hook A5-0x108a; after conclude_mission the aircraft restarts at the
  nearest airfield).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 236 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–235 work preserved.
- Pacific Conflict `FUN_0000740a` = process_flight_input_and_outcome (hook
  A5-0x106a): flight key handling and the outcome code returned to
  run_flight_session. Esc / ` / ~ -> 3 (the "mission in progress" summary
  outcome), P -> 4 (Paused); on landing it writes fuel % and bombs back to
  the host. Header is an outline; per-key meanings remain hypotheses.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 237 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–236 work preserved.
- Pacific Conflict `FUN_00006ff6` = configure_renderer_for_display (hook
  A5-0x10a2): view size from host +0x16 / +0x18 (A5-0x1372 / -0x1370) and
  renderer set-up per pixel depth.
- Corrections: (1) host +0xe is A5-0x137a, the pixel depth 1 / 4 / 8 - the
  older "mission mode" reading of DAT_0001b5a0 + 0xe (e.g. in
  overlay_patch_template_u16_pair notes) means depth; (2) the code-pointer
  entries of the overlay hook table also follow the +0x20 rule:
  FUN_00001d56 -> 0x1d76 sin_fixed14, FUN_00001db8 -> 0x1dd8 cos_fixed14,
  LAB_0000e350 -> 0xe370; 0x28a6 is rotate_int3_vecs_by_3ang (already named).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 238 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–237 work preserved.
- Pacific Conflict `FUN_00004210` = refresh_object_colours_for_depth (hook
  A5-0x1096), `FUN_000041ec` = recolour_kind2_object (hypothesis name),
  `FUN_00004916` = set_object_faces_bw_pattern (host pattern table +0x88 =
  A5-0x1300, the ID06 pattern table).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 239 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–238 work preserved.
- Pacific Conflict object shading: `FUN_00003da8` =
  update_object_distance_band (distance bands DAT_0001b190),
  `FUN_00003e02` = update_record_distance_band, `FUN_00003e5c` =
  snapshot_face_colours (hypothesis name), `FUN_00003ea0` =
  shade_object_faces (face normal . light vector DAT_0001bd88..8c gives a
  0.25..1.0 factor; at depth 8 a haze blend toward (0x7d, 0x84, 0xa8) by
  distance band when host option +0xaa is on). recolour_kind2_object =
  distance band update + shading.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 240 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–239 work preserved.
- Pacific Conflict colour assignment: `FUN_0000159e` = assign_face_colour
  (depth 1: luminance (19 R + 38 G + 7 B) / 64 -> host dither pattern; depth
  4: fixed table; depth 8: dynamic palette slot out of 200, round-robin,
  avoiding slots used in either of the two last frames), `FUN_00001548` =
  write_face_palette_slot, `FUN_0000147a` = queue_face_palette_entry (pending
  ColorSpec list at host +0x72, applied by the host).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 241 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–240 work preserved.
- Pacific Conflict `FUN_000011e6` = widen_printf_format, `FUN_00001254` =
  overlay_printf (host +0x262 = A5-0x1126, target unknown), `FUN_00001294` =
  reset_palette_owner_tables, `FUN_00001300` / `FUN_0000131c` =
  init_depth8_colour_state / init_depth4_colour_state (the depth-specific
  set-ups chosen by configure_renderer_for_display).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 242 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–241 work preserved.
- Pacific Conflict `FUN_0000640c` = spawn_cloud_layer (hook A5-0x104e; host
  option +0xae = A5-0x12da), `FUN_00019aa2` = spawn_camera_relative_object,
  `FUN_00019b30` = follow_camera_offset. The "cloud" reading is a strong
  inference from the camera-relative placement and heights.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 243 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–242 work preserved.
- Pacific Conflict `FUN_000018d6` = overlay_initialise (RNG seed from the
  host TickCount, subsystem initialisers, light vector 0xd983 / 0x69d8 /
  0xc330). Overlay heap: `FUN_00001958` = heap_sbrk (arena = host
  A5-0x1040, the 220 / 320 KB work buffer allocated by the host),
  `FUN_00001974` = heap_new_size_class_block, `FUN_0000199a` =
  heap_add_large_block, `FUN_000019b0` = heap_add_large_block_tail (Ghidra
  false split).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 244 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–243 work preserved.
- Pacific Conflict initialisers: `FUN_00003732` = overlay_init_noop,
  `FUN_00003734` = init_code_pointer_tables, `FUN_00003266` / `3412` /
  `35b4` = init_span_table_32ba / 3466 / 3608 (self-modifying tables inside
  the code), `FUN_0001771a` = set_view_distance and `FUN_00017736` =
  cycle_view_distance (the Tab key cycles 0xc15c0 / 0x26ac0 / 0xce40).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 245 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–244 work preserved.
- Pacific Conflict `FUN_000032ba` / `3466` / `3608` = fill_span_rows_4bit_a /
  b / c: depth-4 span fillers (two merged run lists per row, nibble writes),
  selected by configure_renderer_for_display through DAT_00020ac0 /
  _DAT_00020abc / _DAT_00020ab8 (stored as address - 0x20); depth 8 uses
  0x37b4 for all three.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 246 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–245 work preserved.
- Pacific Conflict `FUN_000037b4` = fill_span_rows_8bit (uses the two
  2048-entry code tables from init_code_pointer_tables - note added there),
  `FUN_00001b4c` / `FUN_00001be4` = heap_zero_payload_tail /
  heap_realloc_grow_only_tail (Ghidra false splits), `FUN_00001c04` =
  copy_object_vertex_buffer.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 247 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–246 work preserved.
- Pacific Conflict `FUN_00002e12` = noop_stub_2e12, `FUN_00004e06` =
  reset_object_to_template_pose, `FUN_00004e4e` =
  reset_object_to_template_pose_tail (false split). Left the earlier-flagged
  false mid-labels FUN_00002aba / FUN_00003be0 untouched, and deferred the
  large FUN_00002e14, FUN_00003cca (register-argument distance minimum) and
  FUN_00004958.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 248 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–247 work preserved.
- Pacific Conflict `FUN_00006e74` = reset_span_row_lists (each view row
  starts as one background span), `FUN_00006ece` = clear_flag_00020ae4,
  `FUN_0000823e` = process_flight_input_tail (false split),
  `FUN_00008784` = set_state_word_1b86c (hypothesis name). FUN_00004958
  (builds a clipped, de-duplicated face outline per object) deferred.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 249 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 211–248 work preserved.
- Pacific Conflict `FUN_00005832` = dispatch_overlap_collisions (sweep over
  the metric-sorted object list, type collision handlers at type record
  +0x16), `FUN_000058ec` = build_visible_object_list (view-pyramid cull);
  both called back to back near Pacific Conflict.decomp.c 8445.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 250 — 2026-10-17

- Many queued loop prompts arrived together; ran one iteration.
- Verified 32 protected hashes; uncommitted iteration 211–249 work preserved.
- Pacific Conflict `FUN_000053f8` = collect_near_objects, `FUN_0000555a` =
  collect_far_objects: the two per-frame passes in overlay_frame_step that
  feed build_visible_object_list (candidates DAT_0001c43c) and
  dispatch_overlap_collisions (list DAT_0001c1e4), and deactivate / retire
  near objects that left the active range.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 251 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250 work preserved
  (earlier work committed by the user; validation re-based on HEAD).
- Pacific Conflict `FUN_00005a14` = update_altitude_detail_bands: keeps the
  camera height in a power-of-two band (DAT_0001d70c, log2 DAT_0001d704),
  lifts vertices of the shapes DAT_0001bdac / DAT_0001bdb0 by a value
  interpolated from DAT_0001b214, and when the band changes or the camera has
  moved far enough rebuilds land objects with tolerance DAT_0001b264[band].
  `FUN_00004958` = build_land_outline_at_detail (previously deferred).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 252 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–251 work preserved.
- Pacific Conflict `FUN_00005e28` = update_ground_scatter_objects (when
  option DAT_0001b5a0+0xac is set and the camera is low, keeps 64 random
  ground points around / ahead of the camera and places up to 7 scenery
  objects DAT_0001bc64 on visible ones, template chosen by surface type),
  `FUN_00013346` = surface_type_at_point, `FUN_000052dc` = deactivate_object.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 253 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–252 work preserved.
- Pacific Conflict point-in-face helpers: `FUN_0001320a` / `FUN_000131ac` /
  `FUN_00013268` = project_face_vertices_xz / _xy / _yz (shift + origin
  subtract into a 12-byte vertex buffer), `FUN_00013070` / `FUN_0001310e` =
  point_in_polygon_xz / _yz (even-odd crossing count). `FUN_00014af2` =
  release_fractal_reference (string "*** Deactivating Fractal, but st...").
  The xy / yz projection and yz test have no caller in the exported C.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 254 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–253 work preserved.
- Pacific Conflict `FUN_000132c8` = point_over_face_xz (Ghidra drops its
  boolean result), `FUN_00014bea` = carry_attached_objects (moves or removes
  entities of template types 7 / 8 / 0x1a / 0x1b near an object that is
  rotating / dropping; called twice by FUN_00014d86).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 255 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–254 work preserved.
- Pacific Conflict sinking path: `FUN_0001562e` = clip_polygon_y_nonneg,
  `FUN_00015762` = sink_object_shape_at_waterline (returns 0 once no face is
  above y = 0), `FUN_00014d86` = step_sinking_object (callers FUN_00015580,
  FUN_000155d8).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 256 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–255 work preserved.
- Pacific Conflict `FUN_00015580` = create_sinking_controller (0x56-byte
  record, interval 3, object flags 0x102000), `FUN_000155d8` =
  tick_sinking_controller. Neither has a caller in the exported C (handler
  table). The neighbouring `FUN_000155ec` (0x50-byte record, interval 7)
  and the larger tick before FUN_00015580 (random fire via
  spawn_weapon_entity, else step_sinking_object) are left for the next pass.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 257 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–256 work preserved.
- Pacific Conflict `FUN_00014f48` = apply_hit_to_sinkable_object (hit
  counter, list / capsize rates, starts the sinking schedule),
  `FUN_0001530e` / `FUN_00015356` = create_ / tick_firing_ship_controller
  (random fire from marked faces until sinking). `FUN_000150c8` (0x56-byte
  record, object flag 0x4000, first one kept in _DAT_0001b864) and
  `FUN_000155ec` (0x50-byte record) left for later: role not yet clear.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 258 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–257 work preserved.
- Decoded the ship controller definition table (runtime 0x1aa5e, file
  0x1aa7e, five 0x1c-byte records copied into DAT_0001b524[key] by
  overlay_main_entry): key, tick, create, extra handler, hits. This gives the
  callers of the controller functions renamed in iterations 255–257.
- Pacific Conflict `FUN_000150c8` = create_flagship_controller (type 0x15,
  provisional name), `FUN_000155ec` = create_basic_ship_controller (types
  0x18 / 0x17). New doc `docs/SHIP_CONTROLLERS.md`.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 259 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–258 work preserved.
- Found the callers of the controller definition handlers:
  instantiate_object_from_desc calls create (+6); `FUN_000092e4` =
  advance_frame_and_tick_controllers and `FUN_000094d2` =
  tick_flagged_object_controllers call tick (+2) over the list DAT_0001c25c;
  `FUN_0001429c` = handle_player_contact calls the +0x12 contact handler.
  `FUN_0000947c` = apply_controller_velocities. The definition table is
  general (instantiate_object_from_desc uses it for every keyed template),
  not ship-only; docs/SHIP_CONTROLLERS.md updated.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 260 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–259 work preserved.
- Pacific Conflict contact records: hash table DAT_0001bdbc (256 slots,
  linear probing) keyed by (object a, object b) — `FUN_0001358c` =
  contact_pair_hash, `FUN_000135a0` = find_contact_record, `FUN_000135e8` /
  `FUN_0001383c` = create_shape_ / create_fractal_contact_record.
  `FUN_00014198` = handle_terrain_contact stores the height from
  `FUN_00013980` = fractal_height_at into player controller +0x2e (the
  ground height used for altitude above ground elsewhere).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 261 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–260 work preserved.
- Pacific Conflict collision tests called by collect_far_objects:
  `FUN_00013ee0` = test_object_collision (per-face plane-crossing test
  using the contact records' stored signs), `FUN_00013cdc` =
  test_terrain_collision, `FUN_00013e4e` = test_proximity_collision,
  `FUN_00013eae` = test_player_vs_type0e_proximity. All end in
  FUN_00014348 (collision response).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 262 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–261 work preserved.
- Pacific Conflict `FUN_00014348` = dispatch_collision: per-type collision
  handlers at definition +0x12, with a 10-entry pair table DAT_0001b43c
  (file 0x1b45c, decoded: type 0xe vs 1..4 → FUN_000167f4; pairs with 0xc →
  0x14346). `FUN_0001346c` = point_in_face_by_axis, `FUN_00012fd2` =
  point_in_polygon_xy; the xy / yz helpers of iteration 253 now have a
  caller.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 263 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–262 work preserved.
- Pacific Conflict bullet hits: `FUN_000167f4` = bullet_hits_aircraft (pair
  handler type 0xe vs 1..4), `FUN_0001665a` = bullet_hits_shape,
  `FUN_00016724` = apply_random_aircraft_damage (random damage bit in
  controller word +0x684, whose low byte flags_685 degrades the controls).
  Template type 0xe identified as a bullet [STRONG INFERENCE].
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 264 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–263 work preserved.
- Pacific Conflict sound driver: `FUN_000095ac` = play_game_sound,
  `FUN_000096ae` = stop_game_sound, `FUN_000096f4` = update_game_sounds.
  Host services mapped through overlay offsets +0x25e / +0x2aa..+0x2be
  (= A5-0x112a / -0x10de..-0x10ca); section added to docs/SOUND_SYSTEM.md.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 265 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–264 work preserved.
- Annotation only (no new renames; counts unchanged): read the `'snd '`
  names of load_game_sounds from A5 initial data (DATA 0, A5-x at offset
  size - (x - 0xba0), 13 names matched) and mapped every sound slot: 0
  Engine, 1 Ugh, 2 Hit, 5 Gun, 6 Wheel, 7 Gear, 8 Explosion, 9 Distant
  Explosion, 10 Wind, 11 Ditch, 12 Grass. Confirms independently that sound
  2 (bullet_hits_aircraft) is Hit; the channel-0 slot 10 is Wind, so player
  +0x66a is a speed-like value rather than RPM (corrected in
  update_game_sounds). Comments updated in `Pacific Conflict.decomp.c`
  (play_game_sound, update_game_sounds) and `ID02.decomp.c`
  (load_game_sounds); table added to docs/SOUND_SYSTEM.md.
- Validation: comment-stripped tokens of both files equal HEAD (plus earlier
  renames); warnings intact; 32 hashes OK.

### Iteration 266 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–265 work preserved.
- Traced the setters of the sound events: Gun in
  process_flight_input_and_outcome, Wheel / Ditch / Grass / weapon release
  in update_aircraft_entity, explosion countdowns in `FUN_00011c58` =
  spawn_effect, Ugh in `FUN_00010650` = update_aircraft_damage_state
  (player damage bit 0 sets the host pilot status A5-0x12b4 = 1 Dead).
  spawn_effect logs its calls in a 16-entry ring only when DAT_0001b870 ==
  0 (replay / playback hypothesis for DAT_0001b870). SOUND_SYSTEM.md table
  filled in.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 267 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–266 work preserved.
- DAT_0001b870 identified as the instant-replay state [STRONG INFERENCE]:
  0 = live (spawn_effect logs every effect in a 16-entry ring), 1 = replay
  start (frame counter back 0x4a frames, `FUN_00011c2c` =
  mark_effect_log_end), != 0 = replaying (`FUN_00011b96` =
  replay_logged_effects re-spawns the logged effects frame by frame).
  `FUN_00011b48` = register_effect_template (create handler filling the
  effect template slots DAT_0002626e[0..3]).
- Effect initialiser table DAT_0001b40c read from bytes (file 0x1b42c, +0x20
  rule): kinds 0..11 -> 0x1203a, 0x120ca, 0x11efc, 0x1217e, 0x123ce, 0x12486,
  0x12296, 0x12528, 0x12760, 0x12764, 0x12738, 0x12760 (all but 0x12760 /
  0x12764 are Ghidra functions).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 268 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–267 work preserved.
- Pacific Conflict effect initialisers kinds 0..3 (size word +0x34 in
  percent scales the template; per-vertex velocities in the controller):
  `FUN_0001203a` = init_effect_kind0_flat_ring, `FUN_000120ca` =
  init_effect_kind1_column, `FUN_00011efc` = init_effect_kind2_burst,
  `FUN_0001217e` = init_effect_kind3_debris_explosion.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 269 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–268 work preserved.
- **Correction to iteration 267:** DAT_0001b40c is not one 12-kind table but
  three 4-entry tables: DAT_0001b40c init, DAT_0001b41c animate, DAT_0001b42c
  (used by FUN_000127aa). **Address convention clarified [PROVEN]:** Ghidra
  function addresses are file offsets; data labels and stored code pointers
  are runtime addresses (file offset − 0x20). Re-checking with this rule:
  pair handler 0x14346 (iteration 262) is a lone RTS (collisions ignored),
  and the type 0x15 handler 0x15154 starts with LINK A6 (an unexported
  function). Comments in dispatch_collision and docs/SHIP_CONTROLLERS.md
  corrected.
- Pacific Conflict effects: `FUN_00012768` = tick_effect, animators
  `FUN_000123ce` / `FUN_00012486` / `FUN_00012296` / `FUN_00012528` =
  animate_effect_kind0_ring / kind1_column / kind2_burst / kind3_debris,
  `FUN_00012466` = animate_effect_kind0_ring_tail (false split),
  `FUN_00012738` = face_object_to_camera.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 270 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–269 work preserved.
- Decoded the effect definition (key 8, runtime 0x1a93a): +2 tick_effect,
  +6 register_effect_template, +0xe `FUN_000127aa` =
  effect_pre_render_hook. Definition hook slots now known: +2 tick, +6
  create, +0xa destroy (called before the controller is freed), +0xe
  pre-render (FUN_0000a75e, phases 1 / 2), +0x12 collision.
- `FUN_000115fc` = spawn_smoke_plume [HYPOTHESIS], `FUN_000115da` =
  register_smoke_template, `FUN_00011670` = attach_trailing_plume,
  `FUN_000175de` = spawn_ground_mark [HYPOTHESIS].
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 271 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–270 work preserved.
- Pacific Conflict render pipeline: `FUN_0000ac72` = render_visible_objects
  (called by overlay_frame_step), `FUN_0000a75e` =
  transform_and_project_object (calls the definition +0xe pre-render hook),
  `FUN_0000a676` = project_prepared_object. Render-state globals documented
  in the headers (DAT_00025b24 current object, DAT_000256b2 screen points,
  DAT_00020b28 / 26 projection scales).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 272 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–271 work preserved.
- Pacific Conflict face emission: `FUN_00009ae0` = face_is_back_facing,
  `FUN_00009da6` = emit_faces_bsp (painter-order BSP), `FUN_00009d34` =
  emit_face_chain, `FUN_00009ef8` = emit_faces_in_order, `FUN_00009fc4` =
  emit_faces_unnumbered, `FUN_0000a2f2` = submit_object_faces (also the
  fly-through-a-face collision test via dispatch_collision). Face record
  layout documented; new doc docs/OVERLAY_RENDERER.md.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 273 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–272 work preserved.
- Pacific Conflict face output: `FUN_0000a512` = transform_face_vertices,
  `FUN_0000b028` = clip_face_near_plane, and the two DAT_00020ab4 targets
  set by configure_renderer_for_display: `FUN_0000a16e` =
  output_face_colour (depths 8 / 4, overlay span renderer FUN_00009b8c),
  `FUN_0000a220` = output_face_bw (depth 1, host ID06 add_polygon_edges via
  overlay +0x7c = A5-0x130c). docs/OVERLAY_RENDERER.md updated.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 274 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–273 work preserved.
- Pacific Conflict `FUN_00009b8c` = add_face_edges_to_rows (colour path:
  edge records in per-row buckets for the span fillers), `FUN_0000a07e` =
  track_ground_plane_horizon (ground-plane face DAT_0001bda8: covered
  corners DAT_0001bd90 and horizon edge DAT_0001bda0..94).
  docs/OVERLAY_RENDERER.md updated.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 275 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–274 work preserved.
- Pacific Conflict `FUN_0000b4b6` = draw_sky_and_ground (consumer of the
  horizon edge and corner bits from track_ground_plane_horizon; host colours
  +0x18e / +0x190), `FUN_0000b460` = reset_background_rows. The row-bucket
  consumer is the earlier-deferred FUN_00002e14 (only other user of
  DAT_0001eaac / DAT_0001daa4). docs/OVERLAY_RENDERER.md updated.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 276 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–275 work preserved.
- Pacific Conflict `FUN_00002e14` (deferred since iteration 247) =
  scan_convert_edge_rows: colour-depth scan conversion between
  render_visible_objects and the span fillers (active edge lists, draw-order
  visibility, runs into DAT_0001b794 / DAT_0001b798). Header only; the
  degraded inner loop is not annotated line by line.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 277 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–276 work preserved.
- Pacific Conflict `FUN_0000d00c` = update_view_readouts_and_overlays
  (altitude / speed / heading° / unknown readouts through host +0x27a, or
  sky + a dozen overlay drawers), `FUN_0001443a` =
  sort_group_parts_by_distance (haze colour RGB 0x7d / 0x84 / 0xa8).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 278 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–277 work preserved.
- Pacific Conflict live instrument needles (records A5-0x12a2 = overlay
  +0xe6 + 0x10·type, types from docs/INSTRUMENT_PANEL.md): `FUN_0000c572` =
  draw_gauge_needle and needles for types 0 / 1 / 6 / 3 / 5 / 4
  (`FUN_0000c664`, `FUN_0000c80c`, `FUN_0000c8d6`, `FUN_0000c948`,
  `FUN_0000c9c2`, `FUN_0000ca44`).
- **Correction to iteration 265:** player +0x66a drives the tachometer, so it
  is engine RPM (Wind = windmilling propeller with the engine off), not a
  speed; DAT_0001bc80 (climb needle) is the rate of climb, which identifies
  readout 3. Comments in update_game_sounds /
  update_view_readouts_and_overlays and SOUND_SYSTEM.md corrected;
  INSTRUMENT_PANEL.md gains a live-needles table.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 279 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–278 work preserved.
- Pacific Conflict panel extras: `FUN_0000cc12` = update_flaps_needle
  (+0x67b), `FUN_0000ccca` = update_gear_needles (+0x679, three legs),
  `FUN_0000ce1c` = update_ammo_needle (+0x682), `FUN_0000cec4` =
  update_fuel_needles (+0x67d / +0x67e), `FUN_00017b68` = update_radar_scope.
  Flaps vs gear assigned by needle count (one vs three, matching the ID03
  panel items) [STRONG INFERENCE]. INSTRUMENT_PANEL.md updated.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 280 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–279 work preserved.
- Pacific Conflict `FUN_000176b2` = add_radar_track, `FUN_0001776a` =
  reset_radar_tracks, `FUN_0000c1aa` = update_heading_tape,
  `FUN_0000ba2a` = draw_panel_frame_lines [HYPOTHESIS].
- **Correction to iteration 244:** DAT_0002666a / DAT_00026666 (set by
  set_view_distance, cycled by the Tab key) limit the radar tracks, so they
  are the radar range; the function names are kept and the comment
  corrected (a rename to set_radar_range / cycle_radar_range is proposed).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 281 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–280 work preserved.
- Decoded the aircraft definition (key 1, file 0x1a7b0): +2 0xe5aa, +6
  0xe0ce, +0xa 0xe0a4, +0xe 0xfb2a, +0x12 0xfe0a, +0x16 `FUN_0000fe96` =
  aircraft_notice_object (player radar tracks, AI target acquisition).
  `FUN_0000b49e` = reset_overlay_display_state.
- **Correction to iteration 249:** dispatch_overlap_collisions calls the
  definition +0x16 notice handler, not a collision handler (that is +0x12).
  FUN_00001db8 / FUN_00001d56 in the needle functions are the documented
  cos / sin call-site aliases (BLOCKED false entries); comments updated.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 282 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–281 work preserved.
- Pacific Conflict aircraft handlers: `FUN_0000e0a4` = aircraft_destroy,
  `FUN_0000e0ce` = aircraft_create (first aircraft = player; AI state
  0x110d4), `FUN_0000e5aa` = aircraft_tick (75-frame pose ring = replay
  history), `FUN_0000fe0a` = aircraft_collision; AI states `FUN_000110f4` =
  ai_attack_or_fly, `FUN_00011182` = ai_fly (entry bytes checked).
  docs/SHIP_CONTROLLERS.md gains an aircraft section.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 283 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–282 work preserved.
- Pacific Conflict `FUN_0000dff0` = init_aircraft_controller (controller
  defaults), `FUN_0000df5e` = fill_pose_history, `FUN_0000fb2a` =
  animate_landing_gear (aircraft pre-render hook; confirms +0x679 = gear,
  0x2d down / 0 up). AI fly table DAT_0001b3f4 (file 0x1b414, + 0x20):
  kind 0 none, 1..5 -> 0x10d68, 0x10de8, 0x10f68, 0x10ecc, 0x10da8.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 284 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–283 work preserved.
- The AI fly-table targets (0x10d68 / 10da8 / 10de8 / 10ecc / 10f68) were
  already named in earlier iterations (ensure_ai_script_* /
  tick_ai_1b310_approach_fire / tick_ai_1b370_mission); target list was
  stale.
- Pacific Conflict `FUN_0000f810` = player_slew_mode: player state handler
  0xf7f0, toggled with control-S (0x13) against normal flight 0xe772 in
  process_flight_input_and_outcome; keypad-driven free movement.
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 285 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–284 work preserved.
- Pacific Conflict `FUN_00012b66` = apply_blast_damage, `FUN_00018956` =
  spawn_object_shadow (host option +0xb0 = shadows [STRONG INFERENCE]),
  `FUN_0001820a` = ai_pursue_target: AI aims at the target pose from its
  replay ring DAT_0001b878 frames back - the rank-dependent value from
  DAT_0001b2b4 is a reaction lag (difficulty) [STRONG INFERENCE].
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 286 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–285 work preserved.
- Pacific Conflict `FUN_00011db4` = spawn_destruction_effect (air: kind 2
  burst; surface 0x10: kind 0 ring; else kind 3 debris), `FUN_00013452` =
  surface_type_under_object. This confirms surface code 0x10 = water and
  effect kinds 0 / 1 = water splash ring / column (hypotheses of iteration
  268 raised to STRONG INFERENCE).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

### Iteration 287 — 2026-10-17

- Verified 32 protected hashes; uncommitted iteration 250–286 work preserved.
- The other apply_blast_damage callers: `FUN_00012d34` = bomb_detonation
  and its tick `FUN_00012a2a` = bomb_tick (definition key 0xc, file
  0x1a9a8: template type 0xc = dropped bomb [STRONG INFERENCE]; host +0xcc
  counts target hits, +0xd2 friendly kills, mission 3 / 4 objective +0xce),
  `FUN_00018c96` = tick_flak_gun (definition key 0x1a, the record not
  copied by Block C; flak bursts with blast damage).
- Validation: token diff vs HEAD = renames only; warnings intact; 32 hashes OK.

**Next iteration target:** Pacific Conflict bomb create 0x1281e, motion
`FUN_000128b6`, collision 0x12f52; flak create / destroy 0x18b52 / 0x18b98;
rest of ai_pursue_target.

## Resuming the five-minute workflow

Invoke: “Resume one five-minute Hellcats C reconstruction iteration from
`docs/DECOMPILATION_PROGRESS.md`, preserving original artifacts and existing edits.”
Before each pass, inspect Git status and verify the protected checksum manifest
relative to `hellcats-over-the-pacific-sources/ResEdit/CODE`. Select the next block,
assign one owner per edited file, compare original C and dependencies, validate
changes, then update this checkpoint and symbol map. Do not recreate existing
outputs, commit, push, or touch gameplay code. If a future session exposes a real
agent wake scheduler, configure a 300-second interval and record its returned
handle only after activation; a shell printing ticks alone does not wake this agent.


## Priority queue (suggested)

1. Revisit `$1A48` allocator ABI (BLOCKED)  
2. `ID09.c` / `ID05.c` segment entries  
3. Inventory remaining high-traffic `FUN_*` in Pacific Conflict  
4. `FUN_00003cca` — multi-sample min using approx_dist3_xyz  

