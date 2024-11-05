<#
.SYNOPSIS
This script copies a new wallpaper to the Windows theme folder and provides options to refresh the desktop wallpaper without closing open File Explorer windows, or to open Explorer to the destination path.

.DESCRIPTION
The script copies a specified wallpaper image file to the Windows theme folder, including the TranscodedWallpaper directory and the CachedFiles directory. It then provides options to either refresh the desktop to apply the new wallpaper or open Windows Explorer to the destination path where the wallpaper is located.

.EXAMPLE
PS C:\> .\wallapaper_changer.ps1 -r
Copies the specified wallpaper image file to the Windows theme folder and refreshes the desktop to apply the new wallpaper.

.EXAMPLE
PS C:\> .\wallapaper_changer.ps1 -o
Copies the specified wallpaper image file to the Windows theme folder and opens Windows Explorer to the destination path where the new wallpaper is located.

.PARAMETER -nr
Do not refresh desktop after copying the new wallpaper.

.PARAMETER -o
Opens Windows Explorer to the destination path where the new wallpaper is copied. This allows users to quickly navigate to the folder containing the wallpaper.

.INPUTS
None. You cannot pipe input to this script.

.OUTPUTS
None. This script does not generate any output.

.NOTES
File Name: wallapaper_changer.ps1
Author   : K T Prajwal Prathiksh
#>

param(
    [switch]$nr, # Do not refresh desktop after copying the wallpaper
    [switch]$noCopy, # Do not copy the wallpaper, only refresh desktop
    [switch]$o  # Open Explorer to the destination path after copying the wallpaper
)

# Setup the source file path for the new wallpaper
$srcFile = "$env:USERPROFILE\Downloads\wallpaper.jpg"

# If source file does not exist, raise an error and exit
if (-not (Test-Path -Path $srcFile)) {
    Write-Host "Source file does not exist: $srcFile" -ForegroundColor Red
    Write-Host "Please create the file or specify the correct path, and try again." -ForegroundColor Red
    exit
}

# Setup the root and destination paths for the wallpaper
$rootDir = "$env:APPDATA\Microsoft\Windows\Themes"
$destDir = "$env:APPDATA\Microsoft\Windows\Themes\CachedFiles"
$transcodedWallpaperDir = "$rootDir\TranscodedWallpaper"

# Check if the destination path exists; if not, create it
if (-not (Test-Path -Path $destDir)) {
    Write-Host "Destination path does not exist, creating path $destDir"
    New-Item -Path $destDir -ItemType Directory
}

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

# Get the screen resolution
Add-Type -AssemblyName System.Windows.Forms
$height = [Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$width = [Windows.Forms.Screen]::PrimaryScreen.Bounds.Width

# Check if noCopy is not set
if (-not $noCopy) {
    # Create the destination file name
    $dest_file = "CachedImage_$width" + "_" + "$height" + "_POS4.jpg"
    Write-Host "File name: $dest_file"

    # Copy the new wallpaper to the root path
    Copy-Item -Path $srcFile -Destination "$rootDir\TranscodedWallpaper"
    Write-Host "Copied $srcFile to TranscodedWallpaper"

    # Copy the new wallpaper to the destination path
    Copy-Item -Path $srcFile -Destination "$destDir\$dest_file"
    Write-Host "Copied $srcFile to $dest_file"
}

# Refresh the wallpaper without closing Explorer windows if specified or if noCopy is true
if (-not $nr -or $noCopy) {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class CustomWallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

        public static void RefreshWallpaper(string wallpaperPath) {
            const int SPI_SETDESKWALLPAPER = 0x0014;
            const int SPIF_UPDATEINIFILE = 0x01;
            const int SPIF_SENDCHANGE = 0x02;
            SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, wallpaperPath, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
        }
    }
"@

    # Set the wallpaper path to the cached file
    $wallpaperPath = "$destDir\$dest_file"
    [CustomWallpaper]::RefreshWallpaper($wallpaperPath)
    Write-Host "Refreshed desktop wallpaper to apply the new image."
}

# Open Explorer to the destination path if specified
if ($o) {
    explorer $destDir
}

exit
