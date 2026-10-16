# Daily log (evidence-first)

Every statement is tagged: **[RECONSTRUCTED]** (from decompiler/binary), **[INFERRED]** (reasoning from evidence), **[UNKNOWN]** (unverified or missing).

## Template (copy for new days)

```markdown
### YYYY-MM-DD
- [RECONSTRUCTED] ...
- [INFERRED] ...
- [UNKNOWN] ...
```

## Entries

### 2026-10-16 — FUN_0000b242 max-x clip after b190

- **[PROVEN]** Pacific Conflict.c:5437–5438: if `b190` count≠0 → `DAT_00020aec=param_4` then `b242(out,n,in)`; restore.
- **[PROVEN]** `b242` (10371–10429): closed xz ring clip keep `x<=plane` (mirror of `b190`).
- **Godot:** `fun_0000b242` / `apply_04958_clip_b242`; plane=`_to_s16(param_4)`; SimCore chains after `b190`.
- **[DEFERRED]** `b2f4`/`b3aa`; `local_f54` gather.
- **Validation:** Godot 13/0; Python all passed (this tick).

### 2026-10-16 — FUN_0000b190 x-plane clip on 04958

- **[PROVEN]** Pacific Conflict.c:5430–5431: if thinned pairs≥3 → `DAT_00020aee=-param_4` then `b190(local_464,n,out)`; restore `20aee`.
- **[PROVEN]** `b190` (10308–10366): closed xz ring clip keep `x>=plane`; return out-count (`Δbytes>>3`).
- **Godot:** `fun_0000b190` / `apply_04958_clip_b190`; plane=`-_to_s16(param_4)` (call-site `0x7fe4`).
- **[DEFERRED]** `b2f4`/`b3aa`; `local_f54` gather (`b242` now wired).
- **Validation:** Godot 13/0; Python all passed (prior tick).

### 2026-10-16 — FUN_00003c68 + 04958 multi-index thinning

- **[PROVEN]** Capstone `@0x3C68`: six stack longs `(x0,y0,z0,x1,y1,z1)`; `a=|x1-x0|` etc via LEA `$2DE8`≡`02e08`; `max+((sum other)>>2)` (same combine as `03b98`/`03c00`).
- **[PROVEN]** Capstone `@0x4AAE` (04958): later indices push `(prev_x,0,prev_z,cur_x,0,cur_z)` then `(1d838,0,1d830,cur_x,0,cur_z)`; accept when `cam/(a8+3) <= acc`.
- **Godot:** `fun_00003c68`; `apply_04958_poly_pairs` thins multi-index; SimCore passes `dat_0001d838`/`1d830` + `b5a0+0xa8`.
- **[DEFERRED]** `b2f4`/`b3aa` clip; `local_f54` gather (`b190`/`b242` wired).
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — 04958 poly index walk (simple cull)

- **[PROVEN]** Pacific Conflict.c:5405–5462 / 5493: stream count@+8, indices@+0xe (same as 04808 desc); project xz `(v0-1d724,v2-1d71c)>>param_3`; pairs<3 → `poly+0x13|=2`.
- **Godot:** `apply_04958_project_xz` / `apply_04958_poly_pairs` (was simple-only; now includes `03c68` thinning).
- **[DEFERRED]** clip chain / `local_f54` gather.
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — nested FUN_00002bd8 in 04958

- **[PROVEN]** Pacific Conflict.c:5396: `02bd8(obj, *(s16*)(tpl+0x1a), tpl+0x22, auStack_15e4)` — both-aux; count is `1a` only (not `1a+1e`).
- **[PROVEN]** Src treated as int32×3 at `tpl+0x22` (contrast `15762`/`02976` packed +2/+6/+10).
- **Godot:** `_apply_fun_00004958` runs `apply_02bd8_both_aux_walk` → `auStack_15e4`.
- **[DEFERRED]** clip chain after thinned pairs.
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — FUN_00004958 entry + 04916 on +6 path

- **[PROVEN]** Pacific Conflict.c:5686–5693: `+6` → `04958(obj,0xb4e1,0,0x7fe4)`; if `*(s16*)(b5a0+0xe)==1` → `04916(obj,0x80)` else `03ea0`. No prior `0435a`/`03da8`.
- **[PROVEN]** 04958 entry 5378–5395: `local_1be4[i]=verts[i+36]-verts[0]`; `poly_stream=tpl+0x22+(1a+1e)*0xC`.
- **[PROVEN]** 04916 (5319–5337): each of `field_3a` poly slots: `+4←*(table+param_2*2)`, `+0xf←0xff`.
- **Godot:** `_apply_fun_00004958` / `_apply_fun_00004916` on `+6` path; nested `02bd8` now wired.
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — 15762 local_3324 rel + bias_1a

- **[PROVEN]** Pacific Conflict.c:19929–19942: if `1e>0`, `local_3324[i]=local_1e94[i+1a]-local_1e94[0]` (full int32).
- **[PROVEN]** 19944–19958: for first `1a` verts, BE low-16 subtract `(+18<<sh)`, `(param_5<<sh)`, `(+20<<sh)`.
- **Godot:** `apply_15762_local_3324_rel` / `apply_15762_bias_1a_low16` after nested `02bd8` (rel before bias).
- **[DEFERRED]** `asStack_2924` fill; `FUN_0001562e` poly emit; return.
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — nested FUN_00002bd8 after 02976 in 15762

- **[PROVEN]** Pacific Conflict.c:19928: `02bd8(obj, count, &local_1e94, &local_1e94)` — both-aux (src≡dst); no `+0x18/1c/20` commit.
- **Godot:** `_apply_fun_00015762` runs `apply_02bd8_both_aux_walk` on `local_1e94` via parent-chain slots.
- **[DEFERRED]** `1562e` poly emit / return; both-aux rotate path still omits post-`02ada` `01c5c` (pre-existing).
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — FUN_00002976 after 0253e in 15762

- **[PROVEN]** Pacific Conflict.c:19926–19928: after `0253e` → `02976(count, tpl+0x22, &local_1e94, matrix)` then `02bd8`.
- **[PROVEN]** `02976` (3144–3170): same +2/+6/+10 × matrix +0x800>>12 as `028dc`, but int32×3 outs.
- **Godot:** `fun_00002976`; `apply_15762_entry_plan` runs it when src triples present; SimCore reads tpl+0x22 stream.
- **[DEFERRED]** poly copy/delta loops, return value (nested 02bd8 now wired).
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — FUN_00015762 args + entry on +7 path

- **[PROVEN]** Pacific Conflict.c:5669–5682: handle=`*(obj+8)`; if null or `**(s16**)(handle+4)`∉[0x15,0x19] → angles 0; else `+0x34/+36/+38/+40` → `15762(obj,…)`.
- **[PROVEN]** Entry 19920–19928: tpl via parent/embed; count=`*(+0x1a)+*(+0x1e)`; `0253e(p2,p3,p4)`.
- **Godot:** `apply_04e6e_15762_args` / `apply_15762_entry_plan` / `_apply_fun_00015762` on `15762` path after 0435a/03da8.
- **[DEFERRED]** nested `02bd8`, poly loops, return value (02976 now wired).
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — FUN_00004e6e kind2 bit4 path select (+5→01c5c)

- **[PROVEN]** Pacific Conflict.c:5653–5693: `+6`→`04958`; else `+7`→`15762`; else `+5`→`01c5c(36+3a,mesh,verts,0,0,0)`+rates/`03ea0`; else `02bd8`+rates then `03ea0` (LAB).
- **Godot:** `apply_04e6e_post_04808_path`; `01c5c` path copies mesh→verts; `03ea0` recorded (`deferred_body`); `15762`/`04958` bodies still deferred.
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — FUN_00004e6e kind2 04808/02bd8 on 016e2 path

- **[PROVEN]** Pacific Conflict.c:5639–5658: after +0x4c/+0x44 alloc, `04808(obj, tpl+0x22+(36+3a)*0xC)`; flag-gated `02bd8`; `0435a(obj,0)`; `03da8`.
- **Godot:** `_04e6e_kind2_04808_followup` shared by `_call_fun_00004e6e` (016e2 bdac/bda4) and nested 046da near-path; desc from `spawn_04808_desc_ptr` or mem tpl.
- **[DEFERRED]** `obj+8` → `DAT_0001c25c` publish (5648–5652); `15762`/`04958` bodies; live `03ea0`.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_0000435a poly stream *(rec+10) → +0x1c

- **[PROVEN]** Pacific Conflict.c:5049–5069: stream=`iVar5+0x22+*(s16*)(+0x1a)*0xC+*(s16*)(+0x1e)*0xC`; each poly `*(stream+10)` → buf+0x1c; advance `+0xE+*(u8*)(+8)*2`.
- **Godot:** `apply_0435a_poly_stream_base` / `_advance` + `_0435a_resolve_poly_srcs`; mem when template resolves, else `spawn_0435a_poly_srcs`.
- **Validation:** Godot headless + Python regression (this tick).

### 2026-10-16 — FUN_0000435a *(template+0xe) scale source

- **[PROVEN]** Pacific Conflict.c:5020–5038: `iVar5 = *(b5a0+0x8c) + *(*(obj+0x24)+0x28 + 0x2e + (obj+1)*0x18)`; `+0xc` from `*(iVar5+0xe)` × scale.
- **Godot:** `apply_0435a_template_addr` + `_0435a_resolve_scale_src`; mem path when parent/embed/b5a0+0x8c present, else `spawn_0435a_scale_src` fallback.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_000046da 02bd8 null-aux template walk

- **[PROVEN]** Pacific Conflict.c:3343–3375: while `*(obj+0x24)≠0`, slot=`*(cur+0x30)+idx*0x18`, rotate/translate locals, `idx=*(cur+2)`, `cur=*(cur+0x24)`; then null-aux commit to `+0x18/+0x1c/+0x20`.
- **[PROVEN]** Per node (3355–3360): optional `0253e`→`02ada`, then **always** `01c5c` (rotate path previously omitted translate — fixed).
- **Godot:** `_02bd8_nodes_from_parent_chain` + `_apply_046da_02bd8` on both 046da entry points; `spawn_046da_02bd8_nodes` override (`[]` skips walk; `null` → mem chain).
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_000046da → FUN_00002bd8(obj,1,null,null)

- **[PROVEN]** Pacific Conflict.c:5236: after identity links, `FUN_00002bd8((int)puVar1,1,NULL,NULL)` then factory `+8` / `0435a`.
- **Godot:** `_call_fun_000046da` and `_046da_from_parent` run null-aux walk+commit; `last_046da_02bd8_commit` survives nested `04e6e`.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_000046da → FUN_0000435a(param_2=1)

- **[PROVEN]** Pacific Conflict.c:5251: after factory `+8`, `FUN_0000435a((char *)puVar1, 1)` then `03b98` / distance gate.
- **[PROVEN]** param_2=1 skips kind2 poly `+0x1c` loop (5048: `*param_1==2 && param_2==0`); gate / `+0xc` scale still apply when phase `0 < a8 < 6`.
- **Godot:** `_046da_from_parent` and `_call_fun_000046da` call `_apply_fun_0000435a(obj, 1)` before `03b98`; kind-3 rollup clears `deferred_0435a`.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_000046da tail (02bd8 / 03b98 / gate)

- **[PROVEN]** Decomp 5236–5259: `02bd8(obj,1,0,0)`; factory `+8` if desc[1]≠0; `0435a`; `03b98`→`+0x10`; if `(metric−obj+0xc)<0x19c80` → `04e6e` else `d0e4[c1dc++]`.
- **Godot:** wired in `_046da_from_parent`; `0435a` now wired (see entry above); factory aux from table shorts.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_000046da front half in kind-3 loop

- **[PROVEN]** Decomp 5223–5235: desc from embed+`idx*0x18+0x2E`; `045ba`; `table+0x14=obj`; `+0x24=parent`; bump `+3` if idx equal; OR flags if `idx < parent+0x2c`.
- **Godot:** `_046da_from_parent` + kind-3 loop; tail now includes `02bd8`/`03b98`/gate.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_00004e6e kind-3 child table

- **[PROVEN]** Capstone `@0x5072–0x5106`: `d4a4[c1e0++]=obj`; `01a68(count*0x18)`→`obj+0x30`; copy/relocate from `*(obj+0x28)+0x1A`; `046da(obj,i,i)`×count; then `03b98`.
- **Godot:** `_04e6e_kind3` reuses `_016e2_build_child_table`; `046da` front half wired.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_00004e6e kind-2 list + vertex alloc (016e2)

- **[PROVEN]** Decomp ~5631–5643: kind2 → `b5a4[b734++]` or `d4a4[c1e0++]` from `obj+7` bit0; `01a48`×2 → `obj+0x4c/+0x44` size `(36+3a)*0xC`.
- **Godot:** `_call_fun_00004e6e` replaces stub for `016e2` bdac/bda4; mock ptrs via `spawn_04e6e_*`; kind2 follow-up now shared (see 04808 entry above).
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_00001c04 vertex buffer copy

- **[PROVEN]** Capstone `@0x1C04–0x1C5A`: `count=*(s16*)(obj+0x36)+*(s16*)(obj+0x3a)`; copy `count`×`0xC` from `*(obj+0x44)` → `*(obj+0x4c)`.
- **Godot:** `apply_01c04_plan`; `_call_fun_00001c04` writes `mem_u32` (wired from `016e2` after `04e6e(bda4)`).
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_00001be4 = FUN_00001ba8 mid-entry $1BE4

