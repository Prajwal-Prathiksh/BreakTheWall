# BreakTheWall
Stuck with a **mandatory workplace wallpaper** on your Windows laptop that you’d love to replace?

This repo offers a loophole to personalize your desktop background, allowing you to choose your wallpaper while keeping within policy boundaries and without needing admin rights! **Yaay 🎉**

*Say goodbye to the default and make your workspace truly yours! :")*

## Additional Info
- The scripts are designed to be run on Windows machines only, and have been tested to work on Windows 10 & 11.
- The scripts are written in `PowerShell` and `VBScript`, and hence require no additional software installations.
- The scripts are also designed to be non-intrusive and can be easily removed by simply deleting the entire repository from your system.

# Usage
## Clone Repository
To get started, you can clone this repository to your local machine by running the following command in your terminal:
```bash
git clone https://github.com/Prajwal-Prathiksh/BreakTheWall.git
```

If you don't have `git` installed, you can download the zip file and extract it to your desired location. *(If this is the first time you're working with `PowerShell` scripts, save and extract the repository in your `Downloads` directory, to simplify the process.)*


## GUI Mode (Recommended)
To change your wallpaper using the GUI, you can follow these steps:
1. Save the image/images as per instructions in the [One-time Change](#one-time-change) or [Scheduled Change](#scheduled-change) sections.
1. **[Optional]** You can update the interval between wallpaper changes from the GUI itself. **By default, the interval is set to 1 hour.**
1. Run the [`BreakTheWall_GUI.ps1`](BreakTheWall_GUI.ps1) script by right-clicking on it and selecting `Run with PowerShell`. *(For pro-users, you can also run it from the `PowerShell` terminal, but make sure to navigate to the script's location first.)*

## One-time Change
You can use the [`Utils/OneTimeChanger.ps1`](Utils/OneTimeChanger.ps1) script to change your wallpaper to a custom one, as a one-time change. Here's how you can do it:
1. Store your desired wallpaper as `wallpaper.jpg` in the `Downloads` directory
> The script currently supports only `.jpg` files. If you have a different format, you can convert it to `.jpg` using an online converter, and the name must follow the format `wallpaper.jpg`.

> If you're unsure about the location of `Downloads` directory, you can find it opening `File Explorer` and typing `%USERPROFILE%\Downloads` in the address bar.
1. Run the `Utils/OneTimeChanger.ps1` script.

**That's it! Your wallpaper should now be updated to the one you saved! <3**
> Upon restarting your system or changing monitors, the wallpaper might revert to the default one. In such cases, you can re-run the steps above to update it again.

## Scheduled Change
You can use the [`Utils/SafeRunAutoScheduler.ps1`](Utils/SafeRunAutoScheduler.ps1) script to keep changing your wallpapers at regular intervals automatically, from a set of saved wallpapers. Here's how you can do it:
1. Create a new folder named `custom_wallpapers` in the `Downloads` directory (Eg. `%USERPROFILE%\Downloads\custom_wallpapers`).
1. Store all the wallpapers you want to cycle through in the `custom_wallpapers` folder. **As mentioned before, the files must be in `.jpg` format only, but can have any name.**
1. **[Optional]** If you want to change the interval between wallpaper changes, you can modify the `AutoScheduler.vbs` script. **By default, the interval is set to 1 hour.**
2. Run the `Utils/SafeRunAutoScheduler.ps1` script.

**That's it! Your wallpapers will now change automatically at the set interval! <3**
> A log file named `wallpaper_refresh.log` will be created in the root directory of the repository, which will contain the timestamps of each wallpaper change. This can be used to verify the script's working or to debug any issues.

> You can stop the script at any time by opening the `Task Manager` and ending the `Microsoft Windows Based Script Host` process.

## Reset to Default Wallpaper
If it ever becomes necessary for you to revert to the default wallpaper :"(, you can use the [`Utils/ResetWallpaper.ps1`](Utils/ResetWallpaper.ps1) script to do so. Here's how you can do it:
1. Run the `Utils/ResetWallpaper.ps1` script.

**That's it! Your wallpaper should now be updated to the default one .... :"(**


## Run scripts on Startup
If you want the scripts to run automatically every time you start your system, you can follow these steps:
1. In the directory where you cloned the repository, right-click on the `AutoScheduler.vbs` script and select `Create Shortcut`.
1. Press `Win + R` to open the `Run` dialog box and type `shell:startup` to open the `Startup` folder.
1. Move the shortcut you created in step 1 to the `Startup` folder.
1. Open `Task Manager` and navigate to the `Startup` tab to verify that the script has been added to the startup programs, and is `Enabled`.
