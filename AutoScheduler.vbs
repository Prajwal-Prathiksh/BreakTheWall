' This script periodically changes the desktop wallpaper to a random image from a specified folder.
' It logs its actions to a log file and ensures the wallpaper is updated correctly.
' 
' Variables:
'   interval - Time interval in seconds between wallpaper changes.
'   logFile - Path to the log file where script actions are recorded.
'   fso - FileSystemObject for file operations.
'   logStream - Stream object for writing to the log file.
'   rootDir - Root directory for theme-related files.
'   destDir - Directory where cached wallpaper files are stored.
'   transcodedWallpaperPath - Path to the current transcoded wallpaper file.
'   srcPath - Source directory containing custom wallpapers.
'
' Functions:
'   LogMessage(message) - Logs a message with a timestamp to the log file.
'
' Main Loop:
'   - Checks if the destination path exists and creates it if necessary.
'   - Deletes the current transcoded wallpaper and all files in the destination path.
'   - Checks if the source path exists and creates it if necessary.
'   - Selects a random .jpg file from the source path.
'   - Copies the selected wallpaper to the transcoded wallpaper path and the destination path.
'   - Runs a PowerShell script to refresh the desktop wallpaper.
'   - Waits for the specified interval before repeating the process.
Option Explicit

Dim interval, logFile, fso, logStream, rootDir, destDir, transcodedWallpaperPath, srcPath

' Time interval in seconds
interval = 3600
logFile = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & "\wallpaper_refresh.log"

Set fso = CreateObject("Scripting.FileSystemObject")

' If log file exists, delete it
If fso.FileExists(logFile) Then
    fso.DeleteFile logFile
End If

' Function to log messages to the log file
Sub LogMessage(message)
    Dim timestamp
    timestamp = Now
    Set logStream = fso.OpenTextFile(logFile, 8, True)
    logStream.WriteLine timestamp & " - " & message
    logStream.Close
End Sub

' Log initial message
LogMessage "Script started."
LogMessage "Background job started."

' Setup source path for custom wallpapers
srcPath = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%USERPROFILE%") & "\Downloads\custom_wallpapers"

' Setup the root and destination paths for the wallpaper
rootDir = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%APPDATA%") & "\Microsoft\Windows\Themes"
destDir = rootDir & "\CachedFiles"
transcodedWallpaperPath = rootDir & "\TranscodedWallpaper"

Do While True
    On Error Resume Next
    ' Check if the destination path exists; if not, create it
    If Not fso.FolderExists(destDir) Then
        LogMessage "Destination path does not exist, creating path " & destDir
        fso.CreateFolder destDir
    End If

    ' Remove the old transcoded wallpaper
    If fso.FileExists(transcodedWallpaperPath) Then
        fso.DeleteFile transcodedWallpaperPath, True
        LogMessage "Removed " & transcodedWallpaperPath
    End If

    ' Remove all files in the destination path
    Dim file
    For Each file In fso.GetFolder(destDir).Files
        fso.DeleteFile file.Path, True
    Next
    LogMessage "Removed all files in " & destDir

    ' Check if the source path exists
    If Not fso.FolderExists(srcPath) Then
        LogMessage "Source path " & srcPath & " does not exist."
        fso.CreateFolder srcPath
        WScript.Sleep interval * 1000
        WScript.Quit
    End If

    ' Get the list of files ending with .jpg in the source path
    Dim files, fileList, randomIndex
    Set files = fso.GetFolder(srcPath).Files
    fileList = ""
    For Each file In files
        If LCase(fso.GetExtensionName(file.Name)) = "jpg" Then
            fileList = fileList & file.Path & vbCrLf
        End If
    Next

    If fileList = "" Then
        LogMessage "No .jpg files found in " & srcPath
        WScript.Sleep interval * 1000
        WScript.Quit
    End If

    ' Pick one file randomly from the list
    Dim fileArray
    fileArray = Split(fileList, vbCrLf)
    Randomize
    randomIndex = Int((UBound(fileArray) - LBound(fileArray) + 1) * Rnd + LBound(fileArray))
    Dim srcFile
    srcFile = fileArray(randomIndex)
    LogMessage "Selected wallpaper: " & srcFile

    ' Create the destination file name
    Dim destFile
    destFile = "CachedImage_1920_1080_POS4.jpg"

    LogMessage "Starting wallpaper copy process."
    ' Copy the new wallpaper to the root path
    fso.CopyFile srcFile, transcodedWallpaperPath
    LogMessage "Copied " & srcFile & " to TranscodedWallpaper"

    ' Copy the new wallpaper to the destination path
    fso.CopyFile srcFile, destDir & "\" & destFile
    LogMessage "Copied " & srcFile & " to " & destFile

    ' Sleep for 2 seconds to allow the file copy to complete
    WScript.Sleep 2000

    ' Run UpdateSystemParameters.ps1 code for refreshing wallpaper
    Dim tempPSPath
    tempPSPath = fso.GetParentFolderName(WScript.ScriptFullName) & "\UpdateSystemParameters.ps1"
    CreateObject("WScript.Shell").Run "powershell -File " & Chr(34) & tempPSPath & Chr(34), 0, True
    LogMessage "Refreshed desktop wallpaper to apply the new image."

    ' Wait for the interval before repeating
    LogMessage "Sleeping for " & interval & " seconds."
    WScript.Sleep interval * 1000
Loop
