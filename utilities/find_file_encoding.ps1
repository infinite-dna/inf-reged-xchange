$folderPath = "C:\Path\To\Your\Folder"

function Get-Encoding {
    param([string]$filePath)

    $bytes = [System.IO.File]::ReadAllBytes($filePath)

    if ($bytes.Length -ge 4) {
        if ($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE -and $bytes[2] -eq 0x00 -and $bytes[3] -eq 0x00) {
            return "UTF-32 LE BOM"
        }
        if ($bytes[0] -eq 0x00 -and $bytes[1] -eq 0x00 -and $bytes[2] -eq 0xFE -and $bytes[3] -eq 0xFF) {
            return "UTF-32 BE BOM"
        }
    }

    if ($bytes.Length -ge 3) {
        if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
            return "UTF-8 with BOM"
        }
    }

    if ($bytes.Length -ge 2) {
        if ($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
            return "UTF-16 LE BOM"
        }
        if ($bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
            return "UTF-16 BE BOM"
        }
    }

    # Heuristic guess for UTF-8 without BOM
    try {
        $content = [System.Text.Encoding]::UTF8.GetString($bytes)
        $reencoded = [System.Text.Encoding]::UTF8.GetBytes($content)
        if ($bytes.Length -eq $reencoded.Length) {
            return "UTF-8 without BOM"
        }
    } catch {
        # Ignore and fall through to default
    }

    return "Unknown or ANSI (no BOM)"
}

Get-ChildItem -Path $folderPath -File -Recurse | ForEach-Object {
    $encoding = Get-Encoding -filePath $_.FullName
    [PSCustomObject]@{
        File     = $_.FullName
        Encoding = $encoding
    }
} | Format-Table -AutoSize
