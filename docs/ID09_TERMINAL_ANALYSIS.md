# ID09 terminal block: iteration 103, 2026-10-16

Scope: original `ID09.c:84-103`, `FUN_00000048`. This records binary evidence
for the terminal block without reconstructing missing instructions into C.

## Locating the evidence

`bytes.fromhex(ID09)` equals `ID09.bin` exactly (1100 bytes). Searching that
binary for `323c003c426751c9fffc` returns exactly one physical offset: `0x13e`.
This distinctive immediate-counter/word-clear/DBRA sequence corresponds to the
exported loop. The adjacent `31780a580018` and `3ebcea84` signatures occur at
`0x14a` and `0x184`, corroborating the source global and literal. Offsets below
are positions in the binary, **not inferred runtime addresses**. Absolute operands
such as `$a58.w` identify machine-address operands, not file locations.

Capstone 5.0.7, M68K 68000 big-endian mode, decoded the contiguous window from
file offset `0x134` through `0x189`. A-line words are kept opaque; no Toolbox
name or ABI is inferred from their numeric values.

| File offset | Bytes | Decoded operation |
|---|---|---|
| 0x134 | 4a7803f6 | TST.W $3f6.w |
| 0x138 | 6d44 | BLT to window location 0x17e |
| 0x13a | 4269000e | CLR.W $e(A1) |
| 0x13e | 323c003c | MOVE.W #$3c,D1 |
| 0x142 | 4267 | CLR.W -(A7) |
| 0x144 | 51c9fffc | DBRA D1, loop at 0x142 |
| 0x148 | 204f | MOVEA.L A7,A0 |
| 0x14a | 31780a580018 | MOVE.W $a58.w,$18(A0) |
| 0x150 | 7008 | MOVEQ #8,D0 |
| 0x152 | a260 | Opaque A-line word |
| 0x154 | 6624 | BNE to 0x17a |
| 0x156 | 316800340016 | MOVE.W $34(A0),$16(A0) |
| 0x15c | a207 | Opaque A-line word |
| 0x15e | 661a | BNE to 0x17a |
| 0x160 | 2168005a0030 | MOVE.L $5a(A0),$30(A0) |
| 0x166 | 217c4552494b001c | MOVE.L #$4552494b,$1c(A0) |
| 0x16e | 7001 | MOVEQ #1,D0 |
| 0x170 | a260 | Opaque A-line word |
| 0x172 | 6606 | BNE to 0x17a |
| 0x174 | 33680016000e | MOVE.W $16(A0),$e(A1) |
| 0x17a | defc007a | ADDA.W #$7a,A7 |
| 0x17e | 2049 | MOVEA.L A1,A0 |
| 0x180 | 225f | MOVEA.L (A7)+,A1 |
| 0x182 | 5c4f | ADDQ.W #6,A7 |
| 0x184 | 3ebcea84 | MOVE.W #$ea84,(A7) |
| 0x188 | 4ed1 | JMP (A1) |

## Supported conclusions and limitations

- **[PROVEN, matched block]** The counter starts at 60 and executes 61 word
  clears before DBRA terminates: 122 bytes. The later addition of `0x7a` restores
  that allocation on the shown path. The negative-word branch bypasses it.
- **[PROVEN, matched block]** The source's final `puVar5 + 0x16` equals final
  cleared-stack pointer plus `0x18`: the last `puVar5` precedes its final -2 step.
- **[PROVEN, bytes]** The binary continues after the source truncation and has
  three opaque A-line sites, branches and an additional output write. Therefore
  `halt_baddata()` does not establish a real runtime halt.
- **[PROVEN, bytes]** The epilogue uses `JMP (A1)`, with A1 restored from stack;
  it does not independently establish Ghidra's jumptable/callback interpretation.
- **[UNKNOWN]** A-line contracts, stack entry layout, complete calling convention,
  meaning of `$ea84`, record purpose and actual runtime callers. No whole-function
  VERIFIED status and no repair of the truncated C are justified by this pass.

Validation: 32 protected SHA-256 entries unchanged; independent binary analysis
and comment-only C review. Existing expressions, globals, control flow and all
Ghidra warning/stub artifacts are retained in `ID09.decomp.c`.
