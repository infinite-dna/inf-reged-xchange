# Define paths
$logFilePath = "C:\path\to\your\logfile.log"
$sourceSharePath = "\\shared\source\directory"
$destinationPath = "C:\path\to\destination"

# Ensure destination directory exists
if (!(Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

# Extract file names from error lines
$filenames = Get-Content $logFilePath | ForEach-Object {
    if ($_ -match "Error executing script:\s*(.+\\([^\\]+))$") {
        [System.IO.Path]::GetFileName($matches[1])
    }
} | Where-Object { $_ -ne $null } | Select-Object -Unique

# Recursively search and copy each file
foreach ($fileName in $filenames) {
    $fileFound = Get-ChildItem -Path $sourceSharePath -Recurse -File -Filter $fileName -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($fileFound) {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $fileFound.Name
        Copy-Item -Path $fileFound.FullName -Destination $destinationFile -Force
        Write-Host "Copied: $fileFound.FullName to $destinationFile"
    } else {
        Write-Warning "File not found: $fileName"
    }
}