- **[PROVEN]** Capstone `@0x1BA8–0x1C00`: `01ba8` grow-only realloc; `$1BE4` is mid-entry after `01b84` → `1a63e(old,new,cap)` + `019d0(old)` + return new. `016e2` LEA/JSR `$1BE4` (only site).
- **[PROVEN]** Capacity: `*(p-4)==0xFF` → `(*(p-8)-1)*8`; else `(1<<*(p-4))-4`.
- **Godot:** `apply_01ba8_capacity` / `need_grow` / `apply_01be4_tail` / `fun_0001a63e_copy_bytes`; harness `spawn_01be4_new_ptr`/`nbytes`.
- **[DEFERRED]** Recover `016e2` A2/D2/D3 after `04e4e` (LEA clobbers A2); live `019d0` on mock objs.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_00004e06 / mid-entry $4E4E body

- **[PROVEN]** Capstone: `$4E06` full fn (gate `bit1(obj+7)`, desc via `parent+0x28/+0x2E+idx*0x18`, copies `+18/1c/20/14`, `02bd8(obj,1,0,0)`); `$4E4E` is mid-entry (last copy+`02bd8`). `016e2` LEA/JSR `$4E4E`.
- **[PROVEN]** Ghidra `FUN_00004e06` matches; phantom `FUN_00004e4e` is the mid-entry slice.
- **Godot:** `apply_04e06_*` / `apply_04e4e_tail`; `_call_fun_00004e4e` runs full `04e06` effect on stack arg obj.
- **[DEFERRED]** Live `02bd8` template walk when `obj+0x24≠0`; `01be4` body.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-16 — FUN_000016e2 bda8/bda4/1b734 + bc28 window

- **[PROVEN]** Capstone `@0x183E–0x18D4`: `bda8=*(bdac+0x48)`; `bda4=*(table+0x74)`; `04e6e`/`01c04(bda4)`; `clr.l 1b734`; `b88e=*(root+0x2C)-1`; `bc28/34/38` = child[i-1/i/i+1]; `b88c=i+1`; RTS.
- **Godot:** `_016e2_publish_bda_tail`; stubs `last_01c04_calls`.
- **[DEFERRED]** Hook bodies (`04e4e`/`01be4`/`04e6e`/`01c04`); real `01b6c`/`045ba` heap.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-15 — FUN_000016e2 bdb0/bdac + 04e4e/01be4 stubs

- **[PROVEN]** Capstone `@0x17B4–0x1832`: `04e4e(bdb4)`/`01be4(bdb4)`; `bdb0=child[1]`; `04e4e(bdb0)` then `01be4(bdb4)` again; `bdac` from child[3] if `*(b5a0+0x90)==2` else child[2]+`04e6e`.
- **Godot:** `_016e2_publish_bdb_hooks`; stub call logs `last_04e4e_calls` / `01be4` / `04e6e`.
- **[DEFERRED]** Hook bodies; `bda8`/`bda4`; `bc28` window.
- **Validation:** Godot 13/0; Python regression pass.

### 2026-10-15 — FUN_000016e2 per-child 04690 + bdb4

- **[PROVEN]** Capstone `@0x176C–0x17AC`: `04690(*(table+i*0x18+0x14))` → store obj; `obj+0x24=root`; `obj+1/+2=index`; `DAT_0001bdb4=*(table+0x14)`.
- **Godot:** `_016e2_resolve_children`; `apply_016e2_link_child` / `publish_bdb4`.
- **[DEFERRED]** `04e4e`/`01be4` hooks; `bdb0`/`bdac` publish.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_000016e2 child×0x18 table

- **[PROVEN]** Capstone `@0x1704–0x1764`: `src=*(root+0x28)+0x1A`; `bytes=s16(root+0x2E)*0x18` via `LEA (A0,A0.L*2)`+`ASL #3`; `01a68` → `root+0x30`; copy 6 longs; `*(slot+0x14)+=*(b5a0+0x8C)`.
- **Godot:** `apply_016e2_child_*`; `_016e2_build_child_table` in `init_mission_object_tables`.
- **[DEFERRED]** Per-child `04690` + `obj+0x24=root`; `bdb4` publish.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_000016e2 root 04690 → DAT_0001d6fc

- **[PROVEN]** Capstone `@0x16EC–0x16FC`: `MOVE.L $8C(A0)` with `A0=DAT_0001b5a0`; `BSR.L $4690`; `MOVE.L D0,$1D6FC`.
- **[PROVEN]** `04690` `@0x4690`: `045ba` → obj; byte `desc[1]` factory → `obj+8`; return obj.
- **Godot:** `_call_fun_00004690`; `init_mission_object_tables` publishes `dat_0001d6fc`.
- **[DEFERRED]** Child×`0x18` table; live byte-typed `1b524` factory on root; `bdb4` publish.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_000016e2 → publish_00054_all

- **[PROVEN]** Capstone `@0x16E6`: `BSR.L $54` → `overlay_init_template_pointer_tables` (disp target `0x54`).
- **Godot:** `SimCore.init_mission_object_tables()` calls `publish_00054_all()`; sets `overlay_00054_published`.
- **[DEFERRED]** (superseded: root `04690` now wired; child table still open).
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — 04690 indexes DAT_0001b524 by desc[1]

- **[PROVEN]** Decomp/Capstone `04690`: `tmpl = DAT_0001b524[desc[1]]`; factory at `*(tmpl+6)`.
- **Godot:** `apply_1b524_type_key`; SimCore default `spawn_1b524_type_key=-1` → use `desc[1]`; override ≥0 for tests.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00000054 Block D → DAT_0001b58c…1b59c

- **[PROVEN]** Capstone `@0x2A4–0x332`: 5× `PEA $1A` / src `$1AAEA…$1AB52` → `MOVE.L D0,$68…$78(A5)` with `A5=$1B524`.
- **Fixture:** `dat_00054_block_d_fixed_slots.json`.
- **Godot:** `apply_00054_block_d`; SimCore `publish_00054_block_d()` / `publish_00054_all()` (A–D).
- **[DEFERRED]** `FUN_00000032` mem copy; record schemas.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00000054 Block C → DAT_0001b524[key]

- **[PROVEN]** Capstone `@0x256–0x2A2`: `LEA $1AA5E,A2`; 5× alloc/copy `0x1C`; `MOVEA.W (A2),A0` → `(A5,A0.L*4)` with `A5=$1B524`.
- **[PROVEN]** ROM keys at record+0 are all `0` (five writes → slot 0; last wins).
- **Fixture:** `dat_00054_block_c_keyed_1c.json`.
- **Godot:** `apply_00054_block_c`; SimCore `publish_00054_block_c()`.
- **[DEFERRED]** Block D (`1b58c…1b59c`).
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00000054 Block B → DAT_0001b540

- **[PROVEN]** Capstone `@0xA2–0x252`: 16 fixed clones (15×`0x1A`, 1×`0x20` @`$1A988`) → `A5($1B524)+off` incl. `+0x1C`→`DAT_0001b540`.
- **Fixture:** `dat_00054_block_b_fixed_slots.json`.
- **Godot:** `apply_00054_block_b`; SimCore `publish_00054_block_b()` sets `dat_0001b540` for `115b0`.
- **[DEFERRED]** Blocks C–D; `FUN_00000032` mem copy.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — 04690 factory resolve from tpl+6

- **[PROVEN]** Capstone/decomp: `fn = *(DAT_0001b524[type]+6)` then `JSR` — install immediates live on the template, not a SimCore side-channel.
- **Godot:** `apply_1b524_resolve_factory` (tpl+6 preferred, `spawn_1b524_factory_imm` fallback); `046da` no longer writes `tpl+6` at call time.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_000115b0 factory (+046da wire)

- **[PROVEN]** Capstone `@0x115b0–0x115d8`: `01b6c(0xa2)`; `*handle=obj`; `obj+4|=0x112000`; `MOVE.L $1b540.L,$4(A0)`.
- **[PROVEN]** Install imm `#0x11590` @`0x115F0` → entry +`0x20` (same class as `16a1a`→`16a3a`).
- **Godot:** `apply_115b0_factory`; SimCore opt-in via `spawn_1b524_factory_imm=#0x11590` + `dat_0001b540`.
- **[DEFERRED]** Real `01b6c`; Block B publish of `DAT_0001b540`; `tpl+6` auto-resolve.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — SimCore 046da → FUN_00016a3a factory wire

- **Godot:** `spawn_1b524_factory_imm` / `spawn_1b524_type_key`; when imm→`0x16A3A`, `046da` runs `apply_16a3a_factory` with `01a68(0x58)` as `01b6c` stand-in, writes `h+4`/flags/`+0x34`, installs `#0x16A1A` at `tpl+6`, then existing +8 clear/`aux`.
- **Opt-in:** default imm=0 keeps mock `spawn_05116_entity_handle` (Mission 1 path unchanged).
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00016a3a factory (+0x20 install fixup)

- **[PROVEN]** Capstone `@0x16AB2`: `MOVE.L #$16a1a, 6(A0)` — immediate lands mid-instruction inside prior function; real entry `LINK.W` @`0x16a3a` (`FUN_00016a3a`). Same delta for `#0x11590` → `@0x115b0`.
- **[PROVEN]** `FUN_00016a3a` `@0x16a3a–0x16a76`: `01b6c(0x58)`; `*handle=obj`; `obj+4|=0x12000`; `clr.w obj+0x34`; `handle+4=DAT_0001b524[type]`; return handle.
- **Godot:** `apply_1b524_factory_entry_addr`, `apply_16a3a_factory` (01b6c deferred — caller handle).
- **[DEFERRED]** Wire into `04690` call path; port `FUN_000115b0`; real `01b6c`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00000054 Block A → DAT_0001b524 publish

- **[PROVEN]** Capstone `@0x54–0xA0`: Loop 4× — `LEA $1A48` (stand-in→`01a68`) alloc `0x4A`, `FUN_00000032` copy from static `@0x1A790` step `0x4A`, `MOVEA.W (A2),A0` then `(A5,A0.L*4)` with `A5=DAT_0001b524`.
- **[PROVEN]** ROM keys: `0x5858`, then three `0x0999` (last write wins for that slot).
- **Fixture:** `hellcats/tests/fixtures/dat_00054_template_records_4a.json` (file `0x1a790`).
- **Godot:** `load_00054_template_records_4a`, `apply_00054_publish_slot`, `apply_00054_first_loop(_record)` — alloc via live `01a68`; copy body deferred (bytes retained on step).
- **[DEFERRED]** Blocks B–D; `FUN_00000032` byte copy into mock mem; factory bodies at `+6`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — Large 019d0 adjacent coalesce (+1b524 factory slot)

- **[PROVEN]** Capstone `0x1A08–0x1A42`: if free block touches next → absorb words; if touches prev → merge into prev (+`01a48` cursor deferred).
- **Godot:** `apply_019d0_free_large` merges adjacent `large_free` nodes; realloc can reuse without `0199a`.
- **[PROVEN]** Runtime installs factories via `*(DAT_0001b524[type]+6)=addr` (e.g. `#0x16A1A` @`0x16AB2`); file image of `1b524` is not the live table (`FUN_00000054` publishes).
- **Godot:** `apply_1b524_set_factory` records the +6 write (no factory body yet).
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004690 / 046da vtable +8

- **[PROVEN]** Capstone `@0x46A2–0x46D0`: if `desc[1]≠0`, `JSR *(DAT_0001b524[type]+6)(obj,type,0)` → `obj+8`; if handle≠0 then `CLR.L (handle)`.
- **[PROVEN]** `046da` `@0x5237–0x5248`: same +8; factory arg3=slot short; copy slot+2/+4/+6 → handle+0x20/22/24.
- **[DEFERRED]** Real `DAT_0001b524` factory bodies — SimCore uses `spawn_05116_entity_handle` as handle.
- **Godot:** `apply_04690_vtable_plus8` / `apply_046da_factory_plus8`; wired in `_call_fun_000046da`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — $1A48 is heap_free epilogue (D0 mystery)

- **[PROVEN]** Capstone `0x19D0–0x1A66`: `FUN_000019d0` ends at `$1A48` (`MOVE.L A1,$20C60` → `BRA $1A64` → `MOVEA.L (A7)+,A2` → `RTS`).
- **[PROVEN]** Kind2 `@0x4ED8` and `@0xB572` `LEA $1A48` then `JSR`, then `MOVE.L D0,…` (malloc convention).
- **[PROVEN]** Real alloc `@0x1A68`: `MOVEM D2-D3/A2`; size at `$10(a7)`; returns payload in D0 — **`$1A48+0x20`**.
- **[INFERRED]** LEA immediates off-by `0x20` (point at free epi instead of `heap_alloc`); Godot stand-in `01a68` matches call convention.
- **QA:** `01a48-kind2-jsr-bytes` locks kind2, B572, free epi, and alloc prologue bytes.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — Capstone: kind2 JSR → $1A48 ≠ heap_alloc

- Superseded by `$1A48` free-epilogue entry above (same evidence, fuller chain).

### 2026-10-15 — SimCore 04e6e +0x4c/+0x44 via 01a68

- **[PROVEN]** Capstone size `(s16+36+s16+3a)*0xC` for both vertex pools (5640–5643).
- **[PROVEN]** Capstone JSR target is `$1A48` (cursor), not `$1A68`; SimCore uses `apply_01a68_alloc` as heap_alloc stand-in (see Capstone entry above).
- **Godot:** `heap_01a68` for `+0x4c` then `+0x44`; `spawn_04e6e_use_mock_ptrs` opt-out.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — SimCore 04808 wires FUN_00001a68

- **[PROVEN]** C `04808`: `01a68(buf_bytes)` → `obj+0x48`; per poly `01a68(count<<1)` → record `+0x18`.
- **Godot:** `SimCore.heap_01a68` + `apply_01a68_alloc` in spawn path; `spawn_04808_use_mock_ptrs` keeps old fixed mocks for opt-out.
- **[PROVEN]** Fixture: 78-byte buf → large/`0199a`; index heaps distinct small-bin payloads.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_0000199a + 01a68 large take/split

