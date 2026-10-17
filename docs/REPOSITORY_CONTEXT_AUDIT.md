# Repository context audit

Audit date: 2026-10-18. Scope: local repository plus the configured GitHub
remote. Evidence collection was read-only. The only audit-created change is this
report; the four working-tree modifications listed below predated the report.

Token figures are estimates using UTF-8 bytes divided by four. The installed
tokenizer package had no cached vocabulary, so no model-specific count was
available without downloading data. Token estimates are not latency claims.

## 1. Git and GitHub status

| Item | Observed state |
|---|---|
| Local repository | `/Users/math/Sites/darkwood/hellcats-over-the-pacific` |
| Configured remote | `origin = git@github.com:matyo91/hellcats-over-the-pacific.git` (fetch and push) |
| GitHub URL | `https://github.com/matyo91/hellcats-over-the-pacific` |
| GitHub visibility | Public; not archived |
| Branch/default branch | Local `main`; GitHub default `main` |
| Local HEAD | `438034699aff00229062970e1d66f0ec3219048d` — “Enhance project documentation and resource management for Hellcats Over the Pacific” |
| Live remote HEAD | Same commit, verified with `git ls-remote`; ahead/behind `0/0` |
| Live branches | `main` only; it is not protected |
| Pull requests | Five historical PRs: four merged, one closed; no open PR |
| GitHub Actions | Zero workflows; no `.github/` workflow files |

The worktree was not clean at audit start:

- `docs/DECOMPILATION_PROGRESS.md` modified;
- `docs/DECOMPILATION_SYMBOLS.md` modified;
- `docs/research/DECOMPILATION_HISTORY.md` modified;
- `sources/resedit/CODE/Pacific Conflict.decomp.c` modified.

Those changes are a coherent, uncommitted reconstruction update through
iteration 349. The audit did not alter them. Their diff is 54 insertions and 8
deletions, including evidence for aircraft control and damage fields.

Repository measurements:

| Metric | Value |
|---|---:|
| Tracked files | 649 |
| Current tracked worktree bytes | 260,686,515 (248.6 MiB) |
| Whole checkout | 435 MiB |
| `.git/` | 184 MiB |
| Packed Git objects | 1,881 objects, 183.51 MiB |
| GitHub reported disk use | 187,928 KiB |
| Ignored files | 74 files, 257,673 bytes |

The ignored set consists mainly of 54 Godot `.uid` files, nine Python `.pyc`
files, and `.godot` editor caches. No `.uid`, `.pyc`, `.DS_Store`, Godot cache,
compiled ID05 test binary, or dSYM is currently tracked.

Largest tracked files are the 63.3 MiB gameplay video, two approximately 59 MiB
archives, the 43.8 MiB handbook PDF, and other original manuals/media. These
dominate storage and Git history but are not automatically loaded into model
context. They are evidence/reference assets, not token-cleanup targets. Moving
them to Git LFS would be a clone-size decision with history/rewrite risk and
negligible inference benefit.

## 2. Content inventory

Classification is mutually exclusive for measurement. “Playable prototype” is
kept separate from the source-faithful strict-port directory.

| Category | Files | Bytes | Treatment and AI-loading behavior |
|---|---:|---:|---|
| Original/reference evidence | 60 | 253,883,082 | KEEP. Disks, archives, manuals, screenshots, sounds, video; rarely loaded as text. |
| Resource metadata/representations | 270 | 2,026,617 | KEEP or generate selectively. JSON is queried; ResEdit Markdown/hex can be original evidence and must not be bulk-deleted. |
| Semantic reconstruction | 10 | 1,509,225 | KEEP. Retrieve individual functions/blocks, never whole corpus. |
| Original Ghidra decompilation | 10 | 839,308 | IMMUTABLE/KEEP. Read only for selected function evidence. |
| Original ResEdit evidence | 134 | 589,151 | KEEP. Payloads and CODE exports; some binaries are reproducible but protected. |
| Historical material | 18 | 571,718 | ARCHIVE/ON DEMAND. Excluded from normal startup context. |
| Active RE/project documentation | 39 | 445,758 | CONSOLIDATE where facts overlap; use task-specific entry points. |
| Playable prototype | 34 | 362,143 | KEEP as comparison/runtime shell, not as original-behavior authority. |
| Tests and fixtures | 46 | 317,922 | KEEP current suite; investigate legacy tests and duplicate fixtures. |
| Tooling | 20 | 130,888 | KEEP current deterministic tools; retire superseded one-offs. |
| Strict Godot port | 5 | 8,009 | AUTHORITATIVE target/mapping area; preserve. |
| AI instructions | 1 | 1,365 | Tier 0, automatically loaded. |
| Repository support | 2 | 1,329 | License and ignore rules. |

The 98 resource Markdown files total about 107,404 estimated tokens and the 122
resource JSON files about 193,965. This is harmless while accessed through
`tools/resedit.py`; it is expensive only when a broad search or retrieval system
injects the full resource tree. The JSON contains only 8,136 decoded bytes as
hex-valued fields, so removing embedded hex would save little and could weaken
field-level evidence. `docs/RESOURCE_ANALYSIS.md:41-69` also establishes that
some ResEdit exports are authoritative version-specific evidence.

## 3. Duplicate-content findings

Seven actionable duplication candidates were found. Only the first two are
byte-identical files.

| ID | Paths | Finding and authority | Loss/reproducibility | Estimated token impact | Recommendation |
|---|---|---|---|---:|---|
| D1 | `godot/hellcats/tests/fixtures/proven_loader_targets.json`, `godot/tests/fixtures/proven_loader_targets.json` | Exact SHA-256 duplicate, 1,736 bytes. Current suite uses `godot/tests/fixtures`; regression code explicitly tolerates the legacy copy at `tools/qa/test_regression.py:173-176`. | Reproducible duplicate; no unique evidence. | ~434 | SAFE_TO_REMOVE legacy copy after references/tests move. |
| D2 | `godot/hellcats/tests/fixtures/replay_inputs.json`, `godot/tests/fixtures/replay_inputs.json` | Exact SHA-256 duplicate, 56 bytes; same legacy check at `tools/qa/test_regression.py:202-204`. | No unique evidence. | ~14 | SAFE_TO_REMOVE legacy copy after migration. |
| D3 | `docs/DECOMPILATION_INVENTORY.json`, `docs/DECOMPILATION_SYMBOLS.md`, `docs/research/DECOMPILATION_HISTORY.md`, source-local `Original: FUN_*` comments | Function identity/status is spread among a 736-row original inventory, 705 historical tracker rows, 676 unique symbol IDs, and source comments. `tools/decomp/inventory_functions.py:19-64` records only original name/file/line; `tools/re_query.py:128-136` still retrieves status from the historical Markdown table. | All evidence is valuable, but independently maintained status/name rows can drift. | Avoids accidental loading of ~33,076 symbol-registry and ~95,456 history tokens. | CONSOLIDATE by extending the existing inventory schema; generate progress/status views. Do not create a second registry. |
| D4 | `README.md`, `docs/PROJECT_STATUS.md`, `docs/TECHNICAL_OVERVIEW.md`, `docs/ROADMAP.md`, `docs/IMPORT_STATUS.md`, convergence docs | Architecture, current state, workflow, and next steps recur. The five older overview/workflow files total ~8,385 tokens. `TECHNICAL_OVERVIEW.md:1-3` still calls itself the single entry point although `README.md:8-23` is now canonical. | Mostly reproducible narrative; topic-specific evidence must remain. | 5,000–8,000 per broad architecture read | CONSOLIDATE into links plus topic-specific facts; archive superseded prose. |
| D5 | Current counts in `docs/DECOMPILATION_PROGRESS.md:15-33`, `docs/PROJECT_STATUS.md:16-25`, `docs/STRICT_PORT_FOUNDATION.md:14-20`, and resource counts in `docs/RESOURCE_ANALYSIS.md:17-33` | Repeated manually maintained statistics are already inconsistent: strict foundation says 680 renamed/50 verified while the live checkpoint says 674/56; resource analysis says 279 representations while generated inventory reports 292. | Counts are deterministically reproducible. | Small per read, high correctness/maintenance impact | Generate count snippets from inventories/manifests; keep prose free of copied live counts. |
| D6 | Loader target fixture, `tools/qa/test_regression.py:44-51`, and `docs/LOADER_CHAIN.md` | Six targets are represented in fixture, hard-coded expected rows, and narrative. Independent test expectations have value, but the documentation should not be another manually updated table. | Fixture and byte proof are authoritative; narrative can be generated/referenced. | ~500–1,000 | KEEP independent test invariants; generate the human table from the fixture plus proof metadata. |
| D7 | Per-resource `.bin`, `.json`, `.md`, images/audio under `sources/resedit/` | Formats overlap structurally, but are not blanket duplicates: binary is payload, JSON is generated index/decoding, and Markdown may be original ResEdit hex/annotation. Only 8,136 decoded bytes are repeated as JSON hex fields. | Unique provenance would be lost by mass deletion. | Up to ~301,000 only if bulk-loaded | KEEP; enforce on-demand retrieval and search exclusions. Consider generated concise views, not deletion. |

