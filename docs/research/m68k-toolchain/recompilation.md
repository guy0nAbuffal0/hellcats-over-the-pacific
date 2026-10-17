# Recompilation PoC — ID05 RNG

Isolated portable C under `tools/recompilation/id05_rng/`. No Macintosh Toolbox linkage. No claim of binary equivalence with `ID05.bin`.

## Layout

```text
tools/recompilation/id05_rng/
  rng_id05.h / rng_id05.c   # uint32_t LCG + 15-bit extract
  test_rng_id05.c           # vectors aligned with godot/hellcats/tests/test_rng.gd
  Makefile                  # -Wall -Wextra; optional ASan/UBSan on clang
```

## Algorithm (from `ID05.c` / bytes)

```text
state = state * 0x41c64e6d + 0x3039   (mod 2^32)
return (state << 1) >> 17             (15-bit unsigned)
```

Matches Godot `godot/hellcats/core/rng.gd` (`Rng68k`) math. Immediate constants appear at file offsets **0x730** / **0x738** in `ID05.bin`.

## Build / test

```bash
make -C tools/recompilation/id05_rng clean test
# or
bash tools/qa/test_id05_rng_c.sh
```

## Claimed vs not claimed

| Claim | Status |
|-------|--------|
| Behavioral equivalence on **tested vectors** | Yes (C harness PASS) |
| Same math as Godot `Rng68k` | Yes (by construction / shared constants) |
| Bit-identical object code to Mac CODE | **Not claimed** |
| Drop-in replacement for full ID05 segment | **Not claimed** |
| A5 globals / Toolbox seeding semantics beyond tested API | **Not claimed** |

## Compiler notes

- Prefer `clang` with `-Wall -Wextra`.  
- Optional: `make SANITIZE=1` when Makefile supports address/undefined sanitizers.  
- Keep the module free of platform `#ifdef` for classic Mac APIs.
