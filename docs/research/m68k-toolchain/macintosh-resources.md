# Macintosh resources

## `Hellcats.rsrc` classification

Path: `sources/Hellcats/Hellcats.rsrc` (121 559 B).

| Check | Result |
|-------|--------|
| First bytes | Repeating `0xc8` (`c8c8c8c8…`) |
| Classic data/map header | **No** — not a resource-fork layout |
| Contains `CODE` / `PICT` FourCC | **No** |
| `parse_rsrc.py` | Fails with `map_offset beyond file end` (consistent) |

**Classification:** `NOT_classic_resource_fork` — corrupt or wrong export. Do not invent resource IDs from this file. Artifact: `artifacts/reverse-engineering/resources/hellcats-rsrc-classification.json`.

## Real inputs: HFS floppy images

From `hellcatsoverthepacific.zip` / extracted sources (819 200 B each). MD5s match `checksum.md5`:

| Image | MD5 |
|-------|-----|
| `Hellcats_1_0_3.dsk` | `6979c7ffad02827c7510854c298be05b` |
| `Version_1_0_4.dsk` | `aabe56091453a090f320671e173b63b3` |
| `LeyteGulf.dsk` | `edd67d7d5baaf03d97076766f9228db4` |

**Blockers tried:** `hdiutil attach` / Disk Utility fail on these classic HFS floppies on modern macOS. **Workaround:** read with **machfs** (no privileged mount).

## Extraction pipeline

```bash
python3 tools/mac_resources/extract.py \
  --dsk path/to/Hellcats_1_0_3.dsk \
  -o artifacts/reverse-engineering/resources/from_103

python3 tools/mac_resources/verify.py \
  artifacts/reverse-engineering/resources/from_103/hfs/inventory.json
```

`extract.py` walks the HFS volume, writes `*.data` / `*.rsrc` payloads, and emits inventory JSON (path, sizes, SHA-256, type/creator when present). Optional absolute paths to `resource_dasm` / `rsrcdump` dump typed resources from application forks.

## CODE resources vs ResEdit bins

From the Hellcats application resource fork on `Hellcats_1_0_3.dsk`, CODE IDs **0–9** were extracted. SHA-256 of CODE **5** matches protected ResEdit `ID05.bin`:

`1c7a3a39153e01b156a17f1e312aa948d0ed906022aa6a1ebd834b9317e2d5f0` (3064 B)

See `artifacts/reverse-engineering/resources/code-from-rsrcfork.json`.

## Tool notes

| Tool | On `.dsk` directly | On extracted `.rsrc` fork |
|------|--------------------|---------------------------|
| resource_dasm | Fail / wrong format | Success (CODE dumps) |
| rsrcdump | N/A | Success (listing) |
| python-rsrcfork | N/A | Success |
| machfs | Success | N/A (volume reader) |

StuffIt `Hellcats_Over_the_Pacific.SIT` was not required for this pass (`unar` optional; `.dsk` path sufficient).

## Inventory helpers

- `inventory.py` — corpus file kinds under sources (unchanged role).  
- `extract.py` / `verify.py` — HFS → artifacts + re-hash.  
- Never invent type/ID/name when parse fails.
