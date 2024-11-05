# Check if `wscript.exe` is running, if yes, kill it.
$process = Get-Process -Name wscript -ErrorAction SilentlyContinue
if ($process) {
    Stop-Process -Name wscript -Force
    Write-Host "wscript.exe is killed."
} else {
    Write-Host "wscript.exe is not running."
}

# Run the AutoBreakTheWall.vbs script
$vsbFile = "$PSScriptRoot\AutoBreakTheWall.vbs"
Start-Process -FilePath $vsbFile -WindowStyle Hidden
Write-Host "AutoBreakTheWall.vbs is running."