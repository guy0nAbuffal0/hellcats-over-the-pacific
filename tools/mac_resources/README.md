# Macintosh resource inventory tools

Deterministic, read-only inventory and HFS extraction for Hellcats Macintosh source artifacts under `sources/`. Does **not** modify protected CODE exports.

## Commands

```bash
# From repo root — corpus inventory (files under sources/)
python3 tools/mac_resources/inventory.py -o artifacts/rea/resources/inventory.json

# Optional classic resource-fork parse of one file
python3 tools/mac_resources/parse_rsrc.py path/to/file.rsrc

# Extract data + resource forks from a classic HFS floppy image (requires machfs)
python3 tools/mac_resources/extract.py \
  --dsk path/to/Hellcats_1_0_3.dsk \
  -o artifacts/reverse-engineering/resources/from_103

# Re-hash extracted payloads against inventory.json
python3 tools/mac_resources/verify.py \
  artifacts/reverse-engineering/resources/from_103/hfs/inventory.json
```

Optional `--decode-app-rsrc` runs `resource_dasm` / `rsrcdump` on application forks after HFS extract. See `docs/research/m68k-toolchain/macintosh-resources.md`.

## Behavior

- Emits JSON with path, size, SHA-256, kind (inventory) or HFS entry metadata (extract).
- Attempts classic Mac resource-map parse only for `*.rsrc` candidates.
- On parse failure, records `parse_status: failed` and an error string — **never invents** type/ID/name lists.
- `Hellcats.rsrc` in-tree is **not** a classic fork (repeating `0xc8`); prefer `.dsk` images.
- Output is deterministic (stable sort + `sort_keys`).

## Kinds (`inventory.py`)

| kind | Meaning |
|------|---------|
| `code-hex` | ResEdit hex dump `ID0n` |
| `code-bin` | Decoded CODE binary `ID0n.bin` |
| `ghidra-c` | Protected Ghidra export `*.c` |
| `decomp-c` | Semantic reconstruction `*.decomp.c` |
| `overlay` | `Pacific Conflict` blob |
| `rsrc-candidate` | File named `*.rsrc` |
| `app-stub` | Empty `Hellcats` / `Hellcats.bin` |
| `reference` | Manuals, screenshots, FAQ, etc. |
| `disk-image` | Classic HFS `.dsk` (when discovered) |
