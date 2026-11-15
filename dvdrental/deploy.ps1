# deploy.ps1
# Automates building the DVD Rental DuckDB database
param(
    [string]$Output = ""
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($Output -ne "") {
    python "$scriptDir\build.py" --output "$Output"
} else {
    python "$scriptDir\build.py"
}

if ($LASTEXITCODE -ne 0) {
    # Try with uv if standalone python failed
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        if ($Output -ne "") {
            uv run --with duckdb python "$scriptDir\build.py" --output "$Output"
        } else {
            uv run --with duckdb python "$scriptDir\build.py"
        }
    }
}
