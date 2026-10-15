# Hellcats Over the Pacific — Decompilation Symbol Map

Maps original Ghidra identifiers to recovered names. Every entry must cite evidence.
Do not treat example names from planning docs as approved until revalidated here.

## Functions

| Original symbol | Recovered name | Confidence | Evidence |
|---|---|---|---|
| `FUN_00000020` | `overlay_patch_template_u16_pair` | STRONG INFERENCE | Binary at overlay file offset `0x20`: `LEA $1A7D2; MOVE.W 6(A7),D0; MOVE.W D0,(A0); MOVE.W D0,$4A(A0); RTS`. Call sites pass `0x195` / `0x1d5` from mission-setup branch on `*(short*)(DAT_0001b5a0+0xe)`. Cells are +0x0C fields of adjacent `0x4A` template records. **Not** a 32-bit load-base writer. |
| `FUN_00000032` | `copy_block_return_dst` | STRONG INFERENCE | Binary @ `0x32`: saves D2, calls `FUN_0001a63e(src,dst,n)` (args reordered), returns `dst` in D0. Used throughout `FUN_00000054` after `FUN_00001a48` with lengths `0x4A`/`0x1A`/`0x1C`/`0x20`. |
| `FUN_00000054` | `overlay_init_template_pointer_tables` | STRONG INFERENCE | Capstone `@0x54`–`0x332`: Block A 4×`0x4A` keyed; Block B 16 fixed `0x1A`/`0x20`→`DAT_0001b538`…`1b574`; Block C 5×`0x1C` keyed from `$1AA5E`; Block D five `0x1A`→`DAT_0001b58c`…`1b59c`. Caller `init_mission_object_tables`. |
| `FUN_000016e2` | `init_mission_object_tables` | STRONG INFERENCE | `@0x16E2`: BSR `$54` then `instantiate_object_from_desc`/`heap_alloc`; builds count×`0x18` child table; publishes `DAT_0001d6fc`, `1bdb4`/`b0`/`ac`/`a8`/`a4`, `bc28`/`34`/`38`. |
| `FUN_00004690` | `instantiate_object_from_desc` | STRONG INFERENCE | `@0x4690`: `alloc_object_from_desc`; if `desc[1]!=0` call `*(DAT_0001b524[type]+6)(obj,type,0)` → store at `obj+8`. |
| `FUN_000045ba` | `alloc_object_from_desc` | STRONG INFERENCE | `@0x45BA`: kind 2→size `0x52`, kind 3→size `0x34` via `heap_alloc_cleared`; copies descriptor fields. |
| `FUN_00001b6c` | `heap_alloc_cleared` | STRONG INFERENCE | `@0x1B6C`: `heap_alloc` then `heap_zero_payload`. |
| `FUN_00001b38` | `heap_zero_payload` | PROVEN | `@0x1B38`: derive payload size from heap header (`0xFF` large vs size-class); call `memzero`. |
| `FUN_0001a716` | `memzero` | PROVEN | `@0x1A716`: aligned CLR.B/CLR.L zero-fill of `nbytes` at `dst`. |
| `FUN_000044e8` | `run_simulation_tick` | PROVEN structure | `@0x44E8`: gate on `DAT_0001b5a0+0xac/+0xa8`; four entity-array passes via `FUN_000044a4` (path 0,0,1,1); then `FUN_00006fb8`. |

## Globals / data

| Original symbol | Recovered name | Confidence | Evidence |
|---|---|---|---|
| `DAT_0001a7d2` | `template_rec_a_field_u16` | STRONG INFERENCE | Absolute u16; written only via `FUN_00000020`; file offset `0x1a7d2`; `+0x0C` in a `0x4A` record near `s_GRAPHIC_SIMULATIONS_...` (`0x1a77c`). Initial image value `0x0151`. |
| `DAT_0001a81c` | `template_rec_b_field_u16` | STRONG INFERENCE | `DAT_0001a7d2 + 0x4A`; same store instruction `MOVE.W D0,$4A(A0)`. Initial image value `0x0151`. |
| `DAT_0001b524` | `template_ptr_table_base` | STRONG INFERENCE | `LEA $1B524,A5` in `FUN_00000054`; indexed by sign-extended u16 record keys (`MOVEA.W (A2),A0` then `(A5,A0.L*4)`). Sparse ID-keyed pointer table. |
| `FUN_000019d0` | `heap_free_coalesce` | STRONG INFERENCE | Binary `@0x19D0`–`0x1A66`: free payload to size-class list or coalesce into large-block ring; cursor `DAT_00020c60`. |
| `FUN_00001a48` | `heap_roving_cursor_store` | PROVEN body; BLOCKED as alloc | Mid-label `@0x1A48` inside `FUN_000019d0`: `MOVE.L A1,$20C60` only. Call sites (init, `@0x4ED8`, `@0xB572`) treat it as `malloc`→D0 — **unresolved ABI conflict**. |
| `FUN_00001a68` | `heap_alloc` | STRONG INFERENCE | Binary `@0x1A68`: size→pointer allocator using `DAT_00020c64[]` bins and large-block split via `DAT_00020c60`. |
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
