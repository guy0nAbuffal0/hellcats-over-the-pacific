# REA vs Existing Ghidra → `.decomp.c` → Godot Workflow

## 1. Current Hellcats pipeline (keep)

```text
Macintosh CODE / overlay
  → ResEdit hex + hex2bin.py → ID*.bin
  → Ghidra 68000 BE (manual / historical project)
  → protected ID*.c / Pacific Conflict.c
  → editable *.decomp.c + contracts / NOTES (confidence tags)
  → Godot (SimCore, FlightMath, tests)
```

Sources of truth: [`TECHNICAL_OVERVIEW.md`](../../TECHNICAL_OVERVIEW.md), [`DECOMPILATION_PROGRESS.md`](../../DECOMPILATION_PROGRESS.md), [`LOADER_CHAIN.md`](../../LOADER_CHAIN.md).

Protected files must keep SHA-256 identity ([`DECOMPILATION_PROTECTED_CHECKSUMS.sha256`](../../DECOMPILATION_PROTECTED_CHECKSUMS.sha256)).

---

## 2. Where REA could help (in principle)

| Capability | REA surface | Hellcats applicability after ID05 experiment |
|------------|-------------|-----------------------------------------------|
| Programmatic function inventory | `list_procedures` / CLI `analyze` | **Blocked** — no 68000 admission |
| Preserve Ghidra identifiers | Provider session | Blocked |
| Call graphs / xrefs | `xrefs`, `trace` | Blocked for CODE |
| Global / data refs | native tools | Blocked |
| Suggested names + Evidence comments | annotate APIs | Only if import works; never treat as historical names |
| Structured Evidence export | `--json` | Works for error Evidence; useful for audit logs |
| Classic Mac resource extract | Apple / inspect-artifact | **Unsupported** for our `.rsrc` / CODE |
| MCP agent loop | setup + Cursor | Not registered this eval; would not fix CPU gap |

---

## 3. Recommendation for `.decomp.c` iterations

**Do not route CODE segments through REA 6.5.0.**

Continue:

1. Work from protected `ID*.c` / overlay C.  
2. Validate with Capstone / byte proof on `.bin` (as already done for LCG at `0x730`).  
3. Edit only `*.decomp.c` with PROVEN / STRONG INFERENCE / HYPOTHESIS / UNKNOWN tags.  
4. Use `tools/mac_resources/inventory.py` for corpus digests.  
5. Optionally later: **headless Ghidra scripts outside REA** (Java/`analyzeHeadless`) if GUI friction is the problem — that path already knows 68000 BE.

If REA later adds `architecture: m68k` (or BE 68000) raw-binary support, re-run the ID05 matrix and reconsider MCP registration for automation of dossiers/xrefs **after** load-image verification against known RNG bytes.

---

## 4. ID05 semantic PoC

**Skipped.** Experiment did not recover instructions or pseudocode. No edits to `ID05.decomp.c`.

---

## 5. Confidence discipline (unchanged)

- Never report inferred REA/Ghidra renames as original source names.  
- Never claim binary equivalence because decompiled C “looks similar.”  
- Prefer contracts under `docs/contracts/` for Godot integration gates.
