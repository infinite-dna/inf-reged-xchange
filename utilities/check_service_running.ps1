# Configuration
$iniPath = "C:\Path\To\machines.ini"  # Change to your actual path
$sectionToRun = "section1"            # Change as needed
$serviceName = "wuauserv"             # Service to check

# Parse INI file function
function Get-IniSection {
    param (
        [string]$Path,
        [string]$Section
    )

    $inSection = $false
    $machines = @()

    foreach ($line in Get-Content $Path) {
        $line = $line.Trim()

        if ($line -match "^\[(.+?)\]$") {
            $inSection = ($matches[1] -ieq $Section)
        }
        elseif ($inSection -and $line -match "^\s*(.+?)\s*=\s*(.+?)\s*$") {
            $machines += $matches[2]
        }
    }

    return $machines
}

# Main logic
$machines = Get-IniSection -Path $iniPath -Section $sectionToRun

foreach ($machine in $machines) {
    Write-Host "`nChecking $serviceName on $machine..."

    if (Test-Connection -ComputerName $machine -Count 1 -Quiet) {
        try {
            $status = Invoke-Command -ComputerName $machine -ScriptBlock {
                param($svc) (Get-Service -Name $svc -ErrorAction Stop).Status
            } -ArgumentList $serviceName

            Write-Host "Service status on $machine: $status"
        }
        catch {
            Write-Host "Error checking service on $machine: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Cannot reach $machine." -ForegroundColor Yellow
    }
}
