# Recommendations — Ranked by Value / Cost / Risk

## Verdict reminder

**C — Do not adopt REA yet** for Hellcats native CODE / classic Mac resource work.  
Evidence: [`id05-experiment.md`](id05-experiment.md), [`compatibility.md`](compatibility.md).

---

## Ranked next actions

### 1. Continue existing Ghidra + Capstone + `.decomp.c` loop (high value / low cost / low risk)

- Advance ID05 RNG / helpers in `ID05.decomp.c` from existing `ID05.c` + bytes at `0x730`.  
- Keep protected checksum verification each iteration.  
- No REA dependency.

### 2. Expand Python resource tooling when an intact fork appears (high value / medium cost / low risk)

- Obtain real resource fork / disk image / verified MacBinary.  
- Extend `tools/mac_resources/parse_rsrc.py` once header validation passes.  
- Inventory PICT/snd/STR#/etc. with hashes — **only from real map entries**.

### 3. Optional: restore Ghidra 12.1.x for headless scripts **outside** REA (medium value / medium cost / low risk)

- Recreate install; reopen Hellcats project under `/Users/math/Sites/tests/ghidra`.  
- Automate export/compare with project Java scripts if needed.  
- Still prefer not to funnel 68k through REA until architecture support exists.

### 4. Watch REA releases for 68000 BE raw-binary (medium value / low cost / low risk)

- Re-run `artifacts/rea/id05/run_matrix.sh` when docs list `m68k` or BE languages.  
- Only then consider Cursor MCP registration (`setup --dry-run` → approve).

### 5. Do **not** install Hopper for this project (low value / high cost / medium risk)

- Commercial dependency; not required; evaluation policy excludes it.

### 6. Do **not** force wrong-endian raw imports “to get any output” (negative value / high risk)

- Analyzing ID05 as x86/arm/6502 would produce misleading Evidence.

### 7. Optional Node hygiene (low value / low cost)

- Keep disposable Node 24 under `artifacts/` for REA CLI experiments, or install `node@24` via Homebrew when Cellar locks clear.  
- Default PATH may remain Node 25 for other work.

---

## Explicit non-goals (now)

- Full corpus `.decomp.c` rewrite via REA.  
- Claiming automated Macintosh resource extraction complete.  
- MCP integration as a deliverable of this evaluation.