No other exact duplicate groups were found among non-empty tracked files.
`ID01.c` and `ID01.decomp.c`-style pairs are explicitly not duplicates: they
have different provenance and editability.

## 4. Deprecated and obsolete candidates

Five candidate groups merit action; none contains original evidence.

| Candidate | Evidence | Classification | Recommended action |
|---|---|---|---|
| Eight legacy test scripts under `godot/hellcats/tests/*.gd` | The canonical runner lists only `res://tests/...` at `godot/tests/run_all.gd:6-25`. Commit `dacbc15` introduced the legacy tree during a test-layout refactor. | NEEDS_INVESTIGATION | Compare assertions against current unit/integration tests, migrate any unique cases, then archive/remove legacy scripts. |
| `tools/run_headless_rng_test.sh` | Unreferenced; line 13 invokes the legacy path while the canonical runner uses `res://tests/unit/test_rng.gd`. | SAFE_TO_REMOVE or replace | Prefer one documented targeted Godot invocation; remove after verifying no external caller. |
| `tools/mac_resources/extract_sounds.py` | Heuristic fixed-offset/raw-PCM carver with guessed 22,050 Hz at lines 15-49. Current resource parser decodes `snd ` structures deterministically. | ARCHIVE | Keep in Git history or research archive only; do not present as active extraction tooling. |
| `sources/sounds/wrong_sample_rate_or_too_fast/*.wav` | Eleven unreferenced files, 40,006 bytes total, explicitly labeled incorrect; created by the superseded sound experiment. | SAFE_TO_REMOVE | Remove from active tree after confirming they are not needed as negative fixtures; Git history preserves them. |
| `docs/TECHNICAL_OVERVIEW.md`, `docs/ROADMAP.md`, `docs/CONVERGENCE_BACKLOG.md`, `docs/CONVERGENCE_LOOP_TEMPLATE.md` as active workflow | They describe the older prototype convergence process (`TECHNICAL_OVERVIEW.md:99-119`, `169-181`) while `AGENTS.md:3-30` and `DECOMPILATION_PROGRESS.md:48-85` define the strict workflow. ROADMAP also contains superseded “next boundary” statements at lines 54-67. | CONSOLIDATE/ARCHIVE | Retain unique architectural/history facts, then route current work through README, project status, strict foundation, and the live checkpoint. |

The playable prototype itself is KEEP: `docs/PROJECT_STATUS.md:9-14` explicitly
defines it as a comparison/runtime shell. It is deprecated only as a source of
original behavior, not as runnable project infrastructure.

## 5. Canonical sources of truth

