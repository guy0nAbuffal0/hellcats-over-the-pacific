# REA Evaluation — Hellcats Over the Pacific

**Verdict: C — Do not adopt REA yet**

REA (`rea-agents@6.5.0`) does not admit Motorola 68000 / big-endian raw CODE segments. The ID05 experiment failed the usefulness criteria. Classic Mac resource inspection via REA also rejected our `.rsrc`. Continue the existing Ghidra C → `.decomp.c` → Godot workflow; use new Python inventory tooling for corpus digests.

---

## Documents

| File | Contents |
|------|----------|
| [compatibility.md](compatibility.md) | REA vs classic Mac CODE / 68000 |
| [installation.md](installation.md) | Local setup, commands, blockers |
| [id05-experiment.md](id05-experiment.md) | ID05.bin import matrix + comparison |
| [resource-extraction.md](resource-extraction.md) | Inventory, REA probes, missing inputs |
| [workflow.md](workflow.md) | Impact on `.decomp.c` pipeline |
| [recommendations.md](recommendations.md) | Ranked next actions |

Disposable outputs: `artifacts/rea/` (gitignored).  
Reusable scripts: [`tools/mac_resources/`](../../../tools/mac_resources/).

---

## Final report

### 1. REA version and official source

- **Version:** `6.5.0`  
- **Source:** [https://github.com/morluto/rea](https://github.com/morluto/rea) / npm package `rea-agents`

### 2. Installation status

- CLI usable via disposable **Node 24.11.0** tarball (`artifacts/rea/node24/`).  
- Default host Node **25.9.0** rejected by REA engines for setup/doctor health.  
- `setup --dry-run` only; **Cursor MCP not registered**.  
- Hopper **not** installed.  
- Ghidra **12.1.x not installed** (historical 12.0.1 prefs/project only).

### 3. Ghidra integration status

- Doctor: `ghidra` → `missing_analysis_engine` (`GHIDRA_INSTALL_DIR` unset).  
- Admitted raw-binary LE targets → `provider_unavailable`.  
- **Even with Ghidra**, 68000 cannot be selected (CLI `VALIDATION_ERROR`).

### 4. ID05 experiment outcome

- Default inspect: unsupported format.  
- `architecture` `m68k` / `68000` / `motorola68000`: **rejected** (allowed: `6502|x86|x86_64|arm|arm64`).  
- No assembly/pseudocode recovered via REA.  
- LCG constants confirmed in binary at `0x730`/`0x738` independently; match `ID05.c` `FUN_00000728`.  
- **Success criteria: not met.**

### 5. Macintosh resource extraction findings

- Python inventory: **69** entries, deterministic.  
- `Hellcats.rsrc`: classic map parse **failed** (`map_offset beyond file end`).  
- Empty `Hellcats` / `Hellcats.bin` stubs.  
- CODE + overlay + manuals/screenshots present.  
- REA `inspect-artifact` on `.rsrc`: unsupported format.  
- Intact classic resource fork **missing** if non-CODE resources are required.

### 6. Successfully generated artifacts

- `docs/research/rea/*` (this set)  
- `tools/mac_resources/{inventory.py,parse_rsrc.py,README.md}`  
- `artifacts/rea/` (doctor, dry-run, id05 matrix, inventories, checksums, QA log)  
- `.gitignore` entry for `/artifacts/`

### 7. Unresolved compatibility issues

- No REA 68000 BE raw profile.  
- No classic Mac resource-fork support in REA Apple tools.  
- No local Ghidra 12.1.x for REA provider tests on LE targets (secondary).  
- `Hellcats.rsrc` format identity unknown / invalid as classic fork.

### 8. Impact on `.decomp.c` workflow

- **No change recommended.** REA does not accelerate CODE semantic reconstruction today.  
- No ID05 `.decomp.c` PoC edits.

### 9. Recommended next experiment

1. Semantic reconstruction of ID05 RNG helpers from existing `ID05.c` + Capstone/bytes.  
2. When/if REA documents `m68k` raw-binary, re-run `artifacts/rea/id05/run_matrix.sh`.  
3. If non-CODE resources are needed, acquire an intact resource fork and extend `parse_rsrc.py`.

### 10. Exact files added or changed

**Added**

- `docs/research/rea/README.md`  
- `docs/research/rea/compatibility.md`  
- `docs/research/rea/installation.md`  
- `docs/research/rea/id05-experiment.md`  
- `docs/research/rea/resource-extraction.md`  
- `docs/research/rea/workflow.md`  
- `docs/research/rea/recommendations.md`  
- `tools/mac_resources/inventory.py`  
- `tools/mac_resources/parse_rsrc.py`  
- `tools/mac_resources/README.md`  
- `artifacts/rea/**` (gitignored disposable outputs)

**Changed**

- `.gitignore` — ignore `/artifacts/`

**Unchanged (verified)**

- All protected CODE binaries / Ghidra `.c` / hex dumps (SHA-256 OK before and after)  
- All `*.decomp.c` files  
- No git commit / push

---

## QA

- Protected checksums: **32/32 OK** after experiment.  
- `python3 tools/qa/test_regression.py`: **All passed**.