- **[PROVEN]** `0199a` (2043–2059): `01958(words<<3)`; store words; tag `0xff`; free payload into large ring.
- **[PROVEN]** `01a68` large (2163–2191): `words=(n+7)>>3+1`; exact unlink or shrink+carve at `addr+remain*8`; payload `+8`.
- **[SIMPLIFIED]** Large ring is an array (no full circular coalesce / `01a48` cursor).
- **Godot:** `apply_0199a_fresh_large` / `apply_01a68_large_alloc` / `apply_019d0_free_large` / `apply_01a68_alloc`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — DAT_00020c64 small freelist pop/push

- **[PROVEN]** `01a68` (2157–2160): if `20c64[bin]` non-null → head=`*head`, tag byte=`bin`, return `head+4`.
- **[PROVEN]** `019d0` small (2117–2121): `header=payload-4`; `*header=old_head`; `20c64[bin]=header` (LIFO).
- **[DEFERRED]** Large `019d0` coalesce (`header==-1`); `0199a`; SimCore live heap wiring.
- **Godot:** `apply_01a68_small_alloc` / `apply_019d0_free_small` on bump+freelist state.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00001974 fresh small-bin (+01958 bump)

- **[PROVEN]** `01958` (2013–2021): `block = heap_base + DAT_00020c50`; cursor `+= grow`.
- **[PROVEN]** `01974` (2025–2039): `grow=1<<(bin&0x3f)`; header byte=`bin`; payload=`block+4`. Called when `DAT_00020c64[bin]` null.
- **[DEFERRED]** Freelist pop; `0199a` large; `0xffffffff` failure; SimCore live heap.
- **Godot:** `apply_01958_heap_bump` / `apply_01974_fresh_small_bin` / `apply_01a68_fresh_small_from_request`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00001a68 size-class routing

- **[PROVEN]** `Pacific Conflict.c:2148–2164`: `rounded=(n+7)&~3`; bin loop from `((rounded-1)>>2)` starting at 2; `<6` → small bin; else `large_words=(n+7)>>3+1`.
- **[PROVEN]** Examples: req 10→bin4/cap12; `0x18`→bin5/cap28; `0x40`→large words9; `0x52`→words12.
- **[DEFERRED]** Freelist `DAT_00020c64`/`20c60`, `01974`/`0199a`, real payload return; `01a48` ABI.
- **Godot:** `apply_01a68_round_bytes` / `apply_01a68_route` / `apply_01b38_zero_bytes` (size only).
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00002d10 null-aux always-0253e

- **[PROVEN]** `Pacific Conflict.c:3387–3439`: always `0253e`→`02ada`→`01c5c` per node; no angle gate; no `+0x34` shift; commit when both aux null (same as `02bd8`).
- **[PROVEN]** Sole caller `FUN_000168d2` (UI/menu paths) — not spawn `04e6e`→`02bd8`.
- **[DEFERRED]** Both-aux mesh path; real `+0x30`/`byte@+2` slot indexing; `168d2`/`01b6c` wiring.
- **Godot:** `apply_02d10_null_aux_node` / `_walk`; epilogue reuses `apply_02bd8_null_aux_commit`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — DAT_0001b190 ROM band table

- **[PROVEN]** 40× `int32` BE @ file `0x1b190` in `Pacific Conflict` (255360); `DAT_0001b18c[s]` ≡ `table[s−1]`.
- **[PROVEN]** Indices 0–7 header/sentinel; monotonic thresholds from index 8 (`40041`…`100000000`).
- **[PROVEN]** `03da8` with `field_30=0`, `param_2=0x10` → band **3** (mock previously → 1).
- **Godot:** fixture `dat_0001b190_band_table.json`; `FlightMath.load_dat_0001b190_table()`; `SimCore` loads in `_init`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_0000253e 3-angle attitude matrix

- **[PROVEN]** `0253e` = `0202a(a,b,c,0)` → `024f8` (`020e6` then `01d02(Rz,Rx)`→`01d02(temp,Ry)`).
- **[PROVEN]** Numeric ≡ `025a8(0,a,b,c)` when fourth angle is 0.
- **[RESOLVED — see 2026-10-15 tag map]** `DAT_00020ce4` stores a code address; JSR'd by `invoke_tagged_attitude_compose_neg_sins{4,6}`.
- **Godot:** `fun_000024f8` / `fun_0000253e`; `02bd8` rotate path builds matrix from slot angles when no fixture `matrix9`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00002ada matrix×vec3 (>>12, no +0x800)

- **[PROVEN]** Capstone `@0x2ADA–0x2BBA`: expand s16[9] → s32; for each int32 vec3, column-dots `>>12` (no `+0x800`, unlike `028dc`).
- **[PROVEN]** `02bd8` rotate path: `0253e` then `02ada` (fixture `matrix9` optional override).
- **Godot:** `fun_00002ada`; wired into `apply_02bd8_*_node`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_000044a4 type-5 flags ±0x40


- **[PROVEN]** Pacific Conflict.c:5083–5089: if `*(obj+8)!=0` and `**(short**)(entity+4)==5`, then `*(b5a0+0xb0)==0` → `flags_04|=0x40`, else `&=~0x40`.
- **Godot:** `apply_044a4_type5_flags`; `SimCore._apply_fun_000044a4` (0435a then type-5); `mission_short_b0`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_0000435a on tick FUN_000044a4

- **[PROVEN]** Pacific Conflict.c:5082: `FUN_000044a4` calls `FUN_0000435a(param_1, param_2)` before the type-5 flag tweak.
- **[RECONSTRUCTED]** `SimCore._update_single_entity` runs `_apply_fun_000044a4` when the entity has a world obj.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00002bd8 both-aux 01c5c + field_34 shift


- **[PROVEN]** Pacific Conflict.c:3367–3371: when mesh and verts both non-null, `01c5c(count, mesh, verts, dx<<(field_34&0x3f), ...)`; then `param_3 ← param_4` for next node.
- **[DEFERRED]** `0253e`/`02ada` when node shorts nonzero; real chain `+0x24`/`+2` table index.
- **Godot:** `apply_02bd8_shifted_deltas`, `apply_02bd8_both_aux_node`/`_walk`; `SimCore` both-aux path when mesh+verts set.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00001c5c + 02bd8 null-OR template walk

- **[PROVEN]** `FUN_00001c5c` (2313–2331): for `count` vec3s, `dst = src + (dx,dy,dz)`.
- **[PROVEN]** `FUN_00002bd8` (3347–3360): node needs rotate if any of `+2/+4/+6` shorts nonzero; null-OR aux path calls `01c5c(1, local, local, +8/+c/+10)` when !rotate.
- **[DEFERRED]** `0253e`/`02ada` rotate path; chain link via `+0x24`/`+2`.
- **Godot:** `apply_fun_00001c5c`, `apply_02bd8_null_aux_node`/`_walk`; `SimCore.last_02bd8_walk`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_0000435a kind2 poly +0x1c loop


- **[PROVEN]** Pacific Conflict.c:5048–5071: when kind==2 and `param_2==0`, for each poly write `buf+0x1c` from `*(stream+10)`: player→`*5`, else half or `*iVar4`; stride `0x20`; stream `+0x0E+count*2`.
- **[DEFERRED]** Real stream base (`b5a0+0x8c` + template offset + `0x22+(1a+1e)*0xc`); `DAT_0001b738` player compare.
- **Godot:** `apply_0435a_poly_1c_value` / `apply_0435a_poly_1c_loop`; `SimCore` overwrites `04808` buf `+0x1c`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_0000435a gate + +0xc scale

- **[PROVEN]** Pacific Conflict.c:5018–5046: enter if `(+7)&2==0` and `0 < *(b5a0+0xa8) < 6`; scale `iVar4 = phase-1` or `1` if `(+5)&2`; skip `+0xc` when `==1000000000`; else half/`*iVar4` from `*(tpl+0xe)`; kind2 clamp to `0x42B209` when `>(and +6 bit4 clear)`.
- **[DEFERRED]** real template `+0xe` via `b5a0+0x8c` chain.
- **Godot:** `apply_0435a_gate` / `apply_0435a_scale_factor` / `apply_0435a_field_0c`; `SimCore.last_0435a`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00003da8 distance-band index


- **[PROVEN]** Pacific Conflict.c:4675–4697: `s=*(obj+0x30)`; compare `param_2` to `DAT_0001b190[s]` / `DAT_0001b18c[s]`(=`table[s-1]`); in-band → return 0; else walk ± and write `+0x30`, return 1.
- **[PROVEN]** ROM table imported via `hellcats/tests/fixtures/dat_0001b190_band_table.json` (see 2026-10-15 entry).
- **Godot:** `apply_fun_00003da8`; wired after post-`02bd8` followup with `param_2=*(obj+0x10)`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004e6e post-02bd8 → 0435a / 03da8

- **[PROVEN]** Pacific Conflict.c:5657–5658: after `02bd8` on kind2 fall-through, `FUN_0000435a(obj, 0)` then `FUN_00003da8(obj, *(obj+0x10))`.
- **[DEFERRED]** Body of `0435a`; `02bd8` template walk; alt paths when bit4 set on `+5/6/7`.
- **Godot:** `apply_04e6e_post_02bd8_followup`; `SimCore.last_04e6e_followup`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004808 (obj+6)&2 trailer


- **[PROVEN]** Pacific Conflict.c:5306–5311: if `(obj+6)&2`, at `*(+0x48)+field_3a*0x20` write u16 `0 .. field_38-1`.
- **[PROVEN]** Buffer size already included trailer region via `apply_04808_buffer_bytes` bit1 extras.
- **Godot:** `apply_04808_bit1_trailer`; `SimCore` writes trailer words after poly loop.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004808 multi-poly loop

- **[PROVEN]** Capstone `@0x4858–0x48E4`: loop `i=0..field_3a-1`; record stride `0x20`; after each poly `param_2 += 0x0E + count*2`.
- **[PROVEN]** Per poly: header fill + `01a68(count<<1)` → `+0x18` + index copy (already ported).
- **[DEFERRED]** real `01a68` heap identity.
- **Godot:** `apply_04808_stream_advance`, `apply_04808_poly_loop`; `SimCore` fills N polys from desc stream.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00002bd8 null-aux +18/+1c/+20 commit


- **[PROVEN]** Pacific Conflict.c:3377–3381: when `param_3==0` and `param_4==0`, write locals → `obj+0x18/+0x1c/+0x20`. Does **not** touch `+0x44`.
- **[PROVEN]** Empty template chain (`+0x24==0`): loop skipped → locals unchanged (identity commit).
- **[PROVEN]** `04e6e` call passes non-null mesh/`+0x44` → commit skipped on that path.
- **[DEFERRED]** Template walk / `0253e` / `02ada` / `01c5c` mutating locals before commit.
- **Godot:** `apply_02bd8_null_aux_commit`; `SimCore.last_02bd8_commit`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004e6e → 02bd8 flag gate

- **[PROVEN]** Capstone `@0x4F4A/4F88/4FEE`: `FUN_00002bd8` only when bit4 clear on `obj+5`, `+6`, and `+7`.
- **[PROVEN]** Args `@0x502E–0x503A`: `(obj, s16(36)+s16(3a), mesh_base, *(obj+0x44))`.
- **[DEFERRED]** `FUN_00002bd8` template walk; `01c5c`/`0435a` alt paths; `04808` multi-poly.
- **Godot:** `apply_04e6e_02bd8_gate`, `apply_04e6e_02bd8_args`; `SimCore.last_02bd8_*` after `04808`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004808 index-word alloc + copy


- **[PROVEN]** Capstone `@0x48A2–0x48B0`: `01a68(s16(count)<<1)`; ptr → poly `+0x18`. Count = poly `+0x14` (= desc byte `@8`).
- **[PROVEN]** `@0x48B8–0x48CE`: copy `count` u16 words from desc `@+0x0E`; stream advances `0x0E+count*2`.
- **[PROVEN]** Post-`04808` `02bd8` gate `@0x4F4A/4F88/4FEE`: bit4 clear on `obj+5/6/7`; args `(obj, 36+3a, mesh, +0x44)`.
- **[DEFERRED]** Multi-poly loop iterations; bit1 trailer `@0x48E6+`; flag-gated `02bd8` wire.
- **Godot:** `apply_04808_index_alloc_bytes`, `apply_04808_index_words`; `SimCore` mock index heap + first-poly copy.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004808 buffer size + one poly record

- **[PROVEN]** Capstone `@0x4814–0x483A`: buffer bytes = `s16(+0x3a)*0x20`; if `(obj+6)&2` then `+= s16(+0x3a)*6 + s16(+0x38)*2`. Result ptr → `obj+0x48` via `01a68` (mocked).
- **[PROVEN]** `@0x4858–0x4898`: first poly record stride `0x20`: `+8=0`; `+0xc←u32@0`; `+0x10..13←bytes@4..7`; `+0x14←u16(byte@8)`; `+0x16←byte9&0xf0`; `+0x17←byte9&0x0f`; `+0x1c←u32@0xa`. Then `DAT_0001daa2=1`.
- **[DEFERRED]** Multi-poly loop; flag-gated `02bd8`/`01c5c`/`0435a`.
- **Godot:** `apply_04808_buffer_bytes`, `apply_04808_poly_record`; `SimCore` sets `+0x48`, optional first record, `dat_0001daa2`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00004e6e kind2 list + alloc size (5631–5643)