| Concept | Current/proposed authority | Secondary representation policy |
|---|---|---|
| Original bytes and Ghidra identifiers | Protected CODE payloads and immutable `sources/resedit/CODE/*.c`; checksum manifests | Never rewrite or infer replacements. |
| Semantic function name and evidence | Current `.decomp.c` definition and source-local provenance comment | Index deterministically; source-local evidence remains. |
| Function inventory/status/confidence | Evolve `docs/DECOMPILATION_INVENTORY.json` in place to include segment-qualified identity, semantic name, address, status, confidence, and evidence pointers | Generate checkpoint counts and query output; stop maintaining tracker rows independently. |
| C-to-GDScript mapping | `godot/strict_port/mappings/functions.json` (`STRICT_PORT_FOUNDATION.md:66-78`) | Generated coverage only; keep source comments explanatory rather than tabular duplicates. |
| Source hashes/translation drift | Mapping manifest plus `tools/strict_port/check_sync.py:51-117` | Checker output is generated, not committed prose. |
| Resource identity and relationships | Original `.bin`/ResEdit evidence plus resource-local JSON; `sources/resedit/inventory.json` is an index | Query through `tools/resedit.py:1360-1413`; generated summaries should not become independent authorities. |
| Callers/callees/globals | Derive from current `.decomp.c` on demand | Do not commit a static call-graph report unless it includes source hashes and a generator. |
| Current project status | `docs/PROJECT_STATUS.md` for prose; manifests/inventories for counts | README links; technical overview should not repeat live statistics. |
| Test list | `godot/tests/run_all.gd:6-25` | Documentation references the runner; legacy paths are migrated or archived. |

The proposed registry must use `(segment/source file, original FUN identifier)`
as identity. There are 736 inventory records but only 725 unique `FUN_*` strings,
so an unqualified function identifier is not globally unique.

## 6. AI instructions and recurring loops

Tier 0 is already small: `AGENTS.md` is 1,365 bytes (~341 tokens) and states the
immutable-source rules, strict mapping, narrow retrieval, validation, and no
automatic commit/push (`AGENTS.md:3-30`). It is the only automatically loaded
project instruction file found. README and all docs are on demand.

Recommended hierarchy:

- **Tier 0 — always loaded:** `AGENTS.md` only.
- **Tier 1 — task-specific:** live checkpoint, one function/block, direct
  callers/callees, its globals, one symbol record, mapping row, and targeted
  tests.
- **Tier 2 — on demand:** original full C files, symbol registry, ResEdit corpus,
  complete historical ledgers, manuals, broad architecture assessments.

The live checkpoint correctly says not to load history and to perform targeted
validation (`docs/DECOMPILATION_PROGRESS.md:48-61,83-85`). However, the current
worktree still appends each iteration to
`docs/research/DECOMPILATION_HISTORY.md`. Routine narrative append-only logging
adds search noise and maintenance without improving the live checkpoint. Record
only unique evidence there; derive routine facts from the registry and Git.

No GitHub workflow runs validations. This avoids automatic context but leaves
drift checks dependent on local discipline. A small CI workflow could run
read-only Python/resource/sync/link checks; Godot can remain optional if runner
availability or cost is a concern.

## 7. Token-consumption baselines

Representative current workflows:

| Workflow | Files/output measured | Estimated tokens | Relevant versus excess |
|---|---|---:|---|
| Start architecture session | AGENTS, README, PROJECT_STATUS, STRICT_PORT_FOUNDATION, SUBSYSTEM_MAP | 5,658 | Mostly relevant; duplicated architecture/count prose remains. |
| Start one five-minute iteration | AGENTS + live checkpoint | 1,294 | Relevant and appropriately small. |
| Current iteration using whole `FUN_0000e792` | Base + `function`, status, and symbol query | 11,085 | Much of the monolithic function is unrelated to the selected damage bits. |
| Current iteration with hand-filtered address/symbol excerpt | Base + status/symbol + `rg` hits | 3,863 | Approximately 65% smaller; demonstrates value of block/address retrieval. |
| Port one small function (`FUN_0000e42a`) | Strict foundation, function/callers/globals/status/symbol, entire 1,720-line flight test file | 29,011 | The full multi-function test file dominates; the relevant test is lines 59-76. |
| Inspect `DITL:137` | AGENTS, resource reference, concise inspect + relationships | 2,346 | Relevant; avoids ~301k tokens of bulk resource Markdown/JSON. |
| Review a flight-model regression | AGENTS, testing guide, one test file, implementation | 4,056 | Reasonable targeted bundle. |
| All active Markdown | Active root/docs/contracts/briefs/Godot docs | 90,550 | Must not be startup context. |

