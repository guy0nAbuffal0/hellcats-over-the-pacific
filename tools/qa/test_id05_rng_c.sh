#!/usr/bin/env bash
# Compile and run the portable ID05 RNG C harness.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
make -C "$ROOT/tools/recompilation/id05_rng" clean test
