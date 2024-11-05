# BreakTheWall
Stuck with a **mandatory workplace wallpaper** on your Windows laptop that you’d love to replace?

This repo offers a loophole to personalize your desktop background, allowing you to choose your wallpaper while keeping within policy boundaries and without needing admin rights! **Yaay 🎉**

*Say goodbye to the default and make your workspace truly yours! :")*

## Usage (One-time Change)
You can use the `BreakTheWall.ps1` script to change your wallpaper to a custom one, as a one-time change. Here's how you can do it:
1. Clone this repository to your local machine. If you don't have git installed, you can download the zip file and extract it. *(If this is the first time you're working with `PowerShell` scripts, save the script in your `Documents` directory.)*
1. Store your desired wallpaper as `wallpaper.jpg` in the `Downloads` directory
> The script currently supports only `.jpg` files. If you have a different format, you can convert it to `.jpg` using an online converter, and the name must follow the format `wallpaper.jpg`.

> If you're unsure about the location of `Downloads` directory, you can find it opening `File Explorer` and typing `%USERPROFILE%\Downloads` in the address bar.
1. Run the `BreakTheWall.ps1` script by right-clicking on it and selecting `Run with PowerShell`. (For pro-users, you can also run it from the `PowerShell` terminal, but make sure to navigate to the script's location first.)

**That's it! Your wallpaper should now be updated to the one you saved! <3**
> Upon restarting your system or changing monitors, the wallpaper might revert to the default one. In such cases, you can re-run the steps above to update it again.

## Usage (Scheduled Change)
You can use the `AutoBreakTheWall.vbs` script to keep changing your wallpapers at regular intervals automatically, from a set of saved wallpapers. Here's how you can do it:
1. Same as above, clone this repository to your local machine or download the zip file and extract it.
1. Create a new folder named `custom_wallpapers` in the `Downloads` directory (Eg. `%USERPROFILE%\Downloads\custom_wallpapers`).
1. Store all the wallpapers you want to cycle through in the `custom_wallpapers` folder. **As mentioned before, the files must be in `.jpg` format only, but can have any name.**
1. **[Optional]** If you want to change the interval between wallpaper changes, you can modify the `AutoBreakTheWall.vbs` script. **By default, the interval is set to 1 hour.**
1. Run the `AutoBreakTheWall.vbs` script by double-clicking on it. This will start the script and change your wallpaper at the set interval.

**That's it! Your wallpapers will now change automatically at the set interval! <3**
> A log file named `wallpaper_refresh.log` will be created in the root directory of the repository, which will contain the timestamps of each wallpaper change. This can be used to verify the script's working or to debug any issues.

> Once the script has started, if you wish to change the interval, you must first stop the script and then modify the interval in the script before restarting it.

> You can stop the script at any time by opening the `Task Manager` and ending the `Microsoft Windows Based Script Host` process.



## Additional Info
- The scripts are designed to be run on Windows machines only. They have been tested on Windows 10 and work as expected. **No guarantees for other versions.**
- The scripts are also designed to be non-intrusive and can be easily removed by deleting the cloned repository.

