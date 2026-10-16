# Hellcats Over the Pacific — C-to-C Decompilation Progress

Persistent checkpoint for the recurring 5-minute semantic reconstruction loop.

**Last iteration:** 97  
**Last iteration date:** 2026-10-15  
**Loop:** local monitored shell `AGENT_LOOP_TICK_hellcats_decomp` every 300s (PID 54957 / terminal 343366)

## Inventory summary

| Source file | Functions inventoried | NOT_STARTED | INVESTIGATING | ANNOTATED | RENAMED | VERIFIED | BLOCKED |
|---|---:|---:|---:|---:|---:|---:|---:|
| ID01.c | 6 | 6 | 0 | 0 | 0 | 0 | 0 |
| ID02.c | 122 | 122 | 0 | 0 | 0 | 0 | 0 |
| ID03.c | 45 | 45 | 0 | 0 | 0 | 0 | 0 |
| ID04.c | 59 | 59 | 0 | 0 | 0 | 0 | 0 |
| ID05.c | 24 | 24 | 0 | 0 | 0 | 0 | 0 |
| ID06.c | 24 | 24 | 0 | 0 | 0 | 0 | 0 |
| ID07.c | 2 | 2 | 0 | 0 | 0 | 0 | 0 |
| ID08.c | 4 | 0 | 0 | 0 | 4 | 0 | 0 |
| ID09.c | 4 | 4 | 0 | 0 | 0 | 0 | 0 |
| Pacific Conflict.c | 441 | 330 | 0 | 0 | 104 | 0 | 8 |
| **TOTAL** | **731** | **616** | **0** | **0** | **108** | **0** | **8** |

Full machine-readable inventory: [`DECOMPILATION_INVENTORY.json`](DECOMPILATION_INVENTORY.json)  
Protected original checksums: [`DECOMPILATION_PROTECTED_CHECKSUMS.sha256`](DECOMPILATION_PROTECTED_CHECKSUMS.sha256)  
Symbol map: [`DECOMPILATION_SYMBOLS.md`](DECOMPILATION_SYMBOLS.md)

## Output files

| Immutable input | Editable output | Status |
|---|---|---|
| `ID01.c` | `ID01.decomp.c` | seeded (copy) |
| `ID02.c` | `ID02.decomp.c` | seeded (copy) |
| `ID03.c` | `ID03.decomp.c` | seeded (copy) |
| `ID04.c` | `ID04.decomp.c` | seeded (copy) |
| `ID05.c` | `ID05.decomp.c` | seeded (copy) |
| `ID06.c` | `ID06.decomp.c` | seeded (copy) |
| `ID07.c` | `ID07.decomp.c` | seeded (copy) |
| `ID08.c` | `ID08.decomp.c` | seeded + iter 68–71 edits (all 4 FUN renamed) |
| `ID09.c` | `ID09.decomp.c` | seeded (copy) |
| `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | seeded + iter 1–97 edits |

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
| `FUN_0001a1a6` | `tick_landing_approach_glide` | Pacific Conflict | RENAMED | STRONG INFERENCE | `@0x1A1A6` | `Pacific Conflict.decomp.c` | glide along 267xx | — | 95 | Capstone |
| `FUN_00000354` | `probe_nearest_facility_kind` | Pacific Conflict | RENAMED | PROVEN | `@0x0354` | `Pacific Conflict.decomp.c` | 0x12→0x100, 0x13→0x200 | Ghidra void ABI | 97 | Capstone; 12 BSR |
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

**Next iteration target:** Annotate more of `tick_landing_approach_glide` body.

## Priority queue (suggested)

1. `tick_landing_approach_glide` — deepen glide steering comments  
2. Revisit `$1A48` allocator ABI (BLOCKED)  
3. `ID09.c` / `ID05.c` segment entries  
4. `FUN_00003c48` — distance helper used by runway ends  

