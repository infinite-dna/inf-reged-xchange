$folderPath = "C:\Path\To\Your\Folder"

# Function to detect file encoding using BOM (Byte Order Mark)
function Get-Encoding {
    param([string]$filePath)

    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    
    switch -regex ($bytes) {
        { $_.Length -ge 3 -and $_[0] -eq 0xEF -and $_[1] -eq 0xBB -and $_[2] -eq 0xBF } { return "UTF-8 with BOM" }
        { $_.Length -ge 2 -and $_[0] -eq 0xFF -and $_[1] -eq 0xFE } { return "UTF-16 LE" }
        { $_.Length -ge 2 -and $_[0] -eq 0xFE -and $_[1] -eq 0xFF } { return "UTF-16 BE" }
        { $_.Length -ge 4 -and $_[0] -eq 0x00 -and $_[1] -eq 0x00 -and $_[2] -eq 0xFE -and $_[3] -eq 0xFF } { return "UTF-32 BE" }
        { $_.Length -ge 4 -and $_[0] -eq 0xFF -and $_[1] -eq 0xFE -and $_[2] -eq 0x00 -and $_[3] -eq 0x00 } { return "UTF-32 LE" }
        default { return "Unknown or ANSI (no BOM)" }
    }
}

# Get all files and analyze encoding
Get-ChildItem -Path $folderPath -File -Recurse | ForEach-Object {
    $encoding = Get-Encoding -filePath $_.FullName
    [PSCustomObject]@{
        File     = $_.FullName
        Encoding = $encoding
    }
} | Format-Table -AutoSize
