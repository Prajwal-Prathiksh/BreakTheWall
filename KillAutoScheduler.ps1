<#
.SYNOPSIS
Checks if the `wscript.exe` process is running and terminates it if found.

.DESCRIPTION
This script checks for the presence of the `wscript.exe` process. If the process is running, it will be forcefully terminated. If the process is not running, a message will be displayed indicating that `wscript.exe` is not running.

.NOTES
Filepath: /c:/Users/40108353/OneDrive - Anheuser-Busch InBev/prajwal_abi/oss-projects/BreakTheWall/KillAutoScheduler.ps1

.EXAMPLE
PS> .\KillAutoScheduler.ps1
wscript.exe is killed.

.EXAMPLE
PS> .\KillAutoScheduler.ps1
wscript.exe is not running.
#>
# Check if `wscript.exe` is running, if yes, kill it.
$process = Get-Process -Name wscript -ErrorAction SilentlyContinue
if ($process) {
    Stop-Process -Name wscript -Force
    Write-Host "wscript.exe is killed."
} else {
    Write-Host "wscript.exe is not running."
}