# Hellcats Over the Pacific — C-to-C Decompilation Progress

Persistent checkpoint for the recurring 5-minute semantic reconstruction loop.

**Last iteration:** 9  
**Last iteration date:** 2026-10-15  
**Loop:** local monitored shell `AGENT_LOOP_TICK_hellcats_decomp` every 300s (PID tracked in agent terminal)

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
| ID08.c | 4 | 4 | 0 | 0 | 0 | 0 | 0 |
| ID09.c | 4 | 4 | 0 | 0 | 0 | 0 | 0 |
| Pacific Conflict.c | 441 | 427 | 0 | 0 | 12 | 0 | 1 |
| **TOTAL** | **731** | **717** | **0** | **0** | **12** | **0** | **1** |

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
| `ID08.c` | `ID08.decomp.c` | seeded (copy) |
| `ID09.c` | `ID09.decomp.c` | seeded (copy) |
| `Pacific Conflict.c` | `Pacific Conflict.decomp.c` | seeded + iter 1–9 edits |

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
| `FUN_000044e8` | `run_simulation_tick` | Pacific Conflict | RENAMED | PROVEN structure | `:5096` / `@0x44E8` | `Pacific Conflict.decomp.c` | `FUN_000044a4`, `05df8`, `06fb8`; mission `+0xa8/+0xac` | Array semantics; external caller | 9 | Capstone matches contract four-pass order |

All other inventoried functions: **NOT_STARTED** (see inventory JSON).

## Iteration log

### Iteration 1 — 2026-10-15

- Created all ten `*.decomp.c` outputs by copying immutable `.c` sources.
- Recorded SHA-256 of 32 protected originals.
- Inventoried **731** Ghidra `FUN_*` / related definitions across ten C files.
- Reconstructed `FUN_00000020` → `overlay_patch_template_u16_pair`.
- Corrected prior “loader base” framing: call sites pass `0x195` / `0x1d5`; binary is two `MOVE.W` stores 0x4A apart.

**Next iteration target:** `FUN_000044a4` — per-entity tick dispatch (callee of `run_simulation_tick`).

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

## Priority queue (suggested)

1. `FUN_000044a4` / `FUN_0000435a` — per-entity dispatch chain  
2. `FUN_00006fb8` / `FUN_00005df8` — tick hooks  
3. Revisit `$1A48` JSR ABI (BLOCKED)  
4. `ID08.c` / `FUN_00000006` — segment/resource loader  
5. `FUN_0000e792` — entity update  
