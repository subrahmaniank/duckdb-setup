#!/usr/bin/env bash
# deploy.sh
# Automates building the AdventureWorks DW DuckDB database
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="${1:-}"

if command -v python3 &>/dev/null; then
    PY_CMD="python3"
else
    PY_CMD="python"
fi

if [ -n "$OUTPUT" ]; then
    $PY_CMD "$SCRIPT_DIR/build.py" --output "$OUTPUT" || uv run --with duckdb python "$SCRIPT_DIR/build.py" --output "$OUTPUT"
else
    $PY_CMD "$SCRIPT_DIR/build.py" || uv run --with duckdb python "$SCRIPT_DIR/build.py"
fi
