#!/usr/bin/env bash
# Import ID05.bin with Ghidra headless (68000 BE) and export function list.
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
GHIDRA_INSTALL_DIR="${GHIDRA_INSTALL_DIR:-/Users/math/Sites/tests/ghidra_12.1.x}"
JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home}"
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

ID05="${1:-$REPO/sources/ResEdit/CODE/ID05.bin}"
OUT_DIR="${2:-$REPO/artifacts/reverse-engineering/id05}"
PROJ="$OUT_DIR/ghidra_project"
mkdir -p "$PROJ" "$OUT_DIR"

"$GHIDRA_INSTALL_DIR/support/analyzeHeadless" "$PROJ" HellcatsId05 \
  -import "$ID05" \
  -loader BinaryLoader \
  -loader-blockName CODE5 \
  -loader-baseAddr 0x0 \
  -processor "68000:BE:32:default" \
  -cspec default \
  -deleteProject \
  -scriptPath "$REPO/tools/ghidra" \
  -postScript ExportId05.java "$OUT_DIR/functions.json"
