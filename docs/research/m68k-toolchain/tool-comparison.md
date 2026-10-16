# Tool comparison

Recorded 2026-10-15. External clones live under `/Users/math/Sites/tests` (not inside the game repo). Capstone is the pip binding only (no engine clone).

## Matrix

| Tool | Remote | HEAD SHA | License | Build / install | Hellcats result |
|------|--------|----------|---------|-----------------|-----------------|
| **resource_dasm** | https://github.com/fuzziqersoftware/resource_dasm.git | `8930baa5ae99bf41e8d70b2d21ae8423dd38e429` | MIT | Needs **phosg**; binary in `_local_prefix/bin/resource_dasm` | Opens app **resource fork** extracted from HFS; dumps CODE 0–9. Does **not** open raw `.dsk` as a fork. |
| **rsrcdump** | https://github.com/jorio/rsrcdump.git | `a7933f3731ed85921a322036c9338b20f33de7b4` | MIT | `pip install -e` locally | Lists resources from Hellcats app `.rsrc` fork bytes. |
| **python-rsrcfork** | https://github.com/dgelessus/python-rsrcfork.git | `d2bbab1f5dd8670baa1ea5a31a1754b824743493` | MIT | pip editable | Parses classic forks; used for inventory cross-check. |
| **m68k-disasm** | https://github.com/Oxore/m68k-disasm.git | `bb6d83981bbb53de352061b793c8215e45af895a` | Unlicense | `make` → `/Users/math/Sites/tests/m68k-disasm/m68k-disasm` | Disassembles ID05 windows; MIT-style syntax differs from Capstone but agrees on opcodes at RNG. |
| **Capstone (pip)** | PyPI `capstone` | **5.0.7** | Capstone license | `import capstone` + `CS_ARCH_M68K` BE | Primary scripted disassembler for ID05 regions. |
| **Ghidra** | NSA public zip **12.1.4** | N/A (binary dist) | Apache-2.0 (Ghidra) | Extract → `/Users/math/Sites/tests/ghidra_12.1.x`; needs **JDK 21** | Headless 68000 BE import + function list OK. **No `os/mac_arm_64/decompile`** in public zip (linux/win only). |
| **machfs** (pip) | PyPI | (host install) | — | Required by `extract.py` | Reads classic HFS floppy images (`Hellcats_*.dsk`). |

Clone metadata also in `artifacts/reverse-engineering/tool-clones.txt`.

## Strengths / limits (Hellcats-specific)

| Tool | Strength | Limitation |
|------|----------|------------|
| resource_dasm | Rich typed dumps once you have a fork | Cannot mount `.dsk`; needs phosg |
| rsrcdump | Simple CLI listing | Same: needs extracted fork bytes |
| python-rsrcfork | Programmable inventory | Same input constraint |
| Capstone | Stable Python API, BE m68k | No decompiler; data vs code not automatic |
| m68k-disasm | Independent second opinion | Output dialect differs; data regions → `.short` |
| Ghidra headless | Function discovery at 0x6 / `FUN_00000728` | macOS ARM decompiler binary missing from public package |
| REA 6.5.0 | (evaluated earlier) | **No 68000** — do not re-run for CODE |

## Recommendation

1. **Resources:** `machfs` → extract forks → `resource_dasm` / `rsrcdump` / `python-rsrcfork`.  
2. **CODE inspect:** Capstone scripts + optional m68k-disasm cross-check.  
3. **Structure:** Ghidra headless for function lists; keep existing protected `.c` as semantic source of truth until macOS decompiler is available.
