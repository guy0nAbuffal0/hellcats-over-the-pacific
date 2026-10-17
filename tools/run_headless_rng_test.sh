#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
REPO_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
PROJECT_DIR="$REPO_DIR/godot"
exec /Applications/Godot.app/Contents/MacOS/Godot \
	--headless \
	--path "$PROJECT_DIR" \
	--script res://tests/run_all.gd
