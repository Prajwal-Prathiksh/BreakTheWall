<#
.SYNOPSIS
Resets the desktop wallpaper by removing the current transcoded wallpaper and cached files.

.DESCRIPTION
This script removes the current transcoded wallpaper and all cached wallpaper files from the specified directories. 
It then calls another script to refresh the system parameters and reset the wallpaper.

.PARAMETER rootDir
The root directory where the transcoded wallpaper is stored.

.PARAMETER destDir
The destination directory where cached wallpaper files are stored.

.PARAMETER transcodedWallpaperDir
The directory of the current transcoded wallpaper.

.NOTES
The script uses environment variables to determine the paths for the root and destination directories.

.EXAMPLE
.\ResetWallpaper.ps1
This command runs the script to reset the desktop wallpaper.
#>
# Setup the root and destination paths for the wallpaper
$rootDir = "$env:APPDATA\Microsoft\Windows\Themes"
$destDir = "$env:APPDATA\Microsoft\Windows\Themes\CachedFiles"
$transcodedWallpaperDir = "$rootDir\TranscodedWallpaper"

# Remove the old transcoded wallpaper
if (Test-Path -Path $transcodedWallpaperDir) {
    Remove-Item -Path $transcodedWallpaperDir -Force
    Write-Host "Removed $transcodedWallpaperDir"
}

# Remove all files in the destination path
$files = Get-ChildItem -Path $destDir -File
foreach ($file in $files) {
    Remove-Item -Path $file.FullName -Force
}
Write-Host "Removed all files in $destDir"

# Refresh the system parameters to reset the wallpaper
Start-Sleep -Seconds 2
.\UpdateSystemParameters.ps1
Write-Host "Refreshed desktop to reset wallpaper."