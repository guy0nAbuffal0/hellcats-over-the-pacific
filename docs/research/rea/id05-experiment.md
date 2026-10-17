# ID05 Controlled Experiment — REA vs Existing Ghidra C

**Target:** `sources/ResEdit/CODE/ID05.bin`
**REA:** `rea-agents@6.5.0` via Node 24.11.0 (disposable tarball)  
**Provider requested:** Ghidra  
**Original binary:** **not modified**

---

## 1. Target facts (Verified)

| Property | Value |
|----------|-------|
| Size | 3064 bytes |
| SHA-256 | `1c7a3a39153e01b156a17f1e312aa948d0ed906022aa6a1ebd834b9317e2d5f0` |
| Matches protected checksums | Yes |
| First 16 bytes | `05 10 00 0b 4e 75 4e 56 ff f4 42 a7 2f 2e 00 08` |
| Interpretation | Segment header / count, then `RTS` at 0x4, `LINK` at **0x6** ([LOADER_CHAIN.md](../../LOADER_CHAIN.md) §4.2) |
| Known RNG | `FUN_00000728` in `ID05.c`: `state = state * 0x41c64e6d + 0x3039` |
| LCG constant in binary | Mult `41 c6 4e 6d` at file offset **`0x730`**; addend `30 39` at **`0x738`** (byte search) |

Header dump saved: `artifacts/rea/id05/header-xxd.txt`.

---

## 2. Experiment matrix

Script: `artifacts/rea/id05/run_matrix.sh`  
Log: `artifacts/rea/id05/matrix.log`  
JSON per case: `artifacts/rea/id05/*.json`

| Case | Command essence | Exit | Result code | Message (abbrev.) |
|------|-----------------|------|-------------|-------------------|
| 01 default | `inspect ID05.bin --provider ghidra` | 1 | `target_unavailable` | unsupported binary format |
| 02 raw x86/x86_64/arm/arm64/6502 @ 0x0 | `raw-binary` + arch + entry | 1 | `provider_unavailable` | Ghidra not configured |
| 02 raw arm/arm64 @ 0x6 | same | 1 | `invalid_request` | entry must be 4-byte aligned |
| 02 raw others @ 0x6 | same | 1 | `provider_unavailable` | Ghidra not configured |
| 03 `m68k` / `68000` / `motorola68000` @ 0x6 | raw-binary | 1 | `VALIDATION_ERROR` | architecture must be one of `6502\|x86\|x86_64\|arm\|arm64` |
| 04 repeat m68k a/b | same | 1 | `VALIDATION_ERROR` | identical refusal (repeatable) |

### Verified conclusions

1. **REA does not admit Motorola 68000** as a `raw-binary` architecture (CLI schema validation).  
2. Without format override, ID05.bin is **unsupported binary format**.  
3. Admitted little-endian architectures reach the Ghidra provider gate and fail with **`provider_unavailable`** on this host (no `GHIDRA_INSTALL_DIR`). Even with Ghidra, those architectures would be the **wrong CPU/endianness** for Hellcats CODE.  
4. Refusal of `m68k` is **repeatable** (identical `VALIDATION_ERROR`).

---

## 3. Comparison to existing Ghidra C

Existing protected export [`ID05.c`](../../../sources/ResEdit/CODE/ID05.c):

```c
uint FUN_00000728(void)
{
  int unaff_A5;
  *(int *)(unaff_A5 + -0x6c) = *(int *)(unaff_A5 + -0x6c) * 0x41c64e6d + 0x3039;
  return (uint)(*(int *)(unaff_A5 + -0x6c) << 1) >> 0x11;
}
```

| Check | REA result | Existing workflow |
|-------|------------|-------------------|
| Open as 68000 BE | Failed (no architecture) | Manual Ghidra raw import (historical project) |
| Recover `FUN_00000728` pseudocode | Not obtained | Present in `ID05.c` |
| Locate LCG constants | Not via REA | Present in C; confirmed in `.bin` at 0x730/0x738 |
| A5 global `-0x6c` | Not obtained | Present in C |
| Automation vs GUI | No win for this target | Continue Capstone + protected C |

**Success criteria from evaluation brief — not met.**

---

## 4. What was not claimed

- Successful Ghidra-backed decompilation of ID05 through REA.  
- Binary equivalence between any REA output and `ID05.c`.  
- That installing Ghidra alone would enable 68000 analysis in REA 6.5.0.

---

## 5. Semantic PoC

**Not performed.** Plan allowed a small `.decomp.c` PoC only if ID05 REA analysis succeeded. It did not. `ID05.decomp.c` left unchanged (still matches protected `ID05.c` content as previously seeded).
