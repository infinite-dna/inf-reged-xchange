# Define paths
$logFilePath = "C:\path\to\your\logfile.log"
$sourceSharePath = "\\shared\source\directory"
$destinationPath = "C:\path\to\destination"

# Ensure destination directory exists
if (!(Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

# Read log file and process each matching line
Get-Content $logFilePath | ForEach-Object {
    if ($_ -match "Error Executing\s*:\s*(.+)$") {
        $fileName = $matches[1].Trim()
        $sourceFile = Join-Path -Path $sourceSharePath -ChildPath $fileName
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $fileName

        if (Test-Path $sourceFile) {
            Copy-Item -Path $sourceFile -Destination $destinationFile -Force
            Write-Host "Copied $fileName"
        } else {
            Write-Warning "File not found: $sourceFile"
        }
    }
}
