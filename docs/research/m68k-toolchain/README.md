# Hellcats m68k Reverse-Engineering Toolchain

Reusable tooling for classic Macintosh / Motorola 68000 reverse engineering of *Hellcats Over the Pacific*, kept outside protected CODE exports.

**Status (2026-10-15):** resource extraction from HFS `.dsk` works; Capstone + m68k-disasm + headless Ghidra inventory on `ID05.bin` work; portable C ID05 RNG PoC compiles and passes vectors. Public Ghidra zip lacks a macOS ARM decompiler binary — function export works; decompile export is blocked until a native `decompile` is built or obtained.

---

## Documents

| File | Contents |
|------|----------|
| [tool-comparison.md](tool-comparison.md) | Clones, licenses, SHAs, experiment outcomes |
| [macintosh-resources.md](macintosh-resources.md) | `Hellcats.rsrc` classification; `.dsk` extraction |
| [disassembly.md](disassembly.md) | ID05 Capstone / m68k-disasm / Ghidra comparison |
| [ghidra-automation.md](ghidra-automation.md) | Ghidra 12.1.x install, headless scripts, decompiler blocker |
| [semantic-reconstruction.md](semantic-reconstruction.md) | Confidence tiers; `inventory_functions.py` workflow |
| [recompilation.md](recompilation.md) | Portable `id05_rng` C PoC (behavioral equivalence only) |
| [roadmap.md](roadmap.md) | Prioritized next engineering steps |

Disposable outputs: `artifacts/reverse-engineering/` (under gitignored `/artifacts/`).

---

## Quick map

| Need | Location |
|------|----------|
| HFS extract / verify | `tools/mac_resources/extract.py`, `verify.py` |
| FUN_* inventory | `tools/decomp/inventory_functions.py` |
| C RNG PoC | `tools/recompilation/id05_rng/` |
| External clones | `/Users/math/Sites/tests/{resource_dasm,rsrcdump,python-rsrcfork,m68k-disasm}` |
| Ghidra binary | `/Users/math/Sites/tests/ghidra_12.1.x` |

## Equivalence claims (do not overstate)

| Tier | Meaning |
|------|---------|
| **Byte match** | Same SHA-256 (e.g. disk CODE 5 ≡ ResEdit `ID05.bin`) |
| **Behavioral (tested vectors)** | C / Godot RNG match known seeds/outputs |
| **Strong inference** | Capstone/Ghidra agree on landmarks (LINK@0x6, LCG@0x730/0x738) |
| **Not claimed** | Binary-equivalent recompilation; full Toolbox linkage; gameplay fidelity |

## QA

```bash
python3 tools/qa/test_regression.py          # core + optional Capstone/Ghidra/C
bash tools/qa/test_id05_rng_c.sh             # C harness alone
(cd sources/ResEdit/CODE && \
  shasum -a 256 -c ../../../docs/DECOMPILATION_PROTECTED_CHECKSUMS.sha256)
```

Protected sources and existing `.decomp.c` files were not modified in this pass.
