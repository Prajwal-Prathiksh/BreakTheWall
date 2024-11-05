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

# Create TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size($tabControl_x, $tabControl_y)
$tabControl.Location = New-Object System.Drawing.Point(10, 10)

# Create TabPages
$oneTimeTab = New-Object System.Windows.Forms.TabPage
$oneTimeTab.Text = "One-time Changer"
$schedulerTab = New-Object System.Windows.Forms.TabPage
$schedulerTab.Text = "Auto Changer"

# Add controls to oneTimeTab
$btnBreakTheWall = New-Object System.Windows.Forms.Button
$btnBreakTheWall.Text = "Break The Wall"
$btnBreakTheWall.Font = New-Object System.Drawing.Font($btnBreakTheWall.Font, [System.Drawing.FontStyle]::Bold)
$btnBreakTheWall.Size = New-Object System.Drawing.Size($button_x, $button_y)
$btnBreakTheWall.Location = New-Object System.Drawing.Point($tabLeftOffset, 300)
$btnBreakTheWall.Add_Click({
    try {
        # Confirm that the BreakTheWall.ps1 script exists
        $scriptPath = "$PSScriptRoot\BreakTheWall.ps1"
        if (!(Test-Path -Path $scriptPath)) {
            [System.Windows.Forms.MessageBox]::Show("BreakTheWall.ps1 script not found in the expected location: $scriptPath")
            return
        }
        
        # Confirm that wallpaper.jpg exists
        $srcFile = "$srcDir\wallpaper.jpg" # Ensure $srcFile is defined
        if (!(Test-Path -Path $srcFile)) {
            [System.Windows.Forms.MessageBox]::Show("wallpaper.jpg not found in the expected location: $srcFile")
            return
        }

        # Run the BreakTheWall script
        & $scriptPath
        [System.Windows.Forms.MessageBox]::Show("BreakTheWall.ps1 executed - Wallpaper changed. Bye bye!")
        $form.Close()
    } catch {
        # Display a detailed error message
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)")
    }
})

$oneTimeTab.Controls.Add($btnBreakTheWall)

# Define and add controls to schedulerTab
$btnAutoBreakTheWall = New-Object System.Windows.Forms.Button
$btnAutoBreakTheWall.Text = "Auto Break The Wall"
$btnAutoBreakTheWall.Font = New-Object System.Drawing.Font($btnAutoBreakTheWall.Font, [System.Drawing.FontStyle]::Bold)
$btnAutoBreakTheWall.Size = New-Object System.Drawing.Size($button_x, $button_y)
$btnAutoBreakTheWall.Location = New-Object System.Drawing.Point($tabLeftOffset, 300)
$btnAutoBreakTheWall.Add_Click({
    try {
        # Confirm that the RestartAutoBreakTheWall.ps1 script exists
        $scriptPath = "$PSScriptRoot\RestartAutoBreakTheWall.ps1"
        if (!(Test-Path -Path $scriptPath)) {
            [System.Windows.Forms.MessageBox]::Show("RestartAutoBreakTheWall.ps1 script not found in the expected location: $scriptPath")
            return
        }
        
        # Confirm that custom_wallpapers directory exists
        $customWallpapersDir = "$srcDir\custom_wallpapers"
        if (!(Test-Path -Path $customWallpapersDir)) {
            [System.Windows.Forms.MessageBox]::Show("custom_wallpapers directory not found in the expected location: $customWallpapersDir")
            return
        }

        # Run the RestartAutoBreakTheWall.ps1 script
        & $scriptPath
        [System.Windows.Forms.MessageBox]::Show("AutoBreakTheWall.ps1 is running. Bye bye!")
        $form.Close()
    } catch {
        # Display a detailed error message
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)")
    }
})
$schedulerTab.Controls.Add($btnAutoBreakTheWall)

# Add TabPages to TabControl
$tabControl.TabPages.Add($oneTimeTab)
$tabControl.TabPages.Add($schedulerTab)

# Add TabControl to the form
$form.Controls.Add($tabControl)

### One-time Changer Tab ###
# Check if srcDir\wallpaper.jpg exists
$srcFile = "$srcDir\wallpaper.jpg"
if (Test-Path -Path $srcFile) {
    $img = [System.Drawing.Image]::FromFile($srcFile)
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $pictureBox.Image = $img
    $pictureBox.Size = New-Object System.Drawing.Size($pictureBox_x, $pictureBox_y)
    $pictureBox.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $oneTimeTab.Controls.Add($pictureBox)
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "wallpaper.jpg found. BreakTheWall.ps1 will use this image."
    $lbl.ForeColor = [System.Drawing.Color]::Green
    $lbl.Font = New-Object System.Drawing.Font($lbl.Font, [System.Drawing.FontStyle]::Bold)
    $lbl.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lbl.Location = New-Object System.Drawing.Point($tabLeftOffset, 230)
    $oneTimeTab.Controls.Add($lbl)
} else {
    $lblNotFound = New-Object System.Windows.Forms.Label
    $lblNotFound.Text = "wallpaper.jpg not found. Cannot run BreakTheWall.ps1. Please download wallpaper.jpg to $srcDir."
    $lblNotFound.ForeColor = [System.Drawing.Color]::Red
    $lblNotFound.Font = New-Object System.Drawing.Font($lblNotFound.Font, [System.Drawing.FontStyle]::Bold)
    $lblNotFound.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lblNotFound.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $oneTimeTab.Controls.Add($lblNotFound)
}

### Auto Changer Tab ###
# Check if srcDir\custom_wallpapers directory exists
$customWallpapersDir = "$srcDir\custom_wallpapers"
$customWallpapersCount = 0
if (Test-Path -Path $customWallpapersDir) {
    $customWallpapersCount = (Get-ChildItem -Path $customWallpapersDir -Filter *.jpg).Count
}

if ($customWallpapersCount -gt 0) {
    $lblCustomWallpapers = New-Object System.Windows.Forms.Label
    $lblCustomWallpapers.Text = "custom_wallpapers directory found. Number of JPG files: $customWallpapersCount. AutoBreakTheWall.ps1 will use these images."
    $lblCustomWallpapers.ForeColor = [System.Drawing.Color]::Green
    $lblCustomWallpapers.Font = New-Object System.Drawing.Font($lblCustomWallpapers.Font, [System.Drawing.FontStyle]::Bold)
    $lblCustomWallpapers.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lblCustomWallpapers.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $schedulerTab.Controls.Add($lblCustomWallpapers)
} else {
    $lblCustomWallpapersNotFound = New-Object System.Windows.Forms.Label
    $lblCustomWallpapersNotFound.Text = "custom_wallpapers directory not found. Cannot run Auto BreakTheWall.ps1. Please create custom_wallpapers directory in $srcDir."
    $lblCustomWallpapersNotFound.ForeColor = [System.Drawing.Color]::Red
    $lblCustomWallpapersNotFound.Font = New-Object System.Drawing.Font($lblCustomWallpapersNotFound.Font, [System.Drawing.FontStyle]::Bold)
    $lblCustomWallpapersNotFound.Size = New-Object System.Drawing.Size($labelBox_x, $labelBox_y)
    $lblCustomWallpapersNotFound.Location = New-Object System.Drawing.Point($tabLeftOffset, 20)
    $schedulerTab.Controls.Add($lblCustomWallpapersNotFound)
}


# Show the form
$form.ShowDialog()