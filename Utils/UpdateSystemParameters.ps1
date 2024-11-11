<#
.SYNOPSIS
    This script changes the system parameters using the User32.dll library.

.DESCRIPTION
    The script defines a class `User32` with a method `SystemParametersInfo` that calls the corresponding function from the User32.dll library.
    It then calls this method to change system parameters and updates the user-specific system parameters.

.NOTES
    The script uses the `Add-Type` cmdlet to define a new class in PowerShell.
    The `SystemParametersInfo` method is used to change system parameters.
    The `RUNDLL32.EXE` command is used to update the user-specific system parameters.

.PARAMETER uAction
    Specifies the system-wide parameter to be retrieved or set.

.PARAMETER uParam
    A parameter whose usage and format depends on the system parameter being queried or set.

.PARAMETER lpvParam
    A parameter whose usage and format depends on the system parameter being queried or set.

.PARAMETER fuWinIni
    If a system parameter is being set, specifies whether the user profile is to be updated, and if so, whether the `WM_SETTINGCHANGE` message is to be broadcast to all top-level windows.

.EXAMPLE
    [User32]::SystemParametersInfo(0x0014, 0, $null, 0x0001)
    This example changes the system parameter specified by the action code `0x0014`.

.EXAMPLE
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
    This example updates the user-specific system parameters.
#>
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class User32 {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[User32]::SystemParametersInfo(0x0014, 0, $null, 0x0001)

RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters