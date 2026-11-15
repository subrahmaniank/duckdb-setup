# deploy_all.ps1
# Master deployment script for all DuckDB sample databases
# Deploys: AdventureWorks DW, AdventureWorks OLTP, DVD Rental, FSI Demo
#
# Usage:
#   .\deploy_all.ps1
#   .\deploy_all.ps1 -Databases "dvdrental,fsi_demo"

param(
    [Parameter(Mandatory=$false, HelpMessage="Comma-separated list of databases to deploy (default: all)")]
    [string]$Databases = "all"
)

$scriptDir = $PSScriptRoot

# Execute python deploy_all.py or uv run
if (Get-Command python -ErrorAction SilentlyContinue) {
    python "$scriptDir\deploy_all.py" --databases "$Databases"
} elseif (Get-Command uv -ErrorAction SilentlyContinue) {
    uv run --with duckdb python "$scriptDir\deploy_all.py" --databases "$Databases"
} else {
    Write-Error "Python or uv was not found in PATH. Please install Python or uv."
    exit 1
}

if ($LASTEXITCODE -ne 0 -and (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "Retrying using uv run --with duckdb..." -ForegroundColor Yellow
    uv run --with duckdb python "$scriptDir\deploy_all.py" --databases "$Databases"
}

exit $LASTEXITCODE
