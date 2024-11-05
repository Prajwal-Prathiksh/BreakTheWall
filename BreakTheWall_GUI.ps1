Add-Type -AssemblyName System.Windows.Forms

# GUI Dimensions
$form_x = 900
$form_y = 900

$tabControl_x = 860
$tabControl_y = 860

$pictureBox_x = 300
$pictureBox_y = 200

$labelBox_x = 500
$labelBox_y = 50

$button_x = 300
$button_y = 50

$tabLeftOffset = 20

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "BreakTheWall GUI"
$form.Size = New-Object System.Drawing.Size($form_x, $form_y)
$form.StartPosition = "CenterScreen"

# Setup source paths
$srcDir = "$env:USERPROFILE\Downloads"

# Setup ps1 script paths
$updateSysParamsScript = "$PSScriptRoot\UpdateSystemParameters.ps1"
$oneTimeChangerScript = "$PSScriptRoot\OneTimeChanger.ps1"
$autoSchedulerScript = "$PSScriptRoot\SafeRunAutoScheduler.ps1"

# Check if srcDir\wallpaper.jpg exists
$srcFile = "$srcDir\wallpaper.jpg"
# Check if srcDir\custom_wallpapers directory exists
$customWallpapersDir = "$srcDir\custom_wallpapers"
$customWallpapersCount = 0
if (Test-Path -Path $customWallpapersDir) {
    $customWallpapersCount = (Get-ChildItem -Path $customWallpapersDir -Filter *.jpg).Count
}

# Create TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size($tabControl_x, $tabControl_y)
$tabControl.Location = New-Object System.Drawing.Point(10, 10)

# Create TabPages
$oneTimeTab = New-Object System.Windows.Forms.TabPage
$oneTimeTab.Text = "One-time Wallpaper Changer"
$schedulerTab = New-Object System.Windows.Forms.TabPage
$schedulerTab.Text = "Auto Scheduled Wallpaper Changer"

# Add controls to oneTimeTab
$btnOneTimeChanger = New-Object System.Windows.Forms.Button
$btnOneTimeChanger.Text = "Run One-time Wallpaper Changer"
$btnOneTimeChanger.Font = New-Object System.Drawing.Font($btnOneTimeChanger.Font, [System.Drawing.FontStyle]::Bold)
$btnOneTimeChanger.Size = New-Object System.Drawing.Size($button_x, $button_y)
$btnOneTimeChanger.Location = New-Object System.Drawing.Point($tabLeftOffset, 300)
$btnOneTimeChanger.Add_Click({
    try {
        if (!(Test-Path -Path $oneTimeChangerScript)) {
            [System.Windows.Forms.MessageBox]::Show("Script not found in the expected location: $oneTimeChangerScript")
            return
        }
        
        # Confirm that wallpaper.jpg exists
        $srcFile = "$srcDir\wallpaper.jpg"
        if (!(Test-Path -Path $srcFile)) {
            [System.Windows.Forms.MessageBox]::Show("wallpaper.jpg not found in the expected location: $srcFile")
            & $updateSysParamsScript
            $form.Dispose()
            return
        }

        # Run script
        & $oneTimeChangerScript
        [System.Windows.Forms.MessageBox]::Show("Script executed - Wallpaper changed. Bye bye!")
        & $updateSysParamsScript
        $form.Dispose()
        [System.Windows.Forms.Application]::Exit()
    } catch {
        # Display a detailed error message
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)")
    }
})

$oneTimeTab.Controls.Add($btnOneTimeChanger)

# Define and add controls to schedulerTab
$btnAutoutoScheduler = New-Object System.Windows.Forms.Button
$btnAutoutoScheduler.Text = "Run Auto Scheduled Wallpaper Changer"
$btnAutoutoScheduler.Font = New-Object System.Drawing.Font($btnAutoutoScheduler.Font, [System.Drawing.FontStyle]::Bold)
$btnAutoutoScheduler.Size = New-Object System.Drawing.Size($button_x, $button_y)
$btnAutoutoScheduler.Location = New-Object System.Drawing.Point($tabLeftOffset, 300)
$btnAutoutoScheduler.Add_Click({
    try {
        if (!(Test-Path -Path $autoSchedulerScript)) {
            [System.Windows.Forms.MessageBox]::Show("Script not found in the expected location: $autoSchedulerScript")
            return
        }
        
        # Check number of JPG files in custom_wallpapers directory is greater than 0
        if ($customWallpapersCount -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("No JPG files found in custom_wallpapers directory. Please add some images to $customWallpapersDir.")
            return
        }

        # Run script
        $interval = $txtInterval.Text
        & $autoSchedulerScript -interval $interval
        [System.Windows.Forms.MessageBox]::Show("Script executed - Auto Wallpaper changer started. Bye bye!")
        & $updateSysParamsScript
        $form.Close()
    } catch {
        # Display a detailed error message
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)")
    }
})
$schedulerTab.Controls.Add($btnAutoutoScheduler)

