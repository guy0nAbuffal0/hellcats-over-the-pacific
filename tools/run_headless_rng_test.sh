#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
REPO_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
PROJECT_DIR="$REPO_DIR/godot"
export HOME="$PROJECT_DIR/.godot-home"
mkdir -p "$HOME"

exec /Applications/Godot.app/Contents/MacOS/Godot \
	--headless \
	--path "$PROJECT_DIR" \
	--script godot/hellcats/tests/test_rng.gd
