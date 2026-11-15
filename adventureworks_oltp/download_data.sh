#!/usr/bin/env bash
# download_data.sh
# Downloads or copies AdventureWorks OLTP sample data files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/download_data.py" || python "$SCRIPT_DIR/download_data.py"