- **[PROVEN]** Capstone `@0x4E8E–0x4EBE`: `(obj+7)&1` → `DAT_0001d4a4[c1e0++]`; else `DAT_0001b5a4[b734++]`.
- **[PROVEN]** `@0x4EC4–0x4ED6`: `01a48` size = `(s16(+0x36)+s16(+0x3a))*0xC` (stack arg; Ghidra omitted). Both `+0x4c` and `+0x44` use that size.
- **[DEFERRED]** `FUN_00004808` index-word / multi-poly; flag-gated `02bd8`/`01c5c`/`0435a`.
- **Godot:** `apply_04e6e_kind2_list_select`, `apply_04e6e_kind2_alloc_bytes`; `dat_0001b5a4_world` / `dat_0001d4a4_world`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00001d56 call-site ≡ FUN_00001d76 (sin)

- **[PROVEN]** Capstone `@0xF4A2`: `LEA $1d56; JSR`; `$1d56` is matrix-mul epilogue mid-label; real sin is `@0x1D76` (**+0x20**, same pattern as `$2DE8`→`$2E08`). Zero absolute refs to `$1d76`; five to `$1d56`.
- **[PROVEN]** Arg = `local_28`/`pos_20` angle; D0 = sin-table lerp (`DAT` usable base file `0x1ab8c`). Twin: `$1db8`→`$1dd8` cos.
- **[RECONSTRUCTED]** `fun_00001d56_callsite` → `fun_00001d76`; `apply_lab_0000f47c` uses it (removed `0x1000` stand-in).
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — Contact 61a/61e → pos_20 / field_24 (14095–14101)

- **[PROVEN]** Capstone `@0xE864–0xE894`: two `LEA $11544; JSR` → `61e += D0&0x7f`; `field_24 = (field_24+61e)&0x3fff`; `61a -= D0&0x7f`; `pos_20 = (pos_20+61a)&0x3fff`; clear `669`; bra exit.
- **[RECONSTRUCTED]** Ghidra `param_1+9/+8` are uint* slots → offsets `0x24`/`0x20` (`field_24`/`pos_20`), not attitude_22.
- **Godot:** `apply_contact_61a_61e_attitude`; wired in `SimCore._apply_ground_contact_early_out`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — Capstone: FUN_00003b98 camera-relative abs axes

- **[PROVEN]** Capstone `@0x3B98`: `a0=*(obj+0x18)−DAT_0001d838` (then `+0x1c/−d834`, `+0x20/−d830`); push; `JSR` abs; combine; `MOVE.L D0,$10(A3)`.
- **[PROVEN]** Real abs is `FUN_00002e08` `@0x2E08` (`MOVE.L 4(A7),D0; BGE; NEG; RTS`). Call sites `LEA $2DE8` hit a **false mid-label** inside `FUN_00002d10` epilogue (0x20 bytes before abs); same stack ABI as `02e08`.
- **[RECONSTRUCTED]** Godot: `apply_03b98_camera_abs_axes` + `dat_0001d838/834/830`; derives axes from world pos unless override set.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green. Binary: `Hellcats/Pacific Conflict` (255360).

### 2026-10-15 — FUN_00003b98 metric combine (4522–4544)

- **[RECONSTRUCTED]** `metric = max(a,b,c) + ((sum of other two) >> 2)`; writes `obj+0x10`; D0==metric (twin `FUN_00003c00` returns same).
- **Godot:** `apply_fun_00003b98`; `SimCore` writes `+0x10` then feeds gate.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — world+0x44 via 046da→04e6e gate (5252–5258, 5640–5643)

- **[PROVEN]** `FUN_00002bd8` does **not** write `+0x44` (updates `+0x18/+0x1c/+0x20` only when both aux ptrs null).
- **[RECONSTRUCTED]** After `0435a`, `(FUN_00003b98_D0 − obj[+0xc]) < 0x19c80` → `FUN_00004e6e`; else push onto `DAT_0001d0e4[]`.
- **[RECONSTRUCTED]** `04e6e` kind 2: `+0x4c = FUN_00001a48(); +0x44 = FUN_00001a48()` (real `01a48` ABI still BLOCKED — mock ptrs).
- **[INFERRED]** `03b98` Ghidra-void; callers use D0 — harness `spawn_046da_03b98_metric` stand-in.
- **Godot:** `apply_046da_04e6e_distance_gate`, `apply_04e6e_kind2_vertex_ptrs`; `05116` gate reads `mem[world+0x44]`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_000045ba kind 2/3 field copy (5149–5190)

- **[RECONSTRUCTED]** Kind 2 → size `0x52`: copy desc coords/flags/shorts; `obj+0x38` defaults to 1 when desc+0x1c==0; `obj+0x40=DAT_0001b838`. Kind 3 → size `0x34` + desc back-pointer at `+0x28`.
- **[DEFERRED]** Real `FUN_00001b6c` heap; other kind tags; `+0x44` (not written by 045ba); vtable factory at `+8` (`046da`/`04690`).
- **[INFERRED]** Mock world pointer still from `spawn_05116_world_obj`; `+8`/`+0x44` still mock-installed after identity stores.
- **Godot:** `apply_045ba_from_desc`; `SimCore._call_fun_000046da` applies fields before identity.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_000046da identity stores (5227–5235)

- **[RECONSTRUCTED]** After `045ba` / slot+0x14 publish: `world+0x24=DAT_0001d6fc`; `+1=template`; `+2=slot`; if `slot==tpl` then `+3++`; if `tpl<*(pool+0x2c)` then `*(u32*)(world+4)|=1`.
- **[DEFERRED]** `FUN_000045ba` alloc; vtable install at `+8`; `02bd8` / `0435a` / `03b98` / `04e6e`.
- **[INFERRED]** Mock still supplies `world+8` entity handle and `+0x44` gate (not written by 046da body).
- **Godot:** `apply_046da_identity_stores`; `SimCore._call_fun_000046da`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00001ba8 grow-by-10 in FUN_00005116

- **[RECONSTRUCTED]** `FUN_00001ba8` (2252–2271): grow-only realloc; if capacity < request → alloc+zero (`01b84`), copy old capacity (`1a63e`), free old (`019d0`).
- **[RECONSTRUCTED]** `05116` full pool (5726–5731): `01ba8(table,(count+10)*0x18)`; `*(d6fc+0x30)=new`; `*(d6fc+0x2e)+=10`; fill slot at old count.
- **[INFERRED]** Flat `mem_u32` model copies logical slots and zeros +10; real heap header capacity / `01b84`/`019d0` deferred.
- **Godot:** `grow_05116_request_bytes` / `apply_01ba8_05116_grow`; `SimCore._grow_05116_table`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00019430 0xd vertex scale loop

- **[RECONSTRUCTED]** `FUN_00019430` (23098–23110): `vert_base=*(world+0x44)`; for `i` in `0..0xc`: in-place `x/y/z>>=3` at `vert_base+i*0xc`; `entity+0x622+i*4=x*0x1c6`, `+0x656+i*4=y*0x1c6`, `+0x68a+i*4=z*0x255`.
- **[INFERRED]** `world+0x44` doubles as 05116 success gate (nonzero) and vertex table pointer.
- **Godot:** `apply_fun_00019430_vertex_loop`; `EntityState.vertex_scale_622/656/68a`; wired in `_call_fun_00019430`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_0001a63e matrix copy into entity+0x40

- **[RECONSTRUCTED]** `FUN_0001a63e` (23890–24010): general memmove `src→dst`, nbytes in arg3. `15bf6` call uses immediate `0x12` (Ghidra `&DAT_00000012`) = 18 bytes = 9×s16.
- **[RECONSTRUCTED]** Godot: `fun_0001a63e_copy_matrix9` (forward non-overlap path only); `EntityState.attitude_matrix_40`; wired after `15bf6` spawn field writes.
- **[DEFERRED]** Full overlap/backward memmove; longword fast path for `n>0x19`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_0000262e / 021e0 wired into 15d20→15bf6

- **[RECONSTRUCTED]** `FUN_000021e0`: X-axis basis `[1,0,0; 0,c3,-s3; 0,s3,c3]` (twin of `021a0`).
- **[RECONSTRUCTED]** `FUN_0000262e` (2970–2976): `0202a(p2,p3,p4,p1)` → `020e6` → `021e0` → `02562` (same product as `025a8` with X-axis 4th).
- **[RECONSTRUCTED]** `15d20` builds matrix via `0262e(yaw_arg,pos_20,att22,field_24)`; `15bf6` runs `028dc` on locals before 11544 RNG.
- **[RECONSTRUCTED]** `1a63e` → `entity+0x40` — see entry “FUN_0001a63e matrix copy…”.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00015bf6 / 15d20 spawn path (028dc/1a63e deferred)

- **[RECONSTRUCTED]** `FUN_00015bf6` (20088–20128): `local_6=(speed>>4)+0x2015`; three 11544 draws perturb locals; `05116(DAT_0002664a, xyz+locals>>2, 0…)`; on success write `state_32=a<<4`, `+8/+c/+10=locals>>2`, `field_38=0`, `count_3a=(param_2==0)?1:2`.
- **[RECONSTRUCTED]** `FUN_00015d20` (20133–20141) → `15bf6(..., param_2=1, …)`; player latch `short*[0x1b]=1` (`field_36`).
- **[RECONSTRUCTED]** `0262e`/`028dc` into locals — see entry “FUN_0000262e / 021e0…”. `1a63e` still deferred.
- **Godot:** `apply_15bf6_local_perturb` / `apply_fun_00015bf6_spawn_fields`; `SimCore._call_fun_00015bf6` / `_call_fun_00015d20`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00019430 post-spawn writes (vertex loop deferred)

- **[RECONSTRUCTED]** `FUN_00019430` (23077–23114): `05116(DAT_00026780, xyz, att, 0)` → `entity=*(world+8)`; `field_610=DAT_0001b838` (u32); `field_614=param_1`; `+0x20/22/24`; `field_618=7`; `field_61c=0x62`.
- **[DEFERRED]** 0xd vertex `>>3` / `*0x1c6`/`*0x255` loop over `*(world+0x44)`; `FUN_0001a63e`.
- **Godot:** `apply_fun_00019430_spawn_fields`; `SimCore._call_fun_00019430` (pool or entity fixture); player `DAT_0001b87c`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00012840 wired through FUN_00005116 pool

- **[RECONSTRUCTED]** When `*(DAT_0001d6fc+0x30)` and slot count > 0: `12840` calls `05116(DAT_00026280, xyz, att, 0)`, then `entity=*(world+8)`, then post-spawn field writes (17551–17571).
- **[INFERRED]** Without a configured pool, entity-fixture bypass remains (no allocator) for unit harnesses.
- **Validation:** `_test_fun_00012840_via_05116_pool`; Godot **13 passed, 0 failed**; Python QA green.

### 2026-10-15 — FUN_00005116 free-slot scan + fill + world gate

- **[RECONSTRUCTED]** `FUN_00005116` (5705–5746): scan `*(DAT_0001d6fc+0x30)` slots of `0x18` for `+0x14==0`; fill `+0/+2/+4/+6` attitudes and `+8/+c/+10` xyz; `046da`; return world at `+0x14` iff `*(world+0x44)!=0` else `051ec`→0.
- **[DEFERRED]** `FUN_00001ba8` grow-by-10 when full; real `FUN_000046da` (mock installs `spawn_05116_world_obj` / `world+8` entity handle).
- **Godot:** `find_05116_free_slot_index` / `apply_05116_slot_fill` / `apply_05116_world_gate`; `SimCore._call_fun_00005116`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green. `12840` still uses entity fixture for field writes.

### 2026-10-15 — FUN_00012840 post-spawn field writes (05116 deferred)

- **[RECONSTRUCTED]** `FUN_00012840` (17551–17571): `05116(DAT_00026280, xyz, att, 0)` → on success `entity=*(obj+8)`; if `param_2≠0` `field_61c|=0x40`; write `field_610=param_1`, `+0x20/+0x22/+0x24=param_6/7/8`.
- **[RECONSTRUCTED]** Player fire latch (14655–14658): non-null + player → `DAT_0001b880`, `short*[0x30a]=1` (byte `0x614`), `DAT_0001b846=1`.
- **[RECONSTRUCTED]** `FUN_00005116` free-slot path — see entry “FUN_00005116 free-slot…”. `01ba8`/`046da` still deferred.
- **Godot:** `apply_fun_00012840_spawn_fields`; `SimCore._call_fun_00012840`; entity offsets `field_610`/`614`/`61c`.
- **Validation:** Godot **13 passed, 0 failed**; Python QA green. Mission 1 unchanged.

### 2026-10-15 — FUN_00011544 call-site alias + flags_685&2 + @ field_18c

- **[RECONSTRUCTED]** Binary `Hellcats/Pacific Conflict`: 17× `LEA.L $11544; JSR (An)` then use D0 as u16 (`&0x7f` / `&0x3f` / …). Bytes at `$11544` are the `1150a` warm-up epilogue (`cursor+=0xd8`; 10000×`BSR $11564`; `MOVEM`; `RTS`). Bytes at `$11564` are the overlay RNG. Zero absolute LEA/JSR to `$11564`.
- **[INFERRED]** Call-site “FUN_00011544” ≡ one `FUN_00011564` draw (D0 = `sum>>16`). Executing `$11544` literally would be 10k draws + unbalanced MOVEM — not viable per tick. Godot: `RngOverlay11564.fun_00011544_callsite()` → `next()`.
- **[RECONSTRUCTED]** `flags_685&2` ammo tail (14721–14734): first callsite draw; if `(d0&0x3f)==0` second draw; if `(d1&1)==0` or `67d==0` then `67e--` if nonzero else `67d--`. Godot: `apply_e792_flags685_bit2_tail` / `SimCore._apply_e792_flags685_bit2_tail`.
- **[RECONSTRUCTED]** Grounded `@` (0x40): two callsite draws → `field_18c += (d0&0x7f)`, `uVar13=(d1&0x7f)-0x40` with speed scale; optional third `11564` for `b854` when player/`b856==0`/speed≥`0x2d1` (14537–14555).
- **[DONE]** Contact-path `0x61a`/`0x61e` → `pos_20`/`field_24` via 11544 — see entry “Contact 61a/61e…”.
- **Validation:** Godot **13 passed, 0 failed**; `python3 tools/qa/test_regression.py` green. Mission 1 / `FlightModelMvp` unchanged.

