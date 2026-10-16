# ID09 selector discrepancies — iteration 104, 2026-10-16

Scope: `ID09.c:44-65`, `FUN_00000048`, and the adjacent omitted block.
All offsets in the byte table are **physical file offsets**, obtained by searching
`ID09.bin`; absolute machine operands do not imply locations in that file.

## Independent location and decoding

The sequence `32bc0001207802ae337cfffe0002` occurs exactly once, at file offset
`0x68`. Its writes of 1 and 0xfffe correspond to the exported initialization.
Capstone 5.0.7 in M68K 68000 big-endian mode decodes the contiguous window:

| File offset | Bytes | Decode (branch targets expressed in this file coordinate) |
|---|---|---|
| 0x068 | 32bc0001 | `move.w #$1, (a1)` |
| 0x06c | 207802ae | `movea.l $2ae.w, a0` |
| 0x070 | 337cfffe0002 | `move.w #$fffe, $2(a1)` |
| 0x076 | 0c2800ff0009 | `cmpi.b #$ff, $9(a0)` |
| 0x07c | 6742 | `beq.b $c0` |
| 0x07e | 4a280008 | `tst.b $8(a0)` |
| 0x082 | 6e20 | `bgt.b $a4` |
| 0x084 | 337cffff0002 | `move.w #$ffff, $2(a1)` |
| 0x08a | 4a78028e | `tst.w $28e.w` |
| 0x08e | 6b30 | `bmi.b $c0` |
| 0x090 | 337c00010002 | `move.w #$1, $2(a1)` |
| 0x096 | 4a780b22 | `tst.w $b22.w` |
| 0x09a | 6a24 | `bpl.b $c0` |
| 0x09c | 337c00020002 | `move.w #$2, $2(a1)` |
| 0x0a2 | 601c | `bra.b $c0` |
| 0x0a4 | 42690002 | `clr.w $2(a1)` |
| 0x0a8 | 0c2800020008 | `cmpi.b #$2, $8(a0)` |
| 0x0ae | 6e10 | `bgt.b $c0` |
| 0x0b0 | 6708 | `beq.b $ba` |
| 0x0b2 | 337c00040002 | `move.w #$4, $2(a1)` |
| 0x0b8 | 6006 | `bra.b $c0` |
| 0x0ba | 337c00030002 | `move.w #$3, $2(a1)` |
| 0x0c0 | 42690004 | `clr.w $4(a1)` |
| 0x0c4 | 0c380002012f | `cmpi.b #$2, $12f.w` |
| 0x0ca | 6e0a | `bgt.b $d6` |
| 0x0cc | 1038012f | `move.b $12f.w, d0` |
| 0x0d0 | 5240 | `addq.w #$1, d0` |
| 0x0d2 | 13400007 | `move.b d0, $7(a1)` |

## Pointer-backed selectors

**[PROVEN, bytes]** `MOVEA.L $2ae.w,A0` loads a longword pointer from absolute
machine address 0x02ae. `CMPI.B #$ff,$9(A0)` and `TST.B $8(A0)` then read bytes
relative to that pointer. The subsequent BGT tests are signed-byte comparisons.
They do not directly read the absolute addresses `DAT_216e0017` / `DAT_216e0016`.

**[PROVEN, artifact correlation]** The four bytes at physical file offset 0x2ae
are `21 6e 00 0e`. Their big-endian value is 0x216e000e; adding 8 and 9 gives
exactly 0x216e0016 and 0x216e0017, the two exported global labels.

**[STRONG INFERENCE]** Ghidra propagated a constant pointer from the imported
segment bytes at the numeric low-memory address instead of representing the
runtime pointer load. This explains both labels simultaneously. The actual
analysis/import configuration has not been inspected, so the mechanism is not
PROVEN. The runtime pointer value, pointed-to record and hardware meanings
remain UNKNOWN. This evidence is not permission to equate file offset 0x2ae
with runtime address 0x02ae.

## Omitted output-byte write

**[PROVEN, bytes]** At file 0xc4, signed-byte comparison against 2 is followed
by BGT to 0xd6. Otherwise the path loads byte at machine address 0x012f into
D0.B, increments D0.W by one, and stores D0.B to output +7. The high byte of
D0.W is not initialized here; the byte result is still the input byte plus one
modulo 256. Reads remain separate; a stable value must not be assumed without
an aliasing/runtime argument. No code is replaced with this description.

The original C warning says a block at `ram,0x000000cc` was removed as
unreachable. The independent byte match and exact warning location support
correspondence with this omitted path, but the reason it was removed is UNKNOWN.
The exported C directly proceeds from word-2 zeroing to the flag writes.

## Reconstruction decision

Retain the original identifiers, comparisons and all executable C tokens. Add
local discrepancy comments and keep the function INVESTIGATING. A future repair
must model the runtime pointer/absolute globals, omitted path and trap ABI together
with explicit types and validation; this pass does not claim whole-function
behavioral equivalence to the binary or VERIFIED status.

Validation: all table bytes checked against the protected binary; independent
analysis and QA; 32 protected hashes unchanged; C edits contain comments only.
