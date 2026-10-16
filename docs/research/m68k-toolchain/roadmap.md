# Roadmap

Prioritized next steps to recover original Hellcats behavior using this toolchain. Ordered by evidence leverage vs risk.

## P0 — Unblock analysis

1. **Native Ghidra decompiler for macOS ARM** — build `mac_arm_64/decompile` from Ghidra sources with correct `-arch arm64`, or document a Linux/CI headless decompile path. Unlocks automated pseudocode refresh without touching protected `.c`.  
2. **Typed resource catalog** — merge `resource_dasm` dumps + HFS inventories into one machine-readable JSON (type, ID, name, size, SHA-256, source volume) committed as a *generated* artifact policy (still gitignore bulk binaries).

## P1 — Semantic depth on ID05 / loader

3. Expand Capstone windows around loader/jump-table consumers already documented in `docs/LOADER_CHAIN.md`.  
4. Promote selected `FUN_*` from `UNKNOWN` → PROVEN only with byte + test evidence (`inventory_functions.py` as the starting list).  
5. Keep Godot `Rng68k` as the runtime source of truth; use C PoC only for regression parity.

## P2 — Broader CODE segments

6. Repeat the ID05 compare pattern for ID00/ID02 entrypoints cited in loader fixtures.  
7. Extract non-CODE resources (PICT, etc.) from `.dsk` forks only when a consumer needs them — never invent IDs.

## P3 — Optional / deferred

8. StuffIt `.SIT` only if `.dsk` path is insufficient and `unar` is already available.  
9. Revisit REA **only** if upstream adds 68000 BE raw CODE (see `docs/research/rea/` verdict C).  
10. Full Mac executable re-link — explicitly out of scope until many more PROVEN contracts exist.

## Non-goals (remain)

- Speculative Godot gameplay features justified as “fidelity.”  
- Overwriting ResEdit `ID*.bin` / `ID*.c` / existing `.decomp.c`.  
- Treating Capstone agreement alone as gameplay proof.
