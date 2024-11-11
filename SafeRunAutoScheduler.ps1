<#
.SYNOPSIS
This script sets up and runs the AutoScheduler with a specified interval.

.DESCRIPTION
The script performs the following tasks:
1. Runs a script to kill any existing AutoScheduler process.
2. Updates the interval in the AutoScheduler.vbs script.
3. Starts the AutoScheduler.vbs script with the specified interval.

.PARAMETER interval
The interval in seconds at which the AutoScheduler should run. Default is 3600 seconds (1 hour).

.EXAMPLE
.\SafeRunAutoScheduler.ps1 -interval 1800
This example sets the interval to 1800 seconds (30 minutes) and runs the AutoScheduler.

.NOTES
The script assumes that the KillAutoScheduler.ps1 and AutoScheduler.vbs scripts are located in the same directory as this script.

#>
param(
    [string]$interval = "3600" # Default interval is 1 hour
)

# Setup ps1 script path
$killAutoSchedulerScript = "$PSScriptRoot\KillAutoScheduler.ps1"

# Run the script to kill the AutoScheduler process
& $killAutoSchedulerScript

$vsbFile = "$PSScriptRoot\AutoScheduler.vbs"
# Replace the interval in the AutoScheduler.vbs script
(Get-Content $vsbFile) | ForEach-Object { $_ -replace "interval = \d+", "interval = $interval" } | Set-Content $vsbFile
Write-Host "Interval is set to $interval seconds."

# Run the AutoBreakTheWall.vbs script
Start-Process -FilePath $vsbFile -WindowStyle Hidden
Write-Host "AutoScheduler.vbs is running."