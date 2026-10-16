# Macintosh Resource Extraction — Inventory and Strategy

**Date:** 2026-10-15  
**Tooling:** `tools/mac_resources/` (Python) + REA Apple/artifact probes for negative evidence

---

## 1. REA resource inspection (Verified)

| Probe | Target | Result |
|-------|--------|--------|
| `rea inventory-artifact` | — | **COMMAND_NOT_FOUND** (suggests `inspect-artifact`) |
| `rea inspect-artifact` | `Hellcats/Hellcats.rsrc` | `target_unavailable` / `unsupported binary format` |
| `rea project-apple-application-graph` | Documented for IPA/`.app` inventories | Wrong format family for classic Mac (Documented) |

**Conclusion:** REA’s Apple/artifact path does **not** automate classic Macintosh resource forks or ResEdit CODE exports. Do not use it as a ResEdit replacement.

---

## 2. Available Hellcats inputs (repo)

Root: `hellcats-over-the-pacific-sources/`

Inventory JSON (deterministic, 69 entries):  
`artifacts/rea/resources/inventory.json`  
Re-run equal to `inventory-run2.json` → **Verified deterministic**.

### 2.1 CODE / overlay (extraction largely done)

| Kind | Count | Notes |
|------|-------|-------|
| `code-hex` | 10 | `ID00`–`ID09` ResEdit hex |
| `code-bin` | 10 | Decoded binaries; checksums in `CODE/checksums.sha256` |
| `ghidra-c` | 10 | Protected `ID01.c`–`ID09.c` + `Pacific Conflict.c` (no `ID00.c`) |
| `decomp-c` | 10 | Semantic copies / reconstructions |
| `overlay` | 1 | `Hellcats/Pacific Conflict` 255360 B |

Existing scripts: `CODE/hex2bin.py`, `CODE/tools/inspect_pacific_conflict.py`, `CODE/tools/scan_code_windows.py`.

### 2.2 Application / resource containers

| Path | Size | Status |
|------|------|--------|
| `Hellcats/Hellcats.rsrc` | 121559 | `rsrc-candidate`; **classic resource-map parse failed**: `map_offset beyond file end` |
| `Hellcats/Hellcats` | 0 | Empty app stub |
| `Hellcats/Hellcats.bin` | 0 | Empty stub |
| `Hellcats/Commands and Help` | small | Present; not typed as CODE |

**Do not invent** resource type/ID/name tables for `Hellcats.rsrc` until a valid fork/map is obtained. The on-disk `.rsrc` is **not** proven to be an intact classic resource fork.

**Missing input (documented dependency):** an intact original Macintosh **resource fork** (or verified MacBinary/AppleSingle carrying the real map) for the application, if non-CODE resources (PICT, snd, DLOG, STR#, etc.) are required beyond what was already exported via ResEdit.

### 2.3 Reference materials in-repo

Under `hellcatsoverthepacific/docs/`:

- PDFs: Hellcats Manual, Handbook, Map, Package; Leyte Manual/Map/Package; KeyboardOverlay  
- `FAQ.txt`, `hacks.txt`

Under `Screenshots/`: two PNGs (2026-01-18).

---

## 3. Task-directory extras (not inventing game imagery)

Path: `/Users/math/pCloud Drive/MathieuData/Darkwood/tasks/#798546_hellcats-over-the-pacific`

Recorded in `artifacts/rea/resources/task-refs.json` (16 files): duplicate manuals/screenshots, `Hellcats_Over_the_Pacific.SIT`, cover PNG, four `obs/*.mov` captures.

---

## 4. Extraction strategy (recommended)

```text
Prefer existing ResEdit CODE exports + Pacific Conflict blob
        │
        ├─ already have: hex, .bin, Ghidra .c, checksums
        │
        ├─ Python inventory (tools/mac_resources) for digests / status
        │
        └─ If more resources needed:
              obtain intact resource fork / disk image
              → parse map → extract by type/id → hash → optional decode
              (REA Apple tools: skip)
```

### Reusable pipeline requirements (implemented)

| Requirement | Status |
|-------------|--------|
| Python | Yes |
| No original modification | Yes |
| Deterministic JSON | Yes |
| Explicit I/O paths | Yes (`-o`) |
| SHA-256 | Yes |
| Meaningful errors | Yes (`parse_status` / `error`) |
| Raw binary preservation | Inputs untouched; inventory only |
| No silent metadata loss | Failed parse keeps error; no fake IDs |

---

## 5. Resource types — present vs unknown

| Type class | Present in inventory? | Notes |
|------------|----------------------|-------|
| CODE segments | **Yes** | ID00–ID09 + docs |
| Overlay game blob | **Yes** | Pacific Conflict |
| PICT / icons / cursors / dialogs / strings / sound / terrain | **Unknown** in repo exports | Would need intact resource fork or further ResEdit exports — **not fabricated** |

---

## 6. Commands

```bash
python3 tools/mac_resources/inventory.py -o artifacts/rea/resources/inventory.json
python3 tools/mac_resources/parse_rsrc.py hellcats-over-the-pacific-sources/Hellcats/Hellcats.rsrc
```
