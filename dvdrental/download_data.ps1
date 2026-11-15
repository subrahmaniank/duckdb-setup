# download_data.ps1
# Downloads or copies DVD Rental sample data files
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
python "$scriptDir\download_data.py"