A controlled comparison should replay these same five tasks before and after
each retrieval/consolidation change. Record exact files/command output, tokenizer
count, relevant-line count, answer correctness, and wall time over multiple
runs. Use token counts to establish context reduction; only the controlled wall
time measurement can support an inference-speed claim.

## 8. Source retrieval audit

`tools/re_query.py:24-177` is the correct lightweight foundation. Current support:

| Capability | Status |
|---|---|
| Original `FUN_*` lookup | Yes |
| Semantic-name lookup | Yes |
| Exact function body | Yes |
| Direct textual callers | Yes |
| Globals referenced | Yes, undifferentiated |
| Strict source-to-target mapping | Yes |
| Verification/status evidence | Yes, but status depends on historical Markdown |
| Lookup by address | No |
| Direct callees | No |
| Global reads versus writes | No |
| Labeled block/range extraction | No |
| Targeted test-case lookup | No |
| Resource references from a function | No unified query; available separately through `tools/resedit.py` |

Extend this existing tool rather than add a database. Build a deterministic
in-memory index per invocation, keyed by segment, original ID, semantic name,
and address. Add `address`, `callees`, `globals --reads/--writes`, `excerpt` or
`block`, and `tests` subcommands. Emit source paths and line ranges. Read status
from the evolved machine inventory, not the 381 KiB historical ledger.

For very large functions such as `update_aircraft_entity`, address/block lookup
is more important than function lookup. For large aggregate test scripts such as
`godot/tests/unit/test_flight_math.gd`, a deterministic GDScript function
extractor would reduce a small-function port bundle from ~29k tokens toward the
low thousands.

## 9. Prioritized consolidation plan

| Priority | Candidate | Proposed action | Expected token impact | Risk | Evidence |
|---|---|---|---:|---|---|
| P0 | Large-function/test retrieval | Extend `re_query.py` with address, block, callee, read/write, and test-case queries | ~7,200 saved on current e792 iteration; potentially >20k on small-function port workflow | Low–Medium; parser must fail closed on ambiguity | `tools/re_query.py:28-177`; measured workflows above |
| P0 | Function/status source of truth | Extend existing decompilation inventory schema and generate progress/status views | Avoids 33k symbol + 95k history bulk loads; removes stale status path | Medium; migration must preserve every confidence/evidence field | D3; inventory generator `tools/decomp/inventory_functions.py:19-64` |
| P0 | Repeated/stale statistics | Generate counts from decomp inventory, strict manifest, and resource inventory | Hundreds of tokens/read plus correctness benefit | Low | D5 contradictions |
| P1 | Resource retrieval boundary | Configure searches/retrievers to exclude `sources/resedit/**/*.md|json` by default and use `resedit.py` | Avoids up to ~301k tokens on accidental bulk retrieval | Low | `tools/resedit.py:1360-1413`; resource measurements |
| P1 | Overview/workflow documents | Reduce TECHNICAL_OVERVIEW/ROADMAP/IMPORT/CONVERGENCE files to unique facts and links; archive superseded prose | 5k–8k per broad architecture read | Medium; review unique claims first | D4 and deprecated table |
| P1 | Legacy tests and fixtures | Diff assertion coverage, migrate unique cases, remove exact fixture copies and retired scripts | ~9.8k tokens/search plus fewer false test entry points | Medium for scripts, low for exact fixture copies | `godot/tests/run_all.gd:6-25`; D1/D2 |
| P2 | Sound experiment | Archive heuristic carver; remove known-wrong unreferenced WAV outputs | Small token impact; ~40 KiB tree cleanup | Low after reference check | `extract_sounds.py:15-49`; named output directory |
| P2 | Loader table views | Generate narrative table from fixture/proof metadata while retaining independent invariants | ~500–1,000 | Medium; do not weaken byte-level proof | D6 |
| P2 | Large media/Git history | Consider LFS only for future clone/storage policy | No meaningful token impact | High if history rewritten | Largest-file and pack measurements |

## 10. Risk assessment and expected outcomes

Do not delete original archives, disks, manuals, resource forks, ResEdit exports,
protected `.c`, semantic `.decomp.c`, source-local provenance, strict mappings,
or unique fixtures. Do not infer redundancy from similar names. Before removing
legacy tests, produce an assertion-level coverage comparison; before changing
resource representations, preserve original version/provenance distinctions.

Expected outcomes if P0/P1 items are implemented:

- five-minute semantic work remains near the ~1.3k-token base and typically
  retrieves only a few thousand task tokens, even inside large functions;
- one function has one segment-qualified machine status/name record, with
  Markdown counts generated rather than copied;
- architecture startup loses 5k–8k of overlapping optional prose;
- resource inspection stays around 2–3k tokens instead of exposing a ~301k-token
  corpus;
- current and legacy test entry points stop competing in search results;
- original evidence and strict `.c -> .decomp.c -> .gd` traceability remain
  unchanged.

Measure success with the controlled workflow suite above, inventory/schema
consistency checks, strict-port hash verification, resource verification,
Markdown-link validation, exact-duplicate scanning, and a zero-loss checklist
for protected evidence. Repository byte reduction is secondary and must not be
reported as token reduction.

## Implementation appendix — 18 October 2026

The P0/P1 recommendations above were implemented without changing immutable
Ghidra exports, original resources, media, or strict-port translations. The
concurrent semantic-reconstruction work through iteration 353 was preserved.

### Retrieval and canonical state

- `tools/re_query.py` now resolves segment-qualified original IDs, semantic
  names, and exact function addresses; emits exact paths/ranges; rejects
  unsupported or ambiguous mappings; retrieves bounded line/address/named-block
  excerpts; reports direct callers/callees and conservative global access; and
  returns canonical original/reconstruction/strict-port correspondence.
- `re_query.py tests` extracts one canonical GDScript case, module setup,
  fixture paths, and direct same-file helper dependencies. Regression coverage
  includes a 1,720-line test aggregate, a direct helper, ambiguity, and invalid
  address failures.
- `docs/DECOMPILATION_INVENTORY.json` is schema v2. Its mandatory identity is
  `segment::original_function`; all 736 records are covered, the 725 bare IDs
  remain visible, all semantic definitions resolve, 707 historical tracker
  records are linked, three strict mappings are embedded, and migration has
  zero unresolved conflicts. Source-local provenance remains in `.decomp.c`.
- `tools/decomp/inventory_functions.py --check` validates deterministic
  regeneration, coverage, collisions, source ranges/hashes, and migration.
  Existing schema-v2 annotations take precedence over the archived Markdown
  tracker on later regenerations.
- `tools/progress_stats.py` generates independent reconstruction, strict-port,
  and resource counts. “Name verified” means the migrated confidence includes
  `PROVEN` or the reconstruction is semantically verified; it is not an overall
  completion percentage.

### Resource and documentation boundaries

- `tools/resedit.py` retains `inspect`, `search`, and `references`, and adds
  one-child `item`, bounded `raw`, and `unresolved` retrieval. `.ignore`
  excludes generated ResEdit Markdown/JSON and `docs/research/` from default
  broad ripgrep results while explicit file queries continue to work.