# Add TabPages to TabControl
$tabControl.TabPages.Add($oneTimeTab)
$tabControl.TabPages.Add($schedulerTab)

# Add TabControl to the form
$form.Controls.Add($tabControl)

### One-time Changer Tab ###
if (Test-Path -Path $srcFile) {
    $img = [System.Drawing.Image]::FromFile($srcFile)
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pictureBox.Image = $img
    $pictureBox.Size = New-Object System.Drawing.Size($pictureBox_x, $pictureBox_y)
    $pictureBox.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $oneTimeTab.Controls.Add($pictureBox)
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "wallpaper.jpg found. Click the button below to update the wallpaper."
    $lbl.ForeColor = [System.Drawing.Color]::Green
    $lbl.Font = New-Object System.Drawing.Font($lbl.Font, [System.Drawing.FontStyle]::Bold)
    $lbl.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lbl.Location = New-Object System.Drawing.Point($tabLeftOffset, 230)
    $oneTimeTab.Controls.Add($lbl)
} else {
    $lblNotFound = New-Object System.Windows.Forms.Label
    $lblNotFound.Text = "wallpaper.jpg not found. Please place wallpaper.jpg in $srcDir."
    $lblNotFound.ForeColor = [System.Drawing.Color]::Red
    $lblNotFound.Font = New-Object System.Drawing.Font($lblNotFound.Font, [System.Drawing.FontStyle]::Bold)
    $lblNotFound.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lblNotFound.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $oneTimeTab.Controls.Add($lblNotFound)
}

### Auto Changer Tab ###
if ($customWallpapersCount -gt 0) {
    $lblCustomWallpapers = New-Object System.Windows.Forms.Label
    $lblCustomWallpapers.Text = "custom_wallpapers directory found. Number of JPG files: $customWallpapersCount. Click the button below to start the Auto Wallpaper Changer."
    $lblCustomWallpapers.ForeColor = [System.Drawing.Color]::Green
    $lblCustomWallpapers.Font = New-Object System.Drawing.Font($lblCustomWallpapers.Font, [System.Drawing.FontStyle]::Bold)
    $lblCustomWallpapers.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lblCustomWallpapers.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $schedulerTab.Controls.Add($lblCustomWallpapers)

    # Add user input for interval
    $lblInterval = New-Object System.Windows.Forms.Label
    $lblInterval.Text = "Enter the interval for changing wallpapers (in seconds):"
    $lblInterval.Size = New-Object System.Drawing.Size($labelBox_x, 40)
    $lblInterval.Location = New-Object System.Drawing.Point($tabLeftOffset, 100)
    $schedulerTab.Controls.Add($lblInterval)

    $txtInterval = New-Object System.Windows.Forms.TextBox
    $txtInterval.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $txtInterval.Location = New-Object System.Drawing.Point($tabLeftOffset, 150)
    $txtInterval.Text = "3600"
    $schedulerTab.Controls.Add($txtInterval)

} else {
    $lblCustomWallpapersNotFound = New-Object System.Windows.Forms.Label
    $lblCustomWallpapersNotFound.Text = "custom_wallpapers directory not found. Please create custom_wallpapers directory in $srcDir and place some JPG files in it."
    $lblCustomWallpapersNotFound.ForeColor = [System.Drawing.Color]::Red
    $lblCustomWallpapersNotFound.Font = New-Object System.Drawing.Font($lblCustomWallpapersNotFound.Font, [System.Drawing.FontStyle]::Bold)
    $lblCustomWallpapersNotFound.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lblCustomWallpapersNotFound.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $schedulerTab.Controls.Add($lblCustomWallpapersNotFound)
}


# Show the form
$form.ShowDialog()