# Hellcats Over the Pacific — C-to-C Decompilation Progress

Persistent checkpoint for the recurring 5-minute semantic reconstruction loop.

**Last iteration:** 168
**Last iteration date:** 2026-10-17
**Loop:** session-only CronCreate job `f156ee33` (`*/5 * * * *`) activated 2026-10-16 in a Claude Code desktop session; it ends when that session closes and auto-expires after 7 days. Otherwise resume manually using the instructions below.

## Inventory summary

| Source file | Functions inventoried | NOT_STARTED | INVESTIGATING | ANNOTATED | RENAMED | VERIFIED | BLOCKED |
|---|---:|---:|---:|---:|---:|---:|---:|
| ID01.c | 6 | 6 | 0 | 0 | 0 | 0 | 0 |
| ID02.c | 125 | 61 | 0 | 0 | 64 | 0 | 0 |
| ID03.c | 45 | 30 | 0 | 0 | 15 | 0 | 0 |
| ID04.c | 59 | 59 | 0 | 0 | 0 | 0 | 0 |
| ID05.c | 24 | 0 | 0 | 0 | 24 | 0 | 0 |
| ID06.c | 24 | 0 | 0 | 0 | 24 | 0 | 0 |
| ID07.c | 2 | 0 | 0 | 0 | 2 | 0 | 0 |
| ID08.c | 4 | 0 | 0 | 0 | 4 | 0 | 0 |
| ID09.c | 4 | 0 | 0 | 0 | 4 | 0 | 0 |
| Pacific Conflict.c | 443 | 331 | 0 | 0 | 106 | 0 | 6 |
| **TOTAL** | **736** | **487** | **0** | **0** | **243** | **0** | **6** |

Inventory correction (iteration 100): five multiline definitions were previously
omitted: ID02 `FUN_00003d50` (:2126), `FUN_00003f54` (:2231),
`FUN_00004050` (:2266); Pacific Conflict `FUN_0000e262` (:13673),
`FUN_00010360` (:15361). Totals count exclusive processing statuses; renamed
functions with annotations remain RENAMED. The two blocked labels `$E352` and
`$1A186` remain documented below but are not function definitions and do not
contribute to function totals. Remaining work: 487 NOT_STARTED + 6 BLOCKED (iteration 168);
243 RENAMED still require independent verification before VERIFIED status.

Full machine-readable inventory: [`DECOMPILATION_INVENTORY.json`](DECOMPILATION_INVENTORY.json)  
Protected original checksums: [`DECOMPILATION_PROTECTED_CHECKSUMS.sha256`](DECOMPILATION_PROTECTED_CHECKSUMS.sha256)  
Symbol map: [`DECOMPILATION_SYMBOLS.md`](DECOMPILATION_SYMBOLS.md)

## Output files

| Immutable input | Editable output | Status |
|---|---|---|
| `ID01.c` | `ID01.decomp.c` | seeded (copy) |
| `ID02.c` | `ID02.decomp.c` | seeded + iter 111-112 (initialize_application, main, poll_and_dispatch_event, do_menu_command, apply_settings_to_live_options, handle_mouse_down, handle_activate_event, redraw_main_window, check_device_color_state_changed, build_palette_index_map, palette helpers) |
| `ID03.c` | `ID03.decomp.c` | seeded + iter 159 (scaling / colour helpers) |
| `ID04.c` | `ID04.decomp.c` | seeded (copy) |
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

**Next iteration target:** identify the other instrument types by their label
slots (A5−0xf46 + 4·slot) starting with `FUN_00001b48` (type 1).

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

