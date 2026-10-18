# ID09 `FUN_00000048`: reverse lookup and SysEnvirons identification —,

Scope: `ID09.c:72-79` (reverse lookup) plus a function-level identification
hypothesis. Offsets are **physical file offsets in `ID09.bin`**. Capstone 5.0.7,
M68K 68000 big-endian.

## Reverse lookup bytes [PROVEN, bytes]

| File offset | Bytes | Decode |
|---|---|---|
| 0x052 | 6006 | `bra.b $5a` (skips data island) |
| 0x054 | 03 13 0b 02 01 00 | literal table (decoded by Capstone as junk `btst`) |
| 0x0f8 | 1038021e | `move.b $21e.w, d0` |
| 0x0fc | 41faff5b | `lea.l $59(pc), a0` (unique in the file) |
| 0x100 | 323c0004 | `move.w #$4, d1` |
| 0x104 | b020 | `cmp.b -(a0), d0` |
| 0x106 | 57c9fffc | `dbeq d1, $104` |
| 0x10a | 5241 | `addq.w #$1, d1` |
| 0x10c | 3341000a | `move.w d1, $a(a1)` |

`LEA d16(PC)` is position-independent: target = 0xfe + (−0xa5) = 0x59 in the
same segment, so `DAT_00000059` is a segment-relative label. Here, Ghidra's
address coordinate coincides with the file offset for this segment (function
entry at file 0x48 = `FUN_00000048`); that coincidence is observed, not assumed.

Pre-decrement reads 0x58, 0x57, 0x56, 0x55, 0x54. DBEQ exits without
decrementing on match, so word +0x0a receives:

| KbdType byte | Result |
|---|---|
| 0x01 | 5 |
| 0x02 | 4 |
| 0x0b | 3 |
| 0x13 | 2 |
| 0x03 | 1 |
| other | 0 (D1 reaches −1, +1) |

The Ghidra C loop (`ID09.c:72-79`) is equivalent: pointer pre-decrement,
break before counter decrement, exit at −1, store counter+1.

## Function identification [STRONG INFERENCE]

Proposed name: `sysenvirons_glue_fallback`. Every observed field and global
fits the documented Inside Macintosh `SysEnvRec` and low-memory map:

| Record offset | Written from | SysEnvRec field |
|---|---|---|
| +0 word | constant 1 | environsVersion |
| +2 word | ROMBase($2ae)→ROM version bytes, ROM85($28e), HWCfgFlags($b22) | machineType (−2 XL, −1 Mac, 1 512KE, 2 Plus, 3 SE, 4 II) |
| +4 word | 0 | systemVersion |
| +7 byte | CPUFlag($12f)+1 when ≤2 (omitted Ghidra block) | processor (env68000=1…) |
| +8 byte | ROM85≥0 && HWCfgFlags bit 12 | hasFPU |
| +9 byte | ROM85 < 0x4000 | hasColorQD |
| +0xa word | KbdType($21e) table above | keyBoardType |
| +0xd byte | ABusVars($2dc)+7 when PortBUse($291)≥0 && SPConfig($1fb)&0xf==1 | atDrvrVersNum |
| +0xe word | BootDrive($210), then volume lookup via `$A260`/`$A207` | sysVRefNum |

Return word `0xea84` = −5500 = `envNotPresent`, written to the caller's result
slot before `JMP (A1)` — consistent with a Pascal-convention glue routine.
The 'ERIK' literal (`0x4552494b`) used in the terminal path is unexplained.

Limits: low-memory names and enum values come from external Apple
documentation, not from this binary. No Apple glue source or runtime trace has
been compared, so the function is not VERIFIED. machineType value meanings and
the A-line trap names (`$A260`, `$A207`) remain HYPOTHESIS.

##: entry dispatcher (file 0x20..0x46) [PROVEN bytes; trap names from docs]

| File offset | Bytes | Decode |
|---|---|---|
| 0x20 | 4a78028e | `tst.w $28e.w` (ROM85) |
| 0x24 | 6b22 | `bmi.b $48` → fallback |
| 0x26 | 303c0090 | `move.w #$90, d0` |
| 0x2a | a346 | GetOSTrapAddress |
| 0x2c | 2248 | `movea.l a0, a1` |
| 0x2e | 303c009f | `move.w #$9f, d0` |
| 0x32 | a746 | GetToolTrapAddress (_Unimplemented) |
| 0x34 | b3c8 | `cmpa.l a0, a1` |
| 0x36 | 6710 | `beq.b $48` → fallback |
| 0x38–0x3e | 225f 205f 301f 2f09 | pop return→A1, rec ptr→A0, version→D0; push return |
| 0x40 | a090 | _SysEnvirons |
| 0x42 | 3f400004 | `move.w d0, $4(a7)` (function result) |
| 0x46 | 4e75 | `rts` |

This explains why the 0x48 body exists, which justifies the rename. machineType mapping
(XL/Mac/512KE/Plus/SE/II from ROM version bytes) remains HYPOTHESIS.
