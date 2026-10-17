# Strict port namespace

This directory is the source-faithful implementation track. It is isolated from
the playable prototype under `godot/hellcats/` until a translated slice reaches
an explicit integration milestone.

- `code/`: GDScript modules grouped by original CODE segment or overlay.
- `compat/`: explicit C and Motorola 68000 value semantics.
- `mappings/functions.json`: the sole machine-readable source-to-target mapping.

Godot runtime adapters will live in `strict_port/adapters/` when an integration
slice needs one. Adapters may use Godot lifecycle names, but original algorithms
remain in `code/` and may not be replaced by adapter behavior.

From the repository root, verify correspondence with:

```sh
python3 tools/strict_port/check_sync.py --json
```

The command only reports. It never updates hashes or translated GDScript.
