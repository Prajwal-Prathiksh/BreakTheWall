# Set the interval for the loop
$interval = 10 # Time interval in seconds
$logFile = "$PSScriptRoot\wallpaper_refresh.log"

# Define the script block to copy the wallpaper and reload the desktop
$scriptBlock = {
    param (
        [string]$logFile,
        [int]$interval
    )

    # Function to log messages to the log file
    function Log-Message {
        param (
            [string]$message,
            [string]$logFile
        )
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp - $message" | Out-File -FilePath $logFile -Append
    }

    # Log initial message inside the script block
    Log-Message "Script started." $logFile
    Log-Message "Background job started." $logFile

    # Setup the source and destination paths
    $srcFile = "$env:USERPROFILE\Downloads\wallpaper.jpg"
    $destPath = "$env:APPDATA\Microsoft\Windows\Themes"
    $transcodedWallpaper = "$destPath\TranscodedWallpaper"
    $cachedFilesPath = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles"

    while ($true) {
        try {
            Log-Message "Starting wallpaper copy process." $logFile
    
            # Copy the wallpaper to the destination paths
            Copy-Item -Path $srcFile -Destination $transcodedWallpaper -Force
            Copy-Item -Path $srcFile -Destination $cachedFilesPath -Force
            Log-Message "Copied wallpaper to $transcodedWallpaper and $cachedFilesPath." $logFile
    
            # Refresh the desktop to apply the new wallpaper
            RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
            Log-Message "Refreshed desktop wallpaper to apply the new image." $logFile
    
        } catch {
            Log-Message "Error occurred: $_" $logFile
        }
    
        # Wait for the interval before repeating
        Log-Message "Sleeping for $interval seconds." $logFile
        Start-Sleep -Seconds $interval
    }
}

# Start the script block as a background job
Start-Job -ScriptBlock $scriptBlock -Name "WallpaperRefreshJob" -ArgumentList $logFile, $interval

# Retrieve the job output and errors
Receive-Job -Name "WallpaperRefreshJob" -Keep