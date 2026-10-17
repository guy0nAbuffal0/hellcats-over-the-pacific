# Strict C-to-GDScript port foundation

## Decision

The editable `*.decomp.c` files are now the architectural source of truth for
new Godot simulation logic. The Mission 01 prototype remains preserved and
playable, but it is a comparison target and runtime shell, not evidence that an
original algorithm has been ported.

The strict slices are deliberately isolated. Nothing changes `project.godot`, the
main scene, existing scenes, prototype scripts, assets, imports, or runtime
behavior.

## Repository audit

Ten `*.decomp.c` files exist, all in `sources/resedit/CODE/`: ID01 through ID09
and `Pacific Conflict.decomp.c`. `DECOMPILATION_INVENTORY.json` is the canonical
segment-qualified registry. Run `python3 tools/progress_stats.py` for current
counts; reconstruction statuses must not be reported as Godot-port coverage.

The existing Godot project contains two materially different tracks:

| Classification | Current evidence | Treatment |
|---|---|---|
| Reconstructed deterministic logic | `hellcats/core/sim_core.gd`, `flight_math.gd`, RNG modules, loader metadata, replay/trace tests | Reuse as reference evidence and comparison infrastructure; migrate function-by-function only after strict mappings exist. |
| Approximate/simplified gameplay | `flight/flight_model_mvp.gd`, authored mission rules/data, world builder, chase camera | Preserve for the playable prototype; isolate from claims of original equivalence and eventually replace behind adapters. |
| Placeholder/mock state | Mock pointers, flat dictionaries, deferred paths and stand-ins explicitly marked in `sim_core.gd` | Do not promote into strict ports; replace only from verified source/layout evidence. |
| Pure Godot integration | Player input collection, scene controllers, nodes, HUD labels, resource loading | Preserve as the eventual thin runtime-adapter layer. |
| Unknown provenance | Any code without source identity or an explicit MVP/Godot tag | Treat as unverified until audited; do not map retroactively without evidence. |

The current Mission 01 dependency chain is `Main.tscn` →
`Mission01Training.tscn` → world/player/checkpoint/HUD scenes → mission,
aircraft, input, flight-model and objective scripts plus three JSON data files.
It does not call `SimCore.tick()`. The main scene remains unchanged.

`sources/resedit/` contains the inventoried resource corpus. Reusable
evidence includes CODE binaries and metadata, PICT/BMP/PNG artwork, `clut/999`,
icons, `snds`, mission/data resources, dialogs, menus, text and string tables.
Exact palettes and original dimensions must be read from these resources; they
must not be replaced with invented cockpit or scenery assets.

## Directory and ownership model

```text
godot/strict_port/
  code/                 # one module per original CODE segment/overlay initially
  compat/               # explicit C/68000 operations and later packed memory
  mappings/functions.json
  adapters/             # created only when an integration needs Godot lifecycle APIs
godot/tests/strict_port/
tools/strict_port/
```

Segment-oriented modules preserve function ownership and shared state without
creating one file per tiny function. A segment may split later only when a
verified subsystem boundary and state owner justify it.

Original shared globals will be represented by the smallest packed state/memory
object that can preserve addresses, aliasing, big-endian loads/stores, pointer
offsets, initialization order and table layouts. It will be passed explicitly;
it will not become a collection of duplicate node fields or an autoload by
default. The first slice is pure and has no global-state dependency, so no state
container is invented yet.

## Naming and translation rules

1. Use the canonical function name present in the current `.decomp.c`; retain
   its `FUN_*` identity separately as `original_function` in the mapping.
2. Preserve `param_*`, decompiler local names, global `DAT_*` names, function
   boundaries, statement order, branches, constants, indexing and casts.
3. Add a name only through the established decompilation rename process. A
   Godot-only adapter may use an idiomatic lifecycle name but cannot stand in
   for an original function.
4. Record each mapping once, in `mappings/functions.json`. Comments may explain
   semantics but are not a second provenance database.
5. Unknown or unresolved behavior is `BLOCKED`; it is never approximated inside
   the strict layer.

## Compatibility strategy

`strict_port/compat/c68k.gd` currently provides deterministic `u8`, `s8`, `u16`,
`s16`, `u32`, `s32`, 32-bit logical/arithmetic shifts, wrapping, and signed
division/remainder truncated toward zero. Tests cover boundary/sign behavior.

The remaining semantics are intentionally not guessed:

| Concern | Strategy / current state |
|---|---|
| Masks and implicit promotions | Express at each translation boundary with width helpers; the first slice promotes signed `char`, shifts, XORs, then truncates to byte. |
| Fixed point | Add format-specific helpers only when the source establishes the scale; do not reuse the existing interface-only `Fixed68k` as proof. |
| Floating point | Determine original 68k compiler/FPU representation and rounding from binary evidence before porting a dependent function. |
| Pointers, structs, arrays, globals | Introduce a bounds-checked packed memory/state object with explicit offsets when the next slice requires it. |
| Endianness | Use explicit big-endian byte/word/long loads and stores in that memory layer. |
| 68000 flags/overflow | Add operation-specific helpers only for branches proven to depend on condition-code results. |

## Translated slices

`contact_pair_hash` (`FUN_0001358c`, overlay `0x1358c`) is a complete pure
function in `Pacific Conflict.decomp.c`. Its source annotation records an
independent Capstone verification of the instruction sequence: `(b << 2) ^ a`,
then mask to the low byte. The strict GDScript preserves `param_1`, `param_2`,
expression order and byte truncation. Seven fixed vectors cover zero, high-bit,
signed-char and truncation cases. Passing those cases is behavioral evidence
because their expected operation comes from the independent disassembly, not
from executing the GDScript implementation to manufacture expectations.

The `reset_radar_tracks` (`FUN_0001776a`) slice preserves the original three
stores in order: two 32-bit clears at `DAT_00026672` and `DAT_00026676`, then
an 8-bit changed flag store at `_DAT_0002666e`. Independent Capstone evidence
recorded with the decompiled function establishes those widths and addresses;
the deterministic test initializes nonzero counts and sentinel neighbor bytes.

The manifest records the exact source-function SHA-256, source/original names,
address, target and independent milestone booleans. Current strict coverage is:

- Decompiled functions: 736
- Mapped/translated: 3
- Not ported: 733
- Structurally verified: 3
- Behaviorally verified with deterministic tests: 3
- Integrated into the playable runtime: 0
- Verified against original Macintosh runtime observations: 0

## Synchronization workflow

Run `python3 tools/strict_port/check_sync.py --json`. The checker extracts the
mapped function by canonical name, hashes the complete definition, confirms the
target function and deterministic test exist, and emits independent status and
coverage counts. A changed definition is reported as `SOURCE_CHANGED` with old
and new hashes. The checker never edits the manifest or GDScript. Its Python
test makes a temporary altered source copy and proves drift is detected while
the real manifest remains byte-identical.

Adding a port is therefore an explicit review operation: translate the current
source, add independent vectors/evidence, add one manifest row with the reviewed
hash, run synchronization and tests, then advance each milestone separately.

## Migration plan

1. Keep the prototype and strict namespace side by side; do not change the main
   scene while strict coverage is foundational.
2. Port pure verified helpers first, followed by their minimal packed-state
   dependencies and callers. Compare strict results with independent binary,
   fixture or runtime evidence.
3. Add a thin adapter only when a coherent verified slice can consume input or
   publish render/audio state. Run prototype and strict paths independently for
   comparison before switching any consumer.
4. Retire an approximation only after the replacement is mapped, structurally
   and behaviorally verified, integrated, and covered by regression tests.

The second slice, `find_contact_record` (`FUN_000135a0`), directly calls the
completed hash function. It uses the original `DAT_0001bdbc` address, a 256-slot
open-addressing pointer table, record offsets +0/+4, the original decompiler
locals and signed 256-probe counter. `Memory68k` supplies bounds-checked packed
big-endian byte/word/long access instead of a semantic dictionary substitute.

After this slice the generated strict coverage is 3 translated, structurally
verified and behaviorally verified functions; 733 remain unported. None of the
translations is integrated or verified against an observed Macintosh runtime.

The next smallest concrete slice is `set_view_distance` (`FUN_0001771a`), a
verified three-global update adjacent to the radar reset. It can reuse the same
packed-memory state and requires explicit signed 32-bit left-shift/wrap behavior
for `param_1 << 1`.