### 2026-10-15 — FUN_00011564 overlay RNG fixture (not yet SimCore)

- **[RECONSTRUCTED]** `FUN_00011564` (Pacific Conflict.c:16407–16433): table RNG at `DAT_00026008`…`0x260e4` (56 words **[INFERRED]** from span); `*p4 = *p5 + *p3`; return `sum >> 16`; wrap rules `+4`/`-0xd8`, `+0x17`/`-0x20`, `+0x36`/`-1` words vs limit `0x260e7`.
- **[RECONSTRUCTED]** Godot: `hellcats/core/rng_overlay_11564.gd` + `godot/tests/unit/test_rng_overlay_11564.gd` fixture sequence.
- **SimCore wiring:** `_rng_consume()` uses `RngOverlay11564`; ID05 on `rng_id05`.
- **[RECONSTRUCTED]** `FUN_000114ca` + `FUN_0001150a` fill (`table[1]=param`, `table[i+1]=114ca(0x1df5e0d,table[i])+1` for i=1..0x36), cursor `0x260e4`, then 10000×`11564`. `set_seed` = full `init_1150a`.
- **[UNKNOWN]** Pre-init value of `table[0]`; treated as 0.
- **Validation:** fill + warm-up fixtures; suite **12 passed, 0 failed**.

### 2026-10-15 — FUN_0000e792 contact early-out (SimCore)

- **[RECONSTRUCTED]** When `(status_1a1 & 8) != 0` (Pacific Conflict.c:14083–14104): compare `pos_2e` to surface`+(-0x16)`; set `position_velocity_c` to `-0x16` or `pos_2e+template_field_40_adj-surface`; if `field_0b==0x10` OR status `0x1000` and if player set `DAT_0001b850=1`; clear `movement_669`; **return** (skips later e792 slices).
- **[RECONSTRUCTED]** `iVar1 = *param_1` is a pointer; surface = `*(iVar1+0x1c)` (14084). Same pattern `*DAT_0001b738+0x1c` (7354, 7671). Godot: `EntityState.world_obj_ptr` + `SimCore.mem_u32[ptr+0x1c]`.
- **[INFERRED]** `field_00` type byte vs word-0 pointer overlay unresolved without a byte-accurate entity image.
- **[DEFERRED]** `FUN_00011544` RNG updates to `0x61a`/`0x61e` (bad decomp / void return).
- **Validation:** contact tests use `world_obj_ptr` + `mem_u32`; suite green; Mission 1 not wired.

### 2026-10-15 — FUN_0000528a / FUN_000051ec (SimCore cleanup)

- **[RECONSTRUCTED]** `FUN_0000528a` (Pacific Conflict.c:5784–5798): early-out if `param_1[7]&2`; else if `(field_24==DAT_0001d6fc && b88e<=field_01<=b88c) || type!=2` → `FUN_000051ec`; else type-2 alt `field_04\|=0x42`, `field_3c=DAT_0001b838`.
- **[RECONSTRUCTED]** `FUN_000051ec` entity writes: `pos_18=1000000000`, `field_04\|=2`, `field_3c=0`; optional `DAT_0001bc64` clear when `field_01!=field_02` and in `[b88e,b88c]`; `DAT_00024cf0++`; clear `DAT_0001b880` when `entity+8` matches.
- **[RECONSTRUCTED]** Indirect stores via `SimCore.mem_u32`: table poke `*( *(DAT_0001d6fc+0x30) + 0x14 + field_02*0x18 ) = 0` when `field_01!=field_02`; `**(entity+8)=0` when `entity_data_ptr!=0`.
- **[INFERRED]** Flat `mem_u32` address map stands in for Mac heap; not a full allocator.
- **Entity offsets added:** `field_01`, `field_02`, `flags_07`, `field_24`, `field_3c`.
- **Validation:** `_test_fun_0000528a_branches` (incl. indirect); suite **11 passed, 0 failed**; Python QA passed.

### 2026-10-15 — FUN_00005df8 slot clear (SimCore)

- **[RECONSTRUCTED]** `FUN_00005df8` (Pacific Conflict.c:6434–6447): when `DAT_0001b5a0+0xac == 0`, for `i` in `0..6`, if `DAT_0001bc64[i] != 0` call **`FUN_0000528a`** then set the slot to 0.
- **[RECONSTRUCTED]** Godot: `SimCore.dat_0001bc64` (7 slots), `_call_05df8()`, `last_tick_order.fun_00005df8_*` / `fun_0000528a_calls`.
- **Validation:** `_test_fun_00005df8_slot_clear`; suite green; Python QA green.
- **Follow-up:** `FUN_0000528a` / partial `FUN_000051ec` ported in the same-day entry above.

### 2026-10-15 — FUN_00006fb8 post-tick global reset (SimCore)

- **[RECONSTRUCTED]** `FUN_00006fb8` (Pacific Conflict.c:7180–7189) assigns `100000000` to **`DAT_0001d718`**, **`DAT_0001d724`**, **`DAT_0001d714`**, **`DAT_0001d720`**, **`DAT_0001d710`**, **`DAT_0001d71c`** after the four entity passes in **`FUN_000044e8`**.
- **[RECONSTRUCTED]** Godot: `SimCore._call_06fb8()` writes the same six fields; `last_tick_order.fun_00006fb8_ran` / `fun_00006fb8_globals`; skipped when phase gate closed.
- **[INFERRED]** Later readers treat some of these as coordinate / distance bases (e.g. uses near Pacific Conflict.c:5413). Exact game names **[UNKNOWN]**.
- **Validation:** `test_sim_tick_ordering.gd` `_test_fun_00006fb8_reset`; full suite **11 passed, 0 failed**; Python QA passed.
- **Not claimed:** playable Mission-1 wiring; `FUN_00005df8` still placeholder.

### 2026-10-15 — P0 headless test reliability (class_name + QA paths)

- **[INFERRED]** Fresh `godot --headless --path . --script res://godot/tests/run_all.gd` without a `.godot/` global class cache does not resolve `class_name` identifiers used as type annotations. That broke `EntityState.from_bytes() -> EntityState` (script failed to parse → `preload(...).new()` failed) and logged parse errors for `HudAttitudeStrip` / `MissionCheckpoint`.
- **[MVP AUTHORING DECISION]** Keep `class_name` declarations for editor convenience, but type cross-script references with base types (`Control`, `Node3D`) or leave returns untyped so headless CI works without an imported project cache.
- **Files:** `hellcats/core/entity_state.gd`, `hellcats/ui/hud_mvp.gd`, `hellcats/mission/checkpoint_manager.gd`, `hellcats/mission/mission_controller.gd`, `tools/qa/test_regression.py` (`EXPECTED_RUNNER_PATHS` aligned with `run_all.gd`), `hellcats/tests/fixtures/proven_loader_targets.json` (byte-synced to migrated fixture).
- **Validation:** Godot **11 passed, 0 failed** (exit 0); `python3 tools/qa/test_regression.py` **All deterministic QA regression checks passed** (exit 0).
- **Not claimed:** visual fidelity, Mission 1 playthrough, or original-flight parity. No gameplay behavior changed.

### 2026-04-08 — Convergence Loop Mode (batch: mission bridge + RNG draws + FUN_0000435a counts)

- **[INFERRED]** Backlog + loop template: `docs/CONVERGENCE_BACKLOG.md`, `docs/CONVERGENCE_LOOP_TEMPLATE.md`.
- **[RECONSTRUCTED]** **Iteration 1 — Mission gates:** `MissionController` sets **`mission_phase_a8` / `mission_flag_ac`** (running: 1/1; terminal: 0/0); **`get_mission_sim_bridge_state()`**. See `docs/contracts/mission_state_DAT_contract.md`.
- **[RECONSTRUCTED]** **Iteration 2 — RNG timing:** `SimCore._rng_consume()` counts draws per tick; **`last_tick_order.rng_draws_this_tick`**.
- **[RECONSTRUCTED]** **Iteration 3 — FUN_0000435a / param_2:** **`last_tick_order.param_2_entity_updates`** `{0: n, 1: m}`; contract `docs/contracts/FUN_0000435a_contract.md` (type 0x02 loop gated by `param_2==0` not yet branched in code).
- **Validation:** `godot/tests/integration/test_sim_tick_ordering.gd` (includes RNG/param2 counts).

### 2026-10-15 — e792 bVar6 cleanup epilogue

- **[RECONSTRUCTED]** End of `FUN_0000e792` (14736–14748): when `bVar6` (rough landing 14462 or grounded `field_0b` switch), clamp/clear `status_1a2`, `status=(status&0x8000)|0x900`, `state_32=0xe772`, clear `movement_61a`/`61e`. Godot: `apply_e792_bvar6_cleanup`; `SimCore.e792_b_var6`.
- **[RECONSTRUCTED]** `flags_685&2` ammo-decrement tail — see entry “FUN_00011544 call-site alias…”.
- **Validation:** `test_flight_math.gd` (`_test_e792_bvar6_cleanup`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_bvar6_cleanup`).

### 2026-10-15 — e792 field_676/677 weapon tails

- **[RECONSTRUCTED]** `field_676` (14673–14693): when nonzero, if `676==1` and `field_682>1` and `(flags_685&0x10)==0` → stub `FUN_00015d20`, `682-=2`; then `676++` wrap 2→0. `field_677` (14695–14719): when `677==1` and `(flags_685&1)==0` → stub `FUN_00019430`, `status|=1`, `677←2`; player sets `DAT_0001b874`/`b872`/`d858=9`/`b87a`. Godot: `apply_e792_weapon_676_branch` / `677_branch`.
- **[DEFERRED]** `FUN_00015d20` / `FUN_00019430` bodies; world+7 bit clear; `FUN_000137da`; `FUN_00006ed6`.
- **Validation:** `test_flight_math.gd` (`_test_e792_weapon_676_677_branch`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_weapon_676_677_branch`).

### 2026-10-15 — e792 weapon field_19d/19f branch

- **[RECONSTRUCTED]** When `field_19d!=0` and `field_19f!=0` (14648–14671): if `19d==1` call `FUN_00012840`, `19f--`, `field_18d-=0x10` unless `*(DAT_0001b5a0+0x90)==2`; then `19d++` with wrap when pre-value was 4 → 0. Godot: `apply_e792_weapon_19d_branch`; `SimCore.mission_short_90`.
- **[RECONSTRUCTED]** `FUN_00012840` post-spawn writes + player latch — see entry “FUN_00012840 post-spawn…”. `FUN_00005116` still deferred.
- **Validation:** `test_flight_math.gd` (`_test_e792_weapon_19d_branch`, `_test_fun_00012840_spawn_fields`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_weapon_19d_branch`, `_test_fun_00012840_spawn_fixture`).

### 2026-10-15 — e792 67b/679 char epilogue

- **[RECONSTRUCTED]** After LAB_0000f47c (14631–14647): `field_67b++` when `(0<c<0x0f)||c<0`; `direction_char_679` mid-range `1..','` with `(flags_685&0x20)==0` → `++`, `field_67a|=2`, `status&=~0x2000`; negative 679 (outer gate) → `++`, `67a|=2`, `status|=0x2000`. `'-'` (0x2d) does not bump. Godot: `apply_e792_char_epilogue`.
- **Validation:** `test_flight_math.gd` (`_test_e792_char_epilogue`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_char_epilogue`).

### 2026-10-15 — LAB_0000f47c yaw epilogue

