# Path to your INI file
$iniPath = "C:\Path\To\yourfile.ini"
# Default credentials
$defaultUsername = "username"
$defaultPassword = "password"

# Read all lines from the INI file
$lines = Get-Content $iniPath

$currentSection = ""
$sectionData = @{}

foreach ($line in $lines) {
    $line = $line.Trim()
    if ($line -match "^\[(.+)\]$") {
        $currentSection = $matches[1]
        $sectionData[$currentSection] = @()
    } elseif ($line -match "^(.*?)=(.*?)$" -and $currentSection) {
        $machineKey = $matches[1].Trim()
        $sectionData[$currentSection] += @{
            Machine  = $machineKey
            Username = $defaultUsername
            Password = $defaultPassword
        }
    }
}

# Output each section to a separate JSON file
foreach ($section in $sectionData.Keys) {
    $json = $sectionData[$section] | ConvertTo-Json -Depth 3
    $jsonPath = "C:\Path\To\Output\$section.json"
    $json | Set-Content -Path $jsonPath -Encoding UTF8
}
