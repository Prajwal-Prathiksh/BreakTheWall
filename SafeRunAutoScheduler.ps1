<#
.SYNOPSIS
This script manages the execution of the AutoScheduler.vbs script with a specified interval.

.DESCRIPTION
The script performs the following tasks:
1. Checks if `wscript.exe` is running and terminates it if found.
2. Updates the interval in the AutoScheduler.vbs script.
3. Executes the AutoScheduler.vbs script with the updated interval.

.PARAMETER interval
The interval in seconds for the AutoScheduler.vbs script. Default is 3600 seconds (1 hour).

.EXAMPLE
.\SafeRunAutoScheduler.ps1 -interval 1800
This example sets the interval to 1800 seconds (30 minutes) and runs the AutoScheduler.vbs script.

.NOTES
- Ensure that the AutoScheduler.vbs script is located in the same directory as this script.
- The script requires appropriate permissions to stop processes and modify files.

#>
param(
    [string]$interval = "3600" # Default interval is 1 hour
)

# Check if `wscript.exe` is running, if yes, kill it.
$process = Get-Process -Name wscript -ErrorAction SilentlyContinue
if ($process) {
    Stop-Process -Name wscript -Force
    Write-Host "wscript.exe is killed."
} else {
    Write-Host "wscript.exe is not running."
}

$vsbFile = "$PSScriptRoot\AutoScheduler.vbs"
# Replace the interval in the AutoScheduler.vbs script
(Get-Content $vsbFile) | ForEach-Object { $_ -replace "interval = \d+", "interval = $interval" } | Set-Content $vsbFile
Write-Host "Interval is set to $interval seconds."

# Run the AutoBreakTheWall.vbs script
Start-Process -FilePath $vsbFile -WindowStyle Hidden
Write-Host "AutoScheduler.vbs is running."