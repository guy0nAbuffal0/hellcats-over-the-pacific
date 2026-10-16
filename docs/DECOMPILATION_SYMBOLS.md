# Hellcats Over the Pacific — Decompilation Symbol Map

Maps original Ghidra identifiers to recovered names. Every entry must cite evidence.
Do not treat example names from planning docs as approved until revalidated here.

## Functions

| Original symbol | Recovered name | Confidence | Evidence |
|---|---|---|---|
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
