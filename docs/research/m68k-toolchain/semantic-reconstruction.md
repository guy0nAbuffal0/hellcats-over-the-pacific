# Semantic reconstruction workflow

Goal: improve naming and contracts from protected Ghidra `.c` exports into `.decomp.c` / Godot **without** inventing behavior.

## Confidence tiers

| Tier | Meaning | Example |
|------|---------|---------|
| **PROVEN** | Bytes + independent disasm + existing tests agree | ID05 LCG constants `0x41c64e6d` / `0x3039`; Godot `Rng68k` vectors |
| **STRONG INFERENCE** | Capstone/Ghidra/C align; limited callers checked | `FUN_00000728` is the LCG step at `0x728` |
| **HYPOTHESIS** | Plausible from structure; needs more evidence | Call-graph roles beyond RNG helpers |
| **UNKNOWN** | Default until proven | Fresh `FUN_*` from inventory helper |

Do **not** label gameplay or flight fidelity as PROVEN from this toolchain pass.

## Inventory helper (read-only)

```bash
python3 tools/decomp/inventory_functions.py \
  -o artifacts/reverse-engineering/decomp/functions-inventory.json
```

- Parses `FUN_*` declarations from `ID*.c` / `Pacific Conflict.c`.
- Excludes `*.decomp.c`.
- Emits JSON with `confidence: "UNKNOWN"` by default.
- Never rewrites source files.

This pass produced **2120** function entries (artifact under `artifacts/reverse-engineering/decomp/`).

## Recommended loop

1. Pick a `FUN_*` with a clear byte landmark (constants, distinctive prologue).  
2. Disassemble the region with `tools/m68k/disasm_region.py`.  
3. Cross-check Ghidra C / headless function entry.  
4. Write or update a **contract** doc; only then edit `.decomp.c` in a dedicated pass.  
5. Add Godot / C vectors before claiming behavioral equivalence.

## Out of scope for this pass

- Editing any `.decomp.c`.  
- Mass renames in protected `.c`.  
- Claiming Toolbox or A5 world semantics without further RE.
