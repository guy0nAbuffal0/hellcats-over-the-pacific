# ID05 disassembly comparison

Target: `sources/ResEdit/CODE/ID05.bin`

- Size: 3064 B
- SHA-256: `1c7a3a39153e01b156a17f1e312aa948d0ed906022aa6a1ebd834b9317e2d5f0`
- Skip header `0x0..0x5` (jump table / stub); first code at **0x6** (`LINK`).
- LCG immediates: multiply `0x41c64e6d` at file offset **0x730**; add `0x3039` nearby (**0x738**).
- Ghidra symbol: `FUN_00000728` (entry `0x728`).

JSON: `artifacts/reverse-engineering/id05/disassembly-comparison.json`.

## Landmarks

| Field | Value |
|-------|-------|
| bytes `0..5` | `0510000b4e75` |
| `RTS` @ 0x4 | True |
| `LINK` @ 0x6 | True |
| LCG mul offset | `0x730` |
| LCG add near | `0x738` |

## Region `0x6..0x80` (sample)

| Offset | Bytes | Capstone | m68k-disasm | Agree |
|--------|-------|----------|-------------|-------|
| `0x6` | `4e56fff4` | `link.w a6, #$fff4` | `linkw %a6,#0xfffffff4` | strong-inference (Ghidra FUN_00000006) |
| `0xa` | `42a7` | `clr.l -(a7)` | `clrl %a7@-` | engines-present |
| `0xc` | `2f2e0008` | `move.l $8(a6), -(a7)` | `movel %a6@(8:w),%a7@-` | engines-present |
| `0x10` | `3f2e000c` | `move.w $c(a6), -(a7)` | `movew %a6@(12:w),%a7@-` | engines-present |
| `0x14` | `a9a0` | `dc.w $a9a0` | `.short 0xa9a0` | engines-present |
| `0x16` | `205f` | `movea.l (a7)+, a0` | `moveal %a7@+,%a0` | engines-present |
| `0x18` | `2d48fffc` | `move.l a0, -$4(a6)` | `movel %a0,%a6@(-4:w)` | engines-present |
| `0x1c` | `2008` | `move.l a0, d0` | `movel %a0,%d0` | engines-present |

## Region `0x720..0x760` (RNG)

| Offset | Bytes | Capstone | m68k-disasm | Ghidra note | Agreement |
|--------|-------|----------|-------------|-------------|-----------|
| `0x720` | `fd8e` | `dc.w $fd8e` | `.short 0xfd8e` | — | engines-present |
| `0x722` | `a873` | `dc.w $a873` | `.short 0xa873` | — | engines-present |
| `0x724` | `4e5e` | `unlk a6` | `unlk %a6` | — | engines-present |
| `0x726` | `4e75` | `rts` | `rts` | — | engines-present |
| `0x728` | `202dff94` | `move.l -$6c(a5), d0` | `movel %a5@(-108:w),%d0` | inside FUN_00000728 (ID05.c) | strong-inference |
| `0x72c` | `4c3c` | `dc.w $4c3c` | `.short 0x4c3c` | inside FUN_00000728 (ID05.c) | strong-inference |
| `0x72e` | `000041c6` | `ori.b #$c6, d0` | `.short 0x0000, 0x41c6` | inside FUN_00000728 (ID05.c) | strong-inference |
| `0x732` | `4e6d` | `move usp, a5` | `movel %usp,%a5` | inside FUN_00000728 (ID05.c) | strong-inference |
| `0x734` | `068000003039` | `addi.l #$3039, d0` | `addil #12345,%d0` | inside FUN_00000728 (ID05.c) | strong-inference |
| `0x73a` | `2b40ff94` | `move.l d0, -$6c(a5)` | `movel %d0,%a5@(-108:w)` | inside FUN_00000728 (ID05.c) | strong-inference |
| `0x73e` | `e9ed` | `dc.w $e9ed` | `.short 0xe9ed` | inside FUN_00000728 (ID05.c) | strong-inference |

## Uncertainty

- Capstone and m68k-disasm use different syntax (`move.l -$6c(a5), d0` vs `movel %a5@(-108:w),%d0`) but agree on semantics at `0x728+`.
- Bytes before `0x728` in the window may be prior function epilogue / padding (`dc.w` / `.short`).
- Whole-file disassembly as pure code is invalid; header `0x0..0x5` is not the RNG body.
- Ghidra listing text in the table is landmark-aligned from `ID05.c` / headless `functions.json`, not a line-by-line listing export.