- **[RECONSTRUCTED]** LAB_0000f47c (14606–14629): clear `field_63f`; commit `pos_20`/`attitude_22` from `local_28`/`local_2a`; `field_24 = (uVar13 + e40c(local_2a−att22)*scale>>12) & 0x3fff`; `movement_62a = iVar20`; player ring `DAT_0001bc8c[0x78]` / `bc80` / `bc84` with clamp ±`0x1d80`. Godot: `apply_lab_0000f47c`.
- **[DONE]** `FUN_00001d56` call-site ≡ `FUN_00001d76` — see entry “FUN_00001d56 call-site…”.
- **Validation:** `test_flight_math.gd` (`_test_lab_0000f47c`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_lab_0000f47c`).

### 2026-10-15 — grounded field_0b RNG tails (11564)

- **[RECONSTRUCTED]** `0x10` soft: `FUN_00011564` → `uVar13 = ((draw&0x3f)+(e40c(uVar13)>>1 toward 0)−0x20)` scaled by `(speed>>2)/0x438` (14559–14569). `@` + player + `b856≠0` → `DAT_0001b854=1` + clear `b856` (14537–14540, no draw).
- **[RECONSTRUCTED]** `@` `field_18c`/`uVar13` via 11544-callsite — see entry “FUN_00011544 call-site alias…”.
- **Validation:** `test_flight_math.gd` / `test_sim_tick_ordering.gd` field_0b cases (`0x10 soft uVar13`, `@ sets b854`).

### 2026-10-15 — grounded field_0b type switch

- **[RECONSTRUCTED]** Grounded `field_0b` switch (14507–14596): `' '`/`@`/`0`/`P`/`\``/`p` set `bVar6` via `abs(679)!=0x2d` or status&8; `0x10` ORs status `0x1000`/`0x400` with early return; `'P'`/`0x10` soft clear player `DAT_0001b856`; `bVar6` blocks prestall. Godot: `apply_grounded_field_0b_switch`.
- **Validation:** `test_flight_math.gd` (`_test_grounded_field_0b_switch`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_grounded_field_0b_switch`).

### 2026-10-15 — grounded post-commit speed recommit

- **[RECONSTRUCTED]** Grounded `63e!=0` common prefix: `e372(local_e²+local_6²)` → `movement_62a`, `pvc←iVar23−surface`, optional `13452` when `pos_2e==0`, clamp `local_28>0x2000`, prestall `field_190=1` when `field_63f` (14497–14603).
- **Validation:** `test_flight_math.gd` (`_test_grounded_speed_recommit`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_grounded_speed_recommit`).

### 2026-10-15 — FUN_00001f22 attitude-from-velocity

- **[RECONSTRUCTED]** `fun_00001e3a` (cos-table acos), `fun_00001ebc` (af6c dump at file `0x1af8c`), `fun_00001f22` → `local_28`/`local_2a` → `pos_20`/`attitude_22` (2516–2632, 14491, 14608–14609).
- **[INFERRED]** `FUN_00002de8` void decompile treated as `abs` on `local_e`/`local_6`.
- **Validation:** `test_flight_math.gd` (`_test_fun_00001f22`).

### 2026-10-15 — FUN_0000e372 airborne speed recommit

- **[RECONSTRUCTED]** `fun_0000e372` binary-search floor sqrt (13734–13758). Airborne path: `movement_62a ← e372(local_e²+a²+6²)`; clear `field_190` when 2 (14486–14495, 14613). Skipped on hard-crash early return.
- **Validation:** `test_flight_math.gd` (`_test_fun_0000e372`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_airborne_speed_recommit`).

### 2026-10-15 — overlay trig table dump

- **[RECONSTRUCTED]** 256-short BE sin/cos tables dumped from `Pacific Conflict` at file `0x1ab8c` / `0x1ad8c` → `hellcats/tests/fixtures/trig_tables_ab6c_ad6c.json`. Ghidra `DAT_0001ab6c`/`ad6c` labels sit **0x20** before the usable bases. Loaded by `FlightMath._ensure_trig_tables`.
- **Validation:** `test_flight_math.gd` dump spot-checks + `sin(0x1000)==0x1000`.

### 2026-10-15 — FUN_000025a8 attitude matrix

- **[RECONSTRUCTED]** `fun_00001d02` matmul; `fun_000020e6`/`021a0`/`02562`/`025a8` chain; SimCore builds `attitude_matrix_9` before 028dc commit (2942–2949, 14438).
- **Validation:** `test_flight_math.gd` (`_test_fun_000025a8_identity`).

### 2026-10-15 — FUN_00013452 hard-crash unwrap

- **[RECONSTRUCTED]** `fun_00013452` → `fun_00013346(*(world+0x18/1c/20))`; empty-list returns `*(DAT_0001bda8+0x16)`; SimCore stores result to `field_0b` when hard-crash `pos_2e==0` (14456–14458, 18173–18143).
- **[DEFERRED]** Non-empty `FUN_00013346` walk (`FUN_00003c00` / `1320a` / `13070`).
- **Validation:** `test_flight_math.gd` (`_test_fun_00013452_empty_list`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_13452`).

### 2026-10-15 — FUN_0000e40c + gentle DAT_0001b856

- **[RECONSTRUCTED]** `fun_0000e40c` angle fold (13782–13793). Gentle landing gate: `abs(e40c(uVar13))>0x200` or `e40c(local_28)<-0x100` → rough; else player `dat_0001b856=1` (14464–14471). `uVar13=(sVar22+field_24)&0x3fff`; `local_28` from `pos_20` (+0x20).
- **Validation:** `test_flight_math.gd` (`_test_fun_0000e40c`, `_test_landing_pitch_followon`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_gentle_b856`).

### 2026-10-15 — landing pitch follow-on

- **[RECONSTRUCTED]** `apply_landing_pitch_followon`: hard crash `attitude_0e*0x10 < -0x168` → `status|0x400` + early return; rough/gentle clear `field_18e` + player `dat_0001b868=1` (Pacific Conflict.c:14450–14476).
- **Validation:** `test_flight_math.gd` (`_test_landing_pitch_followon`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_hard_crash`).

### 2026-10-15 — field_63e landing / airborne clear

- **[RECONSTRUCTED]** Touchdown + leave-ground on `field_63e` after position commit (Pacific Conflict.c:14446–14449, 14479–14484). Surface from `world_obj+0x1c`; `iVar23 = pos_2e + field_40_adj`.
- **Validation:** `test_flight_math.gd` (`_test_landing_touchdown_63e`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_landing_63e`).

### 2026-10-15 — FUN_000028dc + position commit (identity stub)

- **[RECONSTRUCTED]** `FlightMath.fun_000028dc_one` + `apply_position_commit_after_028dc`; SimCore writes `field_18c=0xffa5` and `param_1[2..4]` (Pacific Conflict.c:14441–14445).
- **[MVP STUB]** `SimCore.attitude_matrix_9` = identity until `FUN_000025a8` (sin/cos matrix build) is reconstructed.
- **Validation:** `test_flight_math.gd` (`_test_028dc_position_commit`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_position_commit`).

### 2026-10-15 — local_34 / stall iVar25

- **[RECONSTRUCTED]** `FlightMath.apply_ivar25_stall_step` + SimCore: `field_190==1` penalty, `(local_34<<2)/sVar12` add, stall→`field_190=2` / `dat_0001b868=2` (Pacific Conflict.c:14422–14433).
- **[DEFERRED]** `FUN_000025a8` position write to `param_1[2–4]`.
- **Validation:** `test_flight_math.gd` (`_test_ivar25_stall_step`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_stall_ivar25`).

### 2026-10-15 — post-thrust 0x63e / field_18e

- **[RECONSTRUCTED]** `FlightMath.compute_63e_thrust_delta` + `apply_field_18e_update`; SimCore after 0x636 thrust updates `field_18e` and subtracts from `movement_62a` (Pacific Conflict.c:14384–14421).
- **[DEFERRED]** `FUN_000025a8` position; stall when `iVar25<1` / `param_1+400`.
- **Validation:** `test_flight_math.gd` (`_test_field_18e_63e`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_field_18e_63e`).

### 2026-10-15 — reverse local_48 / DAT_0001b858 / attitude_22

- **[RECONSTRUCTED]** Designated smoothing stashes `last_local_46`/`last_local_42`; reverse path computes `last_reverse_local_48`, clears `dat_0001b858` for player, updates `attitude_22` (Pacific Conflict.c:14321–14342).
- **Validation:** `test_flight_math.gd` (`_test_compute_reverse_local_48`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_reverse_local_48`).

### 2026-10-15 — 0x626 reverse-flight clamps

- **[RECONSTRUCTED]** `FlightMath.apply_movement_626_reverse_clamp` + `SimCore._apply_movement_626_reverse_clamp` after 626 step, before e4a4 (Pacific Conflict.c:14305–14319). Gate: `field_63e!=0` and `direction=='-'`.
- **Validation:** `test_flight_math.gd` (`_test_movement_626_reverse_clamp`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_626_reverse_clamp`).

### 2026-10-15 — quadratic e468 + 0x636 thrust

- **[RECONSTRUCTED]** `FlightMath.apply_e468_quadratic_drag_raw` + `apply_thrust_636_step`; SimCore writes `0x636` and updates `movement_62a` (iVar25) after linear drag (Pacific Conflict.c:14362–14383; asm `0xEE50`).
- **[DEFERRED]** `0x63e` attitude block / position integration; `0x626` clamps.
- **Validation:** FlightMath unit cases + `test_sim_tick_ordering.gd` (`_test_fun_0000e792_e4a4_linear_drag` extended).

### 2026-10-15 — e4a4 + e468 linear drag in SimCore

- **[RECONSTRUCTED]** `SimCore._apply_e4a4_and_linear_drag` after `movement_626`: per-entity e468, e4a4 → `0x63a`/`0x19e`, `last_drag_ivar10` (asm `0xEDF8`).
- **Validation:** `test_sim_tick_ordering.gd` (`_test_fun_0000e792_e4a4_linear_drag`); prior FlightMath unit cases.

### 2026-10-15 — e4a4 + e468 linear drag (FlightMath)

- **[RECONSTRUCTED]** `FlightMath.fun_0000e4a4` + `apply_e468_linear_drag` (Pacific Conflict.c:13832–13872, 14356–14361; asm `0xEDF8` DIVS by e468).
- **Validation:** `test_flight_math.gd` (`_test_fun_0000e4a4_and_e468_drag`).

### 2026-10-15 — movement_626 speed step

- **[RECONSTRUCTED]** `FlightMath.apply_movement_626_step` + `SimCore._apply_movement_626_step` (Pacific Conflict.c:14248–14304). Runs for every entity past contact early-out (not designated-only). `e468` unused here.
- **[DEFERRED]** `0x626` clamps / reverse-flight; drag path that DIVs by `last_e468_out` (asm `0xEDF8`).
- **Validation:** `test_flight_math.gd` (`_test_apply_movement_626_step`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_movement_626_step`).

### 2026-10-15 — e42a from world+0x1c + e468 stash

- **[RECONSTRUCTED]** Designated-player prep: `FUN_0000e42a(*(world_obj+0x1c))` (not entity `pos_1c`); `FUN_0000e468(surface−pos_2e, e42a)` stored as `SimCore.last_e468_out` for later speed math (asm `0xEDF8`); `e570`/`local_46` still use raw e42a.
- **Validation:** `test_sim_tick_ordering.gd` (`_test_fun_0000e792_e42a_from_world_1c`).

### 2026-10-15 — FUN_00011544 deferral + local_46 literal 0x666

- **[DEFERRED]** `FUN_00011544`: Ghidra body is `1150a` warm-up epilogue (`unaff_D3`, 10k×`11564`); binary at file `0x11544` matches that. Call sites (14× `LEA 0x11544`) treat **D0** as RNG (`& 0x7f`, etc.). **Not proven** ≡ single `FUN_00011564` draw — do not alias overlay `next()` for contact `0x61a`/`0x61e`.
- **[RECONSTRUCTED]** `local_46` factor is literal **`0x666`**, not field `movement_666` (Pacific Conflict.c:14183). Fixed in `FlightMath.compute_local_46` + `SimCore._apply_movement_smoothing`.
- **Validation:** `test_flight_math.gd` (`compute_local_46`); `test_sim_tick_ordering.gd` (`_test_fun_0000e792_local_46_literal_0666`).

### 2026-10-15 — Mission 1 JSON success / start_mode wiring

- **[MVP AUTHORING DECISION]** `success.complete_all_required_objectives` drives `MissionObjectivesM1.is_mission_success()` (true → required only; false → all steps including optional).
- **[MVP AUTHORING DECISION]** `start_mode` read by `MissionController`; only `"airborne"` supported; other values warn and fall back.
- **Validation:** `godot/tests/unit/test_mission_objectives_m1.gd` (both success policies). Godot + Python regression green.

### 2026-10-15 — Mission 1 sea/island MVP solids

- **[MVP AUTHORING DECISION]** `WorldBuilderMvp.impact_reason_at` + `island_aabb()` share sea (`y <= 0.5`) and island AABB volumes with the placeholder meshes; `SeaBody` / `IslandBody` `StaticBody3D` shapes created alongside meshes.
- **[MVP APPROXIMATION]** `PlayerAircraft` and `MissionController` use that helper for impact / failure; not a port of `FUN_00005df8` / `FUN_00006fb8` / original terrain.
- **Validation:** `godot/tests/unit/test_world_collision_mvp.gd`; runner 13 scripts. Godot 13/0; `tools/qa/test_regression.py` pass.

### 2026-04-08 — Entity tick ordering convergence (FUN_000044e8 / FUN_000044a4)

- **[RECONSTRUCTED]** `SimCore.tick()` now records **`last_tick_order`**: four passes in order **DAT_0001d4a4** → **DAT_0001b5a4** → **DAT_0001d0e4** → **DAT_0001cbe4** with **`param_2`** **0, 0, 1, 1**, then **`_call_06fb8()`**, matching Pacific Conflict.c:5105–5142.
- **[RECONSTRUCTED]** **`FUN_000044a4`** second argument surfaced as **`last_pass_param_2`** / **`last_pass_id`** during **`_run_pass`** (Pacific Conflict.c:5109–5139).
- **[INFERRED]** Optional **`tick_order_trace_enabled`**: player **`movement_66e`/`672`/`66a`** snapshots before tick, after pass 2 (array 2), and after full gated section; **`rng_state_after_tick`**.
- **[MVP APPROXIMATION]** Mission-1 **playable** loop remains **`PlayerAircraft` + `FlightModelMvp`**; **`SimCore`** is the **deterministic** bridge for parity tests and future wiring (see `docs/contracts/tick_FUN_000044e8_contract.md`).

**Validation:** `godot/tests/integration/test_sim_tick_ordering.gd`. Run: `godot --headless --path . -s godot/tests/run_all.gd`.

### 2026-04-08 — Flight model convergence pass (FUN_0000e792 motion slice)

- **[RECONSTRUCTED]** `FlightModelMvp` now drives pitch/roll/yaw from **FUN_0000e792-style** smoothed accumulators **`movement_66e`**, **`movement_672`**, **`movement_66a`** using `FlightMath.add_delta_smoothed_int` / `add_delta_smoothed_s16` (Pacific Conflict.c:14182–14242; see `docs/contracts/flight_FUN_0000e792_contract.md`).
- **[INFERRED]** Axis assignment **66e→pitch**, **672→roll**, **66a→yaw** for MVP integration; full `local_46`/`local_42` airspeed/template chain not ported.
- **[MVP APPROXIMATION]** Command targets are **scaled** `[-1,1]` × `pitch_max_int` / `roll_max_int` / `yaw_max_int` (default **8192** in `aircraft_mvp.json` → `movement_smoothing`).
- **[MVP TUNING]** `roll_auto_level_gain` still applied when roll stick neutral; rates/drag unchanged unless data changes.
- **[INFERRED]** Per-tick **`FlightModelMvp.last_flight_trace`** (and `PlayerAircraft.get_flight_trace()`) exposes accumulators, norms, telemetry for QA.

**Validation:** `godot/tests/unit/test_flight_model_mvp.gd` (straight, sustained turn, climb, descend, throttle sequence, smoothing). Run: `godot --headless --path . -s godot/tests/run_all.gd`.

### 2026-04-08 — Input convergence pass (FUN_0000740a → Godot)

- **[RECONSTRUCTED]** `PlayerInputMap` now mirrors **press/hold/release** traces and **throttle step** (`+`/`-` / keypad) as **edges** → `throttle_impulse`, with **hold** throttle still on `W`/`S` / Page Up/Down (`read_input_packet`, `compute_outputs`). See `docs/contracts/input_godot_contract.md`.
- **[RECONSTRUCTED]** `FlightModelMvp` applies `controls.throttle_impulse` as an instant delta on top of axis rate (original `DAT_00024cf6` path is not fully ported).
- **[MVP APPROXIMATION]** Single gate **`player_active`** instead of `DAT_0001d858` / overlay / mission `+0x98` branches; gated presses recorded in `trace.ignored`.
- **[INFERRED]** Per-tick trace: `pressed` / `held` / `released` / `normalized` / `gated` — inspect `PlayerInputMap.last_input_trace` during play or tests.
- **[UNKNOWN]** Full Mac `param_2` enum parity; only Godot action edges are logged.

**Validation:** `godot/tests/unit/test_player_input_frame.gd` (deterministic scenarios: hold pitch, tap roll, throttle steps, gate). Run: `godot --headless --path . -s godot/tests/run_all.gd` (from project root; requires Godot 4 on `PATH`).

### FUN_000044e8 — main sim update order

- **[RECONSTRUCTED]** `FUN_000044e8` (Pacific Conflict.c:5094) is the main sim tick: it checks `*(short *)(DAT_0001b5a0 + 0xac)`; if zero, calls `FUN_00005df8()`. [Pacific Conflict.c:5101-5102]
- **[RECONSTRUCTED]** If `0 < *(short *)(DAT_0001b5a0 + 0xa8) && *(short *)(DAT_0001b5a0 + 0xa8) < 6`, it then updates four entity arrays in order: (1) `DAT_0001d4a4` count `DAT_0001c1e0`, (2) `DAT_0001b5a4` count `DAT_0001b734`, (3) `DAT_0001d0e4` count `DAT_0001c1dc`, (4) `DAT_0001cbe4` count `DAT_0001c1d8`. [Pacific Conflict.c:5104-5138]
- **[RECONSTRUCTED]** Each array is iterated with `FUN_000044a4((char *)*puVar2, param_2)`: arrays 1–2 use `param_2 = 0`, arrays 3–4 use `param_2 = 1`. [Pacific Conflict.c:5109, 5117, 5126, 5135]
- **[RECONSTRUCTED]** After all four arrays, `FUN_00006fb8()` is called. [Pacific Conflict.c:5139]
- **[INFERRED]** This order is the single source of truth for our SimCore tick; reordering would break parity with the original.

### FUN_0000740a — input handler variables

- **[RECONSTRUCTED]** `FUN_0000740a(int param_1, int param_2)` (Pacific Conflict.c:7366) is an input/key handler. `param_1` and `param_2` are key code and action (e.g. 3 = press). [Pacific Conflict.c:7366, 7452-7466]
- **[RECONSTRUCTED]** It reads/writes: `DAT_0001d858` (game state, e.g. 1, 8, 9), `DAT_0001b738` (player entity pointer), `DAT_0001b870`, `DAT_0001b87c`, `DAT_0001b884`, `DAT_0001b86e`, `DAT_0001b86c`, `DAT_0001b888`, `DAT_00020b2a`, `DAT_0001b5a0` (mission base). [Pacific Conflict.c:7391-7393, 7396-7445]
- **[RECONSTRUCTED]** Mission block at `DAT_0001b5a0`: `*(short *)(DAT_0001b5a0 + 0x98)` and `*(short *)(DAT_0001b5a0 + 0x25e)`, `(DAT_0001b5a0 + 0x2b6)`, `(DAT_0001b5a0 + 0x2be)` (callbacks). [Pacific Conflict.c:7420-7425]
- **[RECONSTRUCTED]** Player-relative reads: `*DAT_0001b738 + 7`, `*DAT_0001b738 + 4`, `*DAT_0001b738 + 0x18/0x1c/0x20`, `(int)DAT_0001b738 + 0x22`, `(int)DAT_0001b738 + 0x63e`; and `(int)piVar14 + 0x19a`, `(int)piVar14 + 0x19e`, `(int)piVar14 + 0x62a`, `(int)piVar14 + 0x32`. [Pacific Conflict.c:7398-7401, 7433-7436, 7473-7477]
- **[INFERRED]** Replay/trace input packets should map to the same (param_1, param_2) semantics used here; exact key-to-param_1 mapping is [UNKNOWN] until we capture a key table.

### FUN_0000e792 — entity (param_1) offsets

- **[RECONSTRUCTED]** `FUN_0000e792(int *param_1)` (Pacific Conflict.c:14016) updates a single entity; `param_1` is the entity pointer (int* = 4-byte units). [Pacific Conflict.c:14016, 14058]
- **[RECONSTRUCTED]** Offsets used in FUN_0000e792 (byte offsets from entity base) are documented in STRUCTS.md “Entity (FUN_0000e792)” table; each row cites the line(s) where the offset is read or written. [Pacific Conflict.c:14060-14334 and surrounding]
- **[INFERRED]** Entity layout is shared by all four arrays; FUN_000044a4 calls FUN_0000e792 (or equivalent logic), so the same offsets apply to entity_array_1..4. [UNKNOWN] whether any array uses a different struct.
- **[RECONSTRUCTED]** A minimal ported slice now exists in Godot for lines 14103-14135: if `(flags_685 & 4) != 0`, `movement_662` is perturbed by `(FUN_00011564() & 0x7f) - 0x40` and clamped to `[-0x200, 0x200]`; if `(flags_685 & 8) != 0`, `movement_666` is perturbed the same way and clamped to `[-0x140, 0x140]`; if `(status_1a1 & 1) != 0`, then `movement_662 = 0` and `movement_666 = 0xff80`. [Pacific Conflict.c:14103-14135; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** A second minimal slice now exists in Godot for lines 14137-14152: `movement_669` is set to `1` only when the `(flags_685 & 0x40)`, `status_1a3`, `status_1a1 & 0x300`, and `67d/67e` gate allows it; otherwise it is cleared and the local accumulator becomes zero. If `flags_685` is negative, the signed byte at `0x19a` is halved toward zero before being added into `status_1a0`. [Pacific Conflict.c:14137-14152; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** The threshold/decrement logic at lines 14153-14163 is now ported in Godot using a minimal external auxiliary record: if `external_template.field_1e < status_1a0`, subtract that threshold from `status_1a0`, draw one RNG value, and decrement `67e` unless `(rng & 1) != 0` and `67d != 0`, in which case decrement `67d`. [Pacific Conflict.c:14153-14163; `godot/hellcats/core/entity_template.gd`; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** `param_1[1]` also has a proven short at `+0x40`, used earlier in entity setup and in `FUN_0000e792`; this stays documented as external pointed-to state, not folded into `EntityState`. [Pacific Conflict.c:4446, 13615, 13661, 13699, 14068, 14071]
- **[RECONSTRUCTED]** Additional external-template shorts are now documented and modeled at offsets `+0x3c`, `+0x3e`, `+0x42`, `+0x44`, `+0x46`, and `+0x48`, because the next adjacent `FUN_0000e792` math block references them directly. [Pacific Conflict.c:14173, 14177, 14298, 14302-14306, 14679, 14914, 15044]
- **[RECONSTRUCTED]** Godot now exposes a reusable helper for the `+0x40` rule from `FUN_0000e792`: if `direction_char_679 == '-'`, use `external_template.field_40` directly; otherwise halve it toward zero. [Pacific Conflict.c:14067-14074; `godot/hellcats/core/sim_core.gd`]
- **[RECONSTRUCTED]** The helper trio behind the next math block is now reconstructed in `godot/hellcats/core/flight_math.gd`: `FUN_0000e42a(uint)` uses the raw overlapping table at `DAT_0001b2c0`; `FUN_0000e468(int, short)` damps the second parameter only when the first is below `0x200`; `FUN_0000e570(short, int*)` scales `external_template.field_38` by a ratio derived from `param_1`. [Pacific Conflict.c:13796-13915]
- **[INFERRED]** `compute_local_34()` is now modeled as a pure helper using the already-proven `external_template.field_3c`, `field_3e`, and the output of `FUN_0000e570`, but it is not yet wired into the live tick because the surrounding block still depends on more helper-driven state (`0x66e`, `0x672`, `0x66a`) and ownership semantics.

### FUN_0000e792 — ownership branch (DAT_0001b738 / DAT_0001b888) and 0x66e / 0x672 / 0x66a

- **[RECONSTRUCTED]** The block at Pacific Conflict.c:14179–14244 runs **only when** `(param_1 == DAT_0001b738) || (param_1 == DAT_0001b888)`. No other entity receives the updates to offsets 0x66e, 0x672, or 0x66a in this block. [Pacific Conflict.c:14179]
- **[RECONSTRUCTED]** **DAT_0001b738** is the **player entity pointer**: set when the first qualifying entity is created (e.g. `FUN_0000dff0` at 13616–13617 assigns `DAT_0001b738 = puVar2`). It is read/written across the codebase as the single “player” plane. [Pacific Conflict.c:13616–13617, 4424, 5049, 7351–7358, 7392, 7446, 14179, 14334, etc.]
- **[RECONSTRUCTED]** **DAT_0001b888** is a **second entity pointer** (e.g. target or second player): set to 0 at 6101; set from `*(param_2 + 8)` in FUN_0000ff44 at 15122 when `DAT_0001d858` is 1, 8, or 7 and other conditions. [Pacific Conflict.c:6101, 7450, 7485–7486, 15117–15122]
- **[INFERRED]** The branch is “special” because **only the entity that is the current player or the current target** gets the **movement-smoothing accumulators** at 0x66e (int), 0x672 (short), and 0x66a (int) updated in this block. All other entities skip this block entirely. **[UNKNOWN]** High-level semantics (e.g. “pitch” vs “roll” vs “yaw”) of 0x66e/0x672/0x66a; only the formulas and conditions below are proven.

**Exact conditions under which 0x66e, 0x672, and 0x66a are updated**

- **[RECONSTRUCTED]** **Guard:** Updates occur **only if** `param_1 == DAT_0001b738` **or** `param_1 == DAT_0001b888`. [Pacific Conflict.c:14179]
- **[RECONSTRUCTED]** **0x66e (int):** `local_46` = `(int)(short)(0x5e50 / (short)(sVar15 + 0xa25 >> 5)) * sVar21 * 0x666 >> 5`. Delta = `local_46 - *(int *)((int)param_1 + 0x66e)`. If `|delta| < 8` (i.e. `(delta + 7*(delta<0)) >> 3 == 0`): add delta to 0x66e; else add `(delta + 7*(delta<0)) >> 3` to 0x66e. [Pacific Conflict.c:14180–14194]
- **[RECONSTRUCTED]** **0x672 (short):** If `*(char *)((int)param_1 + 0x669) == 0` **or** `(*(ushort *)(param_1 + 0x1a1) & 0x4300) != 0`, the effective source value is 0; else it is `(short)(local_26 >> 9)`. If `*(char *)((int)param_1 + 0x685) < 0`, that value is adjusted (round toward zero then `>> 1`). Delta = that value − `*(short *)((int)param_1 + 0x672)`. Same rule: add delta or `delta>>3` (with negative rounding). [Pacific Conflict.c:14196–14222]
- **[RECONSTRUCTED]** **0x66a (int):** `local_42 = (iVar20 << 0x11) / 0x1c20` where `iVar20 = *(int *)((int)param_1 + 0x62a) >> 2`. `iVar19` = current `*(int *)((int)param_1 + 0x66a)`. `iVar10 = local_42 - local_46`; then `iVar10 = -(iVar19 - (local_46 + (iVar10 >> 1)))`. Same add delta or `delta>>3`. [Pacific Conflict.c:14180, 14165–14167, 14223–14241]
- **[RECONSTRUCTED]** **0x669 clear:** Inside the same branch, if `(*(byte *)(param_1 + 0x1a1) & 0x40) != 0` **and** `*(int *)((int)param_1 + 0x66e) == 0`, then `*(byte *)((int)param_1 + 0x669) = 0`. [Pacific Conflict.c:14241–14243]

**Safe for live port now vs unresolved**

- **Safe to implement (evidence-backed):** (1) **Branch condition:** run the 0x66e/0x672/0x66a update block only when the entity pointer equals the “player” entity or the “target” entity (Godot must pass the same two designations from its sim state). (2) **Field writes:** the exact delta rules (add full delta when `|delta| < 8`, else add `delta>>3` with negative rounding) and the formulas for `local_46`, `local_42`, and the 0x672 source from `local_26` and the 0x669/0x1a1/0x685 gates. (3) **0x669 clear:** when in this branch and status_1a1 has bit 0x40 and 0x66e is zero, set 0x669 to 0.
- **Unresolved (do not guess):** (1) Semantic names for 0x66e, 0x672, 0x66a (e.g. which axis or control surface). (2) Whether DAT_0001b888 is always “target” or sometimes a second player; Godot can mirror “two designated entities” without ascribing meaning. (3) Any other code paths that read/write these offsets outside FUN_0000e792 (see STRUCTS.md for read sites).

## Doc sync: helper trio, ownership, next live-port

- **[RECONSTRUCTED]** The **helper trio** is reconstructed in `godot/hellcats/core/flight_math.gd`: FUN_0000e42a (raw table at DAT_0001b2c0), FUN_0000e468 (damp when first param &lt; 0x200), FUN_0000e570 (scale external_template.field_38 by ratio from param_1). [Pacific Conflict.c:13796–13915] **[INFERRED]** `compute_local_34()` is modeled from proven external_template fields but not yet wired into the tick.
- **[RECONSTRUCTED]** **Ownership branch status:** Only the entity matching **DAT_0001b738** (player) or **DAT_0001b888** (second designated entity) receives writes to 0x66e, 0x672, 0x66a in the block at 14179–14244. DAT_0001b738 is set at entity creation (e.g. FUN_0000dff0); DAT_0001b888 is set to 0 at 6101 and from FUN_0000ff44 when DAT_0001d858 is 1, 8, or 7. [Pacific Conflict.c:14179, 13616–13617, 6101, 15117–15122]
- **Exact next live-port boundary [RECONSTRUCTED]:** Godot Engineer may port the **movement-smoothing block** (14179–14244) into the per-entity tick: (1) run the 0x66e/0x672/0x66a update **only when** current entity pointer equals SimCore's designated player entity or designated target entity; (2) use the proven formulas and delta rules (add full delta when |delta|&lt;8, else add delta&gt;&gt;3 with negative rounding); (3) apply the 0x669 clear when in branch and (status_1a1 &amp; 0x40) and 0x66e==0. **[UNKNOWN] Blocked:** assigning semantic names to 0x66e/0x672/0x66a; defining DAT_0001b888 beyond "second designated entity"; porting any logic that depends on unverified code paths for these offsets.

## Changelog

| Date       | Topic | Change |
|------------|--------|--------|
| (today)    | FUN_000044e8, FUN_0000740a, FUN_0000e792 | Initial log entries from Pacific Conflict.c. |
| (today)    | FUN_0000e792 ownership branch | Documented DAT_0001b738/DAT_0001b888 branch, 0x66e/0x672/0x66a update conditions, safe vs unresolved for movement-smoothing port. |
| (today)    | Doc sync | Helper trio reconstructed; ownership branch status; exact next live-port boundary (ROADMAP, STRUCTS). |

### ID00 / loader chain

- **[RECONSTRUCTED]** `ID00.bin` begins with four big-endian u32 values: `0x00000598`, `0x0000225e`, `0x00000578`, `0x00000020`. [ResEdit/CODE/ID00.bin bytes `0x0000..0x000f`; verified with `xxd`]
- **[RECONSTRUCTED]** Starting at file offset `0x0012`, `ID00.bin` contains repeated byte patterns `3f 3c <seg_id> a9 f0`, which decode as `MOVE.W #seg_id,-(SP); _LoadSeg`. [ResEdit/CODE/ID00.bin; decoded by `tools/decode_id00_loadseg.py`]
- **[RECONSTRUCTED]** The Toolbox trap `A9F0` is `LoadSeg`. [Apple Toolbox trap table, `A9F0 LoadSeg`]
- **[RECONSTRUCTED]** `ID00.bin` contains 174 `_LoadSeg` entries grouped by CODE resource id in this order: `1` (10 entries), `4` (33), `3` (3), `6` (9), `8` (3), `9` (36), `2` (68), `5` (11), `7` (1). [Decoded from `ID00.bin` by `tools/decode_id00_loadseg.py`]
- **[INFERRED]** `ID00.bin` is acting as a segment loader/dispatch table for CODE resources rather than ordinary gameplay logic.
- **[RECONSTRUCTED]** Correlating the `ID00.bin` tail words against exported `FUN_0000xxxx` symbols in `ID01.c`-`ID09.c` shows strong near-matches in several segments: `ID05` matches 11/11 within `+4` or `+6`, `ID02` matches 65/68 within `+4`, `ID07` matches 1/1 within `+4`, and `ID06` matches 6/9 within `+4`. [Generated by `tools/correlate_id00_to_functions.py`]
- **[INFERRED]** The `ID00.bin` tail word often appears to point a few bytes before the decompiler-labeled function start, most commonly `+4`, and less often `+6`.
- **[INFERRED]** `ID00.bin` therefore likely references segment-local routine entry slots rather than arbitrary data offsets, at least for segments `ID02`, `ID05`, `ID06`, and `ID07`.
- **[RECONSTRUCTED]** The trailing u16 is the segment-local **stored routine offset** (first_instruction_offset − 4, or −6 when segment has 6-byte header). Bytes at tail in ID02: UNLK (4e 5e), RTS (4e 75), then LINK at tail+4; in ID05 first routine: header at 0, LINK at 6 ⇒ tail+6. See [LOADER_CHAIN.md](LOADER_CHAIN.md) §4.2.
- **[RECONSTRUCTED]** Entrypoint handoff: JSR offset(A5) → jump table entry (MOVE.W #seg,-(SP); LoadSeg; .word tail) → LoadSeg → Segment Manager sets routine = base+(tail+4 or tail+6), JMP to routine (LINK). Ibid. §5.

## Loader-chain sync (docs vs artifact)

- **[RECONSTRUCTED]** Per [LOADER_CHAIN.md](LOADER_CHAIN.md) §10, **six** loader targets are proven by byte-level evidence (UNLK/RTS/LINK at tail or 6-byte prologue + RTS/LINK): ID02×1, ID05×1, ID06×3, ID07×1.
- **[RECONSTRUCTED]** `tools/proven_loader_targets.json` currently lists **two** targets (ID02, ID05). The four additional targets (ID06 at 0x0e10, 0x096e, 0x09d8; ID07 at 0x0190) are proven in LOADER_CHAIN but not yet in that JSON; the artifact is updated only when the maintainer re-runs the proof (LOADER_CHAIN §8).
- **[INFERRED]** Godot consumes whatever targets are present in the JSON; the headless test proves SimCore with the two targets currently in the artifact.
- **[UNKNOWN]** Still blocked by address mapping: runtime relocation, jump-table patching, and actual segment load execution are out of scope until the address model is proven further (LOADER_CHAIN §9).
- **Next milestone:** Extend `proven_loader_targets.json` to include the four remaining proven targets (ID06×3, ID07×1), or document the decision to keep the artifact minimal; then proceed to trace capture for parity validation.

### Mission 01 MVP extraction brief (flight school / pilot training)

#### Useful now

- **[RECONSTRUCTED]** `DAT_0001b738` is the player entity pointer and is used as the primary flight actor in the input path (`FUN_0000740a`) and camera/world-anchor updates (`DAT_0001d838/d834/d830` copied from player `+0x18/+0x1c/+0x20`). [Pacific Conflict.c:7392, 7437-7439, 7702-7704]
- **[RECONSTRUCTED]** Mission runtime gating needed for a deterministic training loop is already proven: mission tick uses `*(short *)(DAT_0001b5a0 + 0xac)` and `*(short *)(DAT_0001b5a0 + 0xa8)`; only when `0 < +0xa8 < 6` are all four entity arrays updated. [Pacific Conflict.c:5102-5138]
- **[RECONSTRUCTED]** Input events are key/action pairs (`FUN_0000740a(int param_1, int param_2)`), with explicit press checks (`param_2 == 3`) and release/other-action handling paths. [Pacific Conflict.c:7368, 7455, 7462-7469]
- **[RECONSTRUCTED]** Training-relevant mode/state transitions are keyed through `DAT_0001d858` and values including 1, 5, 7, 8, 9; examples: key `'c'`/`'C'` sets state 5, key `'e'`/`'E'` can enter state 7 when secondary pointer exists, key `'v'`/`'V'` returns to state 1 and recenters anchor vars. [Pacific Conflict.c:7675-7704]
- **[RECONSTRUCTED]** Proven per-frame player-control accumulators exist (`0x66e`, `0x672`, `0x66a`) and are updated only for designated player/secondary entities (`DAT_0001b738` / `DAT_0001b888`) with deterministic smoothing deltas. This is sufficient for an MVP-stable "aircraft feel" seam without full semantic naming. [Pacific Conflict.c:14179-14244]
- **[INFERRED]** HUD-minimum telemetry for MVP can safely use already-proven player fields (`+0x18/+0x1c/+0x20` world position and heading/attitude-related shorts used across input/update paths) even before exact cockpit/HUD parity is solved.

#### Ignore for MVP

- **[INFERRED]** Loader-chain deep work (`ID00` dispatch/tail-offset proof, segment entry correlation) does not unblock a playable single training slice.
- **[INFERRED]** Full DAT block reconstruction for `DAT_0001b5a0` beyond `+0xa8/+0xac/+0x98/+0x25e/+0x2b6/+0x2be` is unnecessary for Mission 01 MVP.
- **[INFERRED]** Full semantic labeling of advanced entity offsets (all `0x61a..0x685` behaviors, full weapon/system modes) is not required for initial flight school progression.
- **[INFERRED]** Exact original non-training states/campaign transitions implied by the broader `DAT_0001d858` FSM can be deferred.

#### Unknown but not blocking

- **[UNKNOWN]** Exact canonical meaning of each `DAT_0001d858` value (1..9) as player-facing named modes.
- **[UNKNOWN]** Exact original keycode-to-keyboard-layout mapping for all `param_1` values; we have direct codepoint evidence for many keys, but not a full authoritative table per platform layout.
- **[UNKNOWN]** Exact historical training mission script/scoring thresholds/objective timing text.
- **[UNKNOWN]** Exact semantic names for movement accumulators `0x66e`, `0x672`, `0x66a` (axis/control-surface identity).

### 2026-10-15 — DAT_00020ce4 attitude compose tags ($2408 / $2468 / $26e0)

Writers (MOVE.L #imm, $20CE4.L):
- `finalize_attitude_matrix_3ang` @0x2500 → **$2408**
- `compose_attitude_matrix_x` @0x25E2 → **$2468**
- `compose_attitude_matrix_6ang` @0x2660 → **$26e0**

Consumers: `invoke_tagged_attitude_compose_neg_sins4` / `_sins6` — NEG.W sin scratch, then `MOVEA.L $20CE4; JSR (A0)`.

**[PROVEN] landings (Capstone):**
| Tag | Enclosing LINK | Landing instruction | Meaning |
|---|---|---|---|
| `$2408` | `build_attitude_matrix_from_dir_roll` @0x229E | `pea.l -$24(a6)` mid matmul setup | Mid-body at first matmul; locals already filled — **not** a clean public entry |
| `$2468` | `build_attitude_matrix_3ang_alt` @0x2464 | `clr.l -(a7)` (= push angle4=0) | **Entry+4**: skips LINK; expects live A6 frame with angles at `$8/$c/$10`, out at `$14` |
| `$26e0` | `build_attitude_matrix_6ang` @0x26CC | `bsr.w $202a` | **Entry+$14**: after LINK + four angle pushes; expects those four longs already on stack + live A6 |

**[STRONG INFERENCE]** `$2468` / `$26e0` are intentional secondary entries for re-running the matching build after sin negation, reusing an existing A6/stack setup.

**[PROVEN callsite @0xA890]** Enclosing `LINK @0xA75E` still live; `build_attitude_matrix_3ang` set tag `$2408`; invoke arg=`$1d72c`. A6 is **not** `build_attitude_matrix_from_dir_roll`'s frame ⇒ literal mid-`0229e` entry cannot use the expected locals.

**[PROVEN]** `$2408 = finalize_attitude_matrix_3ang_alt (@0x2428) − 0x20`.

**[STRONG INFERENCE]** Stored tag is another +0x20 false address; intended JSR target is `finalize_attitude_matrix_3ang_alt` (refill bases from negated global sins → rewrite out matrix). Same family as `$E352`→`isqrt_floor`.

**[PROVEN callsite @0x66F6]** After `build_attitude_matrix_6ang` (tag `$26e0`); invoke_neg_sins6(`$1d744`). Tag `$26e0` is mid-wrapper at `BSR 0202a` without the four angle pushes — stack contract for a literal JSR is also unsatisfied; intended target may be `compose_attitude_matrix_6ang` `@0x2654` [HYPOTHESIS].

**Next:** annotate `FUN_0000229e`; verify A6 at @0xA890.


### 2026-10-15 — False mid-label +0x20 family (`$E352` → `isqrt_floor`)

**[PROVEN]** Real `isqrt_floor` entry is `@0xE372` (MOVEM… binary search … RTS).

**[PROVEN]** `$E352 = $E372 − 0x20`. Bytes at `$E352` sit inside the preceding routine’s `BSR.W` displacement (`@0xE350: 61 00 FF 52`); Capstone-from-`$E352` yields nonsensical `FRESTORE`, not isqrt.

**[PROVEN]** Callsite materializations of `$E352`:
- `LEA $E352.l,A2; JSR (A2)` @0x22CC (inside `build_attitude_matrix_from_dir_roll`)
- Jump-table fill `MOVE.L #$E352, $32E(A0)` @0x11C4 (with other +0x20-skewed slots `$1DB8`, etc.)

**[STRONG INFERENCE]** Same intentional-or-tooling skew as `$2DE8`→`abs_int`, `$1D56`→`sin_fixed14`, `$1DB8`→`cos_fixed14`: treat LEA/table targets as the real entry +0x20.

**[OPEN]** Why the image encodes entry−0x20 (reloc artifact vs hand-maintained vtable) remains unexplained; do not “fix” LEAs to `$E372` without binary rewrite authority.

