# REA Installation — Local Hellcats Host

**Date:** 2026-10-15  
**Official source:** [morluto/rea](https://github.com/morluto/rea) / npm `rea-agents@6.5.0`  
**Policy this evaluation:** CLI-only; **no** Cursor MCP write; **no** Hopper install.

---

## 1. Prerequisites observed

| Component | Before | After / action |
|-----------|--------|----------------|
| Node (default PATH) | v25.9.0 (Homebrew) | **Unsupported** by REA engines |
| Node for REA | — | Official tarball **v24.11.0** darwin-arm64 under `artifacts/rea/node24/` (disposable) |
| npm / npx | 11.12.1 | Used via Node 24 tarball `bin/` |
| Java | OpenJDK 17.0.18 Homebrew | Present; `JAVA_HOME` unset; Apple `java_home` does not see Homebrew JDK |
| Ghidra install | **Missing** (`ghidraRun` / `analyzeHeadless` not found) | **Not installed** this evaluation |
| Ghidra leftovers | `/Users/math/Library/ghidra/ghidra_12.0.1_PUBLIC/` prefs; project `/Users/math/Sites/tests/ghidra/Hellcats` | Historical only |
| Hopper | Absent | Not installed |
| Cursor MCP | `~/.cursor/mcp.json` → `{"mcpServers":{}}` | Unchanged |

REA engines (package metadata): `^22.19.0 \|\| ^24.11.0 \|\| >=26.0.0`.

Homebrew `brew install node@24` was attempted but blocked by a Cellar lock on `openssl@3` (processes holding dylibs). The official Node binary tarball satisfies REA without changing the default system Node.

---

## 2. Exact commands executed

```bash
# Baseline integrity
# (recorded → artifacts/rea/checksums-before.txt)

# Package identity (works even on Node 25 for --version)
npx -y rea-agents@6.5.0 --version   # → 6.5.0

# Doctor / dry-run under Node 25 (default PATH)
npx -y rea-agents@6.5.0 doctor --json
# → healthy:false; node detail 25.9.0; ghidra missing

npx -y rea-agents@6.5.0 setup --client cursor --skill=false --dry-run --json
# → status: needs_human; remediation: install Node 22.19+/24.11+/26+
# → plannedActions: []  (no files written)

# Node 24 tarball (disposable)
# https://nodejs.org/dist/v24.11.0/node-v24.11.0-darwin-arm64.tar.gz
# extracted under artifacts/rea/node24/

export PATH="$PWD/artifacts/rea/node24/node-v24.11.0-darwin-arm64/bin:$PATH"
npx -y rea-agents@6.5.0 doctor --json
# → node ok (24.11.0); ghidra still missing; healthy:false
```

Artifacts: `artifacts/rea/doctor.json`, `doctor-node24.json`, `setup-dry-run.json`.

---

## 3. What was **not** done

| Step | Reason |
|------|--------|
| `rea setup` apply (Cursor MCP) | CLI-only policy; dry-run only |
| Hopper install | Explicitly out of scope |
| Ghidra 12.1.x download/extract | Large install; ID05 matrix already rejects `m68k`/`68000` at CLI validation **before** provider startup, so Ghidra would not unlock Hellcats CODE analysis |
| Overwriting `~/.cursor/mcp.json` | Forbidden for this evaluation |

Restarting Cursor was **not** required and was **not** performed. MCP integration is **not** claimed functional.

---

## 4. Ghidra provider status

| Check | Result |
|-------|--------|
| `GHIDRA_INSTALL_DIR` | Unset |
| Doctor `ghidra` | `missing_analysis_engine` |
| Native inspect with `--provider ghidra` | `provider_unavailable` when format/arch admitted; or earlier validation/format errors |

To enable Ghidra later (optional follow-up, **not** done here):

1. Download official Ghidra **12.1.x** release and extract to e.g. `~/tools/ghidra_12.1.x`.
2. Ensure the host native decompiler binary exists under `Ghidra/Features/Decompiler/os/`.
3. `export GHIDRA_INSTALL_DIR=...` and use a JDK version declared by that Ghidra release.
4. Re-run `rea doctor --json`.
5. Still **cannot** select Motorola 68000 via documented `raw-binary` architectures (see [`compatibility.md`](compatibility.md), [`id05-experiment.md`](id05-experiment.md)).

---

## 5. Blockers summary

1. **Default Node 25** — fixed for experiments via disposable Node 24 tarball.  
2. **No Ghidra 12.1.x install** — blocks admitted raw-binary LE targets; does not change 68000 admission.  
3. **No MCP registration** — intentional.  
4. **Architecture gap** — Hellcats CODE requires 68000 BE; REA 6.5.0 raw-binary list is `6502|x86|x86_64|arm|arm64` only (**Verified**).
