# REA Compatibility — Classic Macintosh CODE / Motorola 68000

**REA package evaluated:** `rea-agents@6.5.0` ([morluto/rea](https://github.com/morluto/rea), npm `rea-agents`)  
**Hellcats targets:** ResEdit `CODE` resources (`ID00.bin`–`ID09.bin`), overlay `Pacific Conflict`  
**Labels:** Documented | Verified | Adapter | Unsupported | Unknown

---

## 1. Summary

REA is an MCP/CLI agent toolkit for reverse engineering. Native deep analysis uses a caller-supplied **Hopper**, **Ghidra**, or **IDA** installation. For Hellcats, the relevant question is whether REA’s Ghidra provider can admit **raw Motorola 68000 big-endian CODE segments** and classic Macintosh resource data.

| Capability | Status vs Hellcats |
|------------|--------------------|
| Headless Ghidra via REA | Documented (Linux/macOS); Verified only after local Ghidra 12.1.x is present |
| Raw binary import | Documented for `x86`, `x86_64`, `arm`, `arm64`, `6502` only |
| Motorola 68000 / big-endian raw | **Unsupported** (documented exclusion of big-endian and other Ghidra variants) |
| Classic Mac resource forks / ResEdit CODE | **Unsupported** as a first-class format (Apple docs cover modern `.app`/IPA/Mach-O) |
| Existing Hellcats Ghidra C workflow | Independent of REA; remains the source of truth |

---

## 2. REA feature surface (documented)

### 2.1 MCP and CLI

| Feature | Evidence | Label |
|---------|----------|-------|
| MCP registration via `npx rea-agents setup` | [installation.md](https://github.com/morluto/rea/blob/main/docs/installation.md) | Documented |
| Cursor as supported agent | Same | Documented |
| CLI mirrors MCP (`rea inspect`, `function`, `decompile`, `xrefs`, …) | [cli.md](https://github.com/morluto/rea/blob/main/docs/cli.md) | Documented |
| Evidence objects with digests / limitations | native-investigation / cli docs | Documented |
| Setup `--dry-run` / doctor readiness | installation.md | Documented; Verified locally (see `installation.md`) |

### 2.2 Native providers

| Provider | Role | Hellcats plan |
|----------|------|---------------|
| Ghidra 12.1.x + declared JDK | Preferred free native analysis | Use if installed; prefer over Hopper |
| Hopper | Optional; setup can install with approval | **Do not install** for this evaluation |
| IDA / Kuna | Optional adapters | Out of scope |
| objdump / Rizin | Caller-supplied extras | Not a 68k Mac segment loader |

### 2.3 Raw-binary admission (critical)

From [docs/raw-binary.md](https://github.com/morluto/rea/blob/main/docs/raw-binary.md):

- Caller must supply `format=raw-binary`, `architecture`, and `entry_point`.
- Allowed `architecture` values: **`x86`, `x86_64`, `arm`, `arm64`, `6502`**.
- Languages used are **little-endian** generics (e.g. `x86:LE:32:default`, `6502:LE:16:default`).
- Explicit limitation: **“Big-endian, Thumb-only, Cortex-M, and other Ghidra processor variants are unsupported.”**

| Claim | Label |
|-------|-------|
| REA can open headerless images with caller load address | Documented (selected arches) |
| REA admits Motorola 68000 / `68000:BE:32:default` | **Unsupported** (not in architecture list; BE excluded) |
| Undocumented `m68k` / `68000` CLI spellings | Unknown until experiment; refusal must be recorded if rejected |

### 2.4 DOS / other raw lanes

REA documents DOS MZ and explicit COM via Ghidra ([ghidra-dos.md](https://github.com/morluto/rea/blob/main/docs/ghidra-dos.md)). That proves REA can specialize Ghidra loaders for legacy formats when implemented — but **no Mac CODE / A5-world profile is documented**.

### 2.5 Apple application analysis

From [apple-application-analysis.md](https://github.com/morluto/rea/blob/main/docs/apple-application-analysis.md):

- Targets: IPA, macOS `.app`, ZIP/DMG containing modern bundles.
- Projects inventory of Mach-O / frameworks / plists path conventions.
- **Not** classic Mac OS resource maps, `'CODE'` resource IDs, or ResEdit hex dumps.

| Claim | Label |
|-------|-------|
| REA inventores modern Apple bundles | Documented |
| REA parses classic resource forks / `.rsrc` MacBinary / ResEdit CODE exports | **Unsupported** (wrong format family) |
| Adapter: Python inventory over existing exports | Adapter (project tooling) |

---

## 3. Hellcats binary model (project evidence)

| Aspect | Project fact | Citation |
|--------|--------------|----------|
| Processor | Motorola 68000, big-endian | `Ghidra_import_presets.md` |
| Overlay (`Pacific Conflict`) | Raw import base 0; code from file offset `0x20` | Same; `LOADER_CHAIN.md` |
| CODE segments ID01–ID09 | Segment-local offsets; A5-relative globals (`unaff_A5`) | `ID05.c`, `LOADER_CHAIN.md` |
| ID05 entry | Header at `0x0`; first LINK at **`0x6`** (6-byte prologue) | `LOADER_CHAIN.md` §4.2 |
| ID05 RNG | `FUN_00000728`: state `*= 0x41c64e6d; += 0x3039`; 15-bit extract | `ID05.c` |
| Not a standalone executable | LoadSeg / jump table via ID00; not PE/Mach-O/ELF | `LOADER_CHAIN.md` |

A raw Macintosh CODE resource is **not** interchangeable with REA’s Mach-O or little-endian raw profiles.

---

## 4. Compatibility matrix

| Hellcats need | REA path | Compatibility |
|---------------|----------|---------------|
| Import `ID05.bin` as 68000 BE at base 0, entry 0x6 | `raw-binary` + architecture | **Unsupported** (documented) |
| Recover LCG at known offset / constants | Ghidra decompile / search-bytes | Depends on successful 68k import → blocked |
| Automate function inventory vs `ID05.c` | MCP `list_procedures` | Blocked without 68k admission |
| Classic resource fork inventory | Apple inventory tools | **Unsupported** |
| Inventory ResEdit exports + hashes | Project Python | **Adapter** (implemented under `tools/mac_resources/`) |
| Modern Electron/.NET/etc. | REA built-ins | Irrelevant to Hellcats native |

---

## 5. What would require an adapter

1. **REA Ghidra language bridge** for `68000:BE:32:default` (or Mac variant) with caller load address and optional skip of CODE header bytes — not present in 6.5.0 docs.
2. **A5 world / jump-table reconstruction** (CODE 0 + LoadSeg) — outside REA; use existing `LOADER_CHAIN` + Python decode scripts.
3. **Classic resource map parser** for intact forks — Python (or third-party Mac tools), not REA Apple projections.

---

## 6. Experimental verification status (2026-10-15)

| Claim | Result | Label |
|-------|--------|-------|
| `inspect ID05.bin --provider ghidra` | `target_unavailable` / unsupported binary format | Verified |
| `raw-binary` + `architecture=m68k\|68000\|motorola68000` | `VALIDATION_ERROR`; allowed set is `6502\|x86\|x86_64\|arm\|arm64` | Verified **Unsupported** |
| `raw-binary` + admitted LE arch | Reaches provider; `provider_unavailable` without Ghidra | Verified |
| Repeatability of m68k refusal | Identical errors on two runs | Verified |
| `inspect-artifact` on `Hellcats.rsrc` | unsupported binary format | Verified |
| LCG bytes `41c64e6d` / `3039` in ID05.bin | Offsets `0x730` / `0x738` | Verified (independent of REA) |

See [`id05-experiment.md`](id05-experiment.md) and [`installation.md`](installation.md).