- README, project status, strict foundation, semantic checkpoint, technical
  reference, roadmap, import status, and resource analysis now have distinct
  responsibilities. Copied live counts were replaced with generated commands.
- The prototype-era convergence backlog and loop template moved unchanged in
  substance to `docs/research/`, with archival headers and current-work links.

### Legacy tests and exact duplicates

The two legacy fixture copies were byte-identical before removal. Four legacy
test scripts had stronger canonical equivalents. Thirteen unique movement and
entity-control assertions were moved into
`godot/tests/integration/test_movement_smoothing.gd` and
`test_sim_entity_controls.gd`, then added to the canonical runner. The latter's
obsolete ID05-LCG expectation was updated to independently replay the current
overlay `FUN_00011564` RNG; the assertion's control-offset purpose is retained.
The old editor RNG harness and obsolete headless path were retired; the shell
launcher now invokes `res://tests/run_all.gd`.

### Files changed by the context implementation

- Created: `.ignore`, `tools/progress_stats.py`,
  `tools/qa/measure_context.py`, and the two canonical integration tests above.
- Updated: `README.md`, `docs/DECOMPILATION_INVENTORY.json`,
  `docs/DECOMPILATION_PROGRESS.md`, `docs/IMPORT_STATUS.md`,
  `docs/LOADER_CHAIN.md`, `docs/MISSION_01_MVP.md`,
  `docs/PROJECT_STATUS.md`, `docs/RESOURCE_ANALYSIS.md`, `docs/ROADMAP.md`,
  `docs/STRICT_PORT_FOUNDATION.md`, `docs/TECHNICAL_OVERVIEW.md`, this audit,
  `godot/tests/run_all.gd`, `sources/resedit/inventory.json`,
  `tools/decomp/inventory_functions.py`, `tools/qa/test_re.py`,
  `tools/qa/test_regression.py`, `tools/re_query.py`,
  `tools/recompilation/id05_rng/test_rng_id05.c`, `tools/resedit.py`, and
  `tools/run_headless_rng_test.sh`.
- Archived: `docs/CONVERGENCE_BACKLOG.md` and
  `docs/CONVERGENCE_LOOP_TEMPLATE.md` under `docs/research/`.
- Removed: the two duplicate fixtures and six superseded scripts under
  `godot/hellcats/tests/`. Unique non-duplicate fixtures in that directory were
  retained because active prototype code still references them.

### Validation

- Protected checksum manifest: every listed `.c`, CODE payload, binary, and
  support file reports `OK` (the existing manifest also emits one harmless
  “improperly formatted line” warning).
- Registry: 736 records, 736 unique composite identities, zero migration
  conflicts; current reconstruction states are 673 renamed, 57 semantically
  verified, and 6 blocked.
- Strict mapping sync: 3/3 mappings source-synchronized and behaviorally
  verified; none integrated.
- ResEdit: 119 resources across 30 types verify; 116 parsed structures and 3
  unresolved formats.
- Python retrieval, deterministic QA, native ID05 RNG, Markdown links, and
  `git diff --check`: pass.
- Godot 4.6.2: 20 canonical suites passed, 0 failed, including the two migrated
  legacy-coverage suites and Mission 01 scene/HUD load tests.

### Reproducible context measurements

`python3 tools/qa/measure_context.py` uses the audit method
`ceil(UTF-8 bytes / 4)` over listed files plus command stdout:

| Workload | Before | After | Reduction |
|---|---:|---:|---:|
| A: large-function iteration (full baseline) | 11,085 | 3,344 | 69.8% |
| A: former hand-filtered comparison | 3,863 | 3,344 | 13.4% |
| B: strict-port translation | 29,011 | 3,507 | 87.9% |
| C: DITL:137 inspection | 2,346 | 594 | 74.7% |
| D: canonical architecture startup | 5,658 | 2,168 | 61.7% |
| E: representative flight regression | 4,056 | 711 | 82.5% |

These are context estimates, not measured inference latency. P2 sound cleanup,
loader-table generation, and any Git LFS/history policy remain deferred.
