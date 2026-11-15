#!/usr/bin/env bash
# deploy_all.sh
# Master deployment script for all DuckDB sample databases
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATABASES="${1:-all}"

if command -v python3 &>/dev/null; then
    PY_CMD="python3"
elif command -v python &>/dev/null; then
    PY_CMD="python"
elif command -v uv &>/dev/null; then
    PY_CMD="uv run --with duckdb python"
else
    echo "Error: Python or uv is required to run deploy_all.sh"
    exit 1
fi

$PY_CMD "$SCRIPT_DIR/deploy_all.py" --databases "$DATABASES" || uv run --with duckdb python "$SCRIPT_DIR/deploy_all.py" --databases "$DATABASES"
