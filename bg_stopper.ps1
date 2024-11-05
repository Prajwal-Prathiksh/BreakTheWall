# Get JobID of "WallpaperRefreshJob", stop it and remove it
try {
    $jobDetails = Get-Job -Name "WallpaperRefreshJob" -ErrorAction SilentlyContinue
    # Check if job exists
    if ($jobDetails) {
        # Stop the job
        Stop-Job -Id $jobDetails.Id
        # Remove the job
        Remove-Job -Id $jobDetails.Id

        Write-Host "Background job stopped."
    } else {
        Write-Host "No background job found."
    }
} catch {
    Write-Host "An error occurred while trying to stop the background job."
}