# Set the interval for the loop
$interval = 30 # Time interval in seconds
$logFile = "$PSScriptRoot\wallpaper_refresh.log"

# If log file exists, delete it
if (Test-Path $logFile) {
    Remove-Item $logFile
}

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

    # Setup the root and destination paths for the wallpaper
    $rootDir = "$env:APPDATA\Microsoft\Windows\Themes"
    $destDir = "$env:APPDATA\Microsoft\Windows\Themes\CachedFiles"
    $transcodedWallpaperDir = "$rootDir\TranscodedWallpaper"
    
    # Check if the destination path exists; if not, create it
    if (-not (Test-Path -Path $destDir)) {
        Log-Message "Destination path does not exist, creating path $destDir" $logFile
        New-Item -Path $destDir -ItemType Directory
    }

    # Remove the old transcoded wallpaper
    if (Test-Path -Path $transcodedWallpaperDir) {
        Remove-Item -Path $transcodedWallpaperDir -Force
        Log-Message "Removed $transcodedWallpaperDir" $logFile
    }

    # Remove all files in the destination path
    $files = Get-ChildItem -Path $destDir -File
    foreach ($file in $files) {
        Remove-Item -Path $file.FullName -Force
    }
    Log-Message "Removed all files in $destDir" $logFile
    
    while ($true) {
        try {
            $srcPath = "$env:USERPROFILE\Downloads\custom_wallpapers"
            # Check if the source path exists
            if (-not (Test-Path $srcPath)) {
                Log-Message "Source path $srcPath does not exist." $logFile
                New-Item -Path $srcPath -ItemType Directory
                return
            }
            
            # Get the list of files ending with .jpg in the source path
            $files = Get-ChildItem -Path $srcPath -Filter "*.jpg" | Select-Object -ExpandProperty FullName

            # Pick one file randomly from the list
            $srcFile = Get-Random -InputObject $files
            Log-Message "Selected wallpaper: $srcFile" $logFile

            # Get the screen resolution
            Add-Type -AssemblyName System.Windows.Forms
            $height = [Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
            $width = [Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
            # Create the destination file name
            $dest_file = "CachedImage_$width" + "_" + "$height" + "_POS4.jpg"

            Log-Message "Starting wallpaper copy process." $logFile
            # Copy the new wallpaper to the root path
            Copy-Item -Path $srcFile -Destination "$rootDir\TranscodedWallpaper"
            Log-Message "Copied $srcFile to TranscodedWallpaper" $logFile

            # Copy the new wallpaper to the destination path
            Copy-Item -Path $srcFile -Destination "$destDir\$dest_file"
            Log-Message "Copied $srcFile to $dest_file" $logFile
    
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