# Remove Win10 Apps Utility

Customisable Windows 10 app removal utility

``` txt
888 88e                                                    Y8b Y8b Y888P ,e,           d88   e88 88e
888 888D  ,e e,  888 888 8e   e88 88e  Y8b Y888P  ,e e,     Y8b Y8b Y8P      888 8e   d888  d888 888b
888 88   d88 88b 888 888 88b d888 888b  Y8b Y8P  d88 88b     Y8b Y8b Y   888 888 88b d 888 C8888 8888D
888 b,   888   , 888 888 888 Y888 888P   Y8b     888   ,      Y8b Y8b    888 888 888   888  Y888 888P
888 88b,   YeeP  888 888 888   88 88      Y8P      YeeP        Y8P Y     888 888 888   888    88 88

    e Y8b                               8888 8888   d8   ,e, 888 ,e,   d8
   d8b Y8b    888 88e  888 88e   dP Y   8888 8888  d88       888      d88   Y8b Y888P
  d888b Y8b   888 888b 888 888b C88b    8888 8888 d88888 888 888 888 d88888  Y8b Y8P
 d888888888b  888 888P 888 888P  Y88D   8888 8888  888   888 888 888  888     Y8b Y    Mike Galvin
d8888888b Y8b 888 88   888 88   d,dP    'Y88 88P'  888   888 888 888  888      888   https://gal.vin
              888      888                                                     888
              888      888                   Version 20.03.20 (⌐■_■)           888
```

For full instructions and documentation, [visit my site.](https://gal.vin/2019/12/04/remove-uwp-apps)

Please consider supporting my work:

* Sign up [using Patreon.](https://www.patreon.com/mikegalvin)
* Support with a one-time payment [using PayPal.](https://www.paypal.me/digressive)

Remove Win10 Apps Utility can also be downloaded from:

* [The Microsoft PowerShell Gallery](https://www.powershellgallery.com/packages/Remove-Win10-Apps)

Tweet me if you have questions: [@mikegalvin_](https://twitter.com/mikegalvin_)

-Mike

## Features and Requirements

* The utility will remove specified built-in apps for the current logged on user.
* The utility will remove specified provisioned built-in apps from the system.
* This utility can be used for imaging and OS deployment, as well as single user.
* The utility requires a text file with a list of the apps to remove.
* This utility has been tested on Windows 10.

## How to get create a list of apps to remove

To use the script you'll need to make a text file with a list of the apps to remove.

To get a list of built-in apps for the current user:

``` powershell
Get-AppxPackage | Select Name
```

To get a list of all the apps, use this command in an elevated PowerShell session:

Note: Provisioned apps are the built-in apps that will be installed for all new users when they first log on.

``` powershell
Get-AppxProvisionedPackage -Online | Select Displayname
```

Below is a table of apps names in PowerShell and what they are in Windows. You can use this table to create your own removal list.

| PowerShell Display Name | Description | App name in Start Menu |
| ----------------------- | ----------- | ---------------------- |
| Microsoft.BingWeather | Weather app | Weather |
| Microsoft.DesktopAppInstaller | System | None |
| Microsoft.GetHelp | Help app | Get Help |
| Microsoft.Getstarted | Tips app | Tips |
| Microsoft.HEIFImageExtension | System | None |
| Microsoft.Messaging | Messaging app | Messaging |
| Microsoft.Microsoft3DViewer | 3D Viewer app | 3D Viewer |
| Microsoft.MicrosoftOfficeHub | Office 365 hub app | Office |
| Microsoft.MicrosoftSolitaireCollection | Collection of games | Microsoft Solitaire Collection |
| Microsoft.MicrosoftStickyNotes | Sticky Notes app | Sticky Notes |
| Microsoft.MixedReality.Portal | Mixed Reality app | Mixed Reality Portal |
| Microsoft.MSPaint | Paint 3D app | Paint 3D |
| Microsoft.Office.OneNote | OneNote app | OneNote |
| Microsoft.OneConnect | ??? | None |
| Microsoft.People | Contacts management app | People |
| Microsoft.Print3D | 3D Printing app | Print 3D |
| Microsoft.ScreenSketch | Screen shot app | Snip & Sketch |
| Microsoft.SkypeApp | Skype app | Skype |
| Microsoft.StorePurchaseApp | System | None |
| Microsoft.VP9VideoExtensions | System | None |
| Microsoft.Wallet | System | None |
| Microsoft.WebMediaExtensions | System | None |
| Microsoft.WebpImageExtension | System | None |
| Microsoft.Windows.Photos | Microsoft Photos app | (2) "Photos" and "Video editor" |
| Microsoft.WindowsAlarms | Clock and Alarms app | Alarms & Clock |
| Microsoft.WindowsCalculator | Calculator app | Calculator |
| Microsoft.WindowsCamera | Camera app | Camera |
| microsoft.windowscommunicationsapps | Calendar and Mail apps | (2) "Calendar" and "Mail" |
| Microsoft.WindowsFeedbackHub | Feedback Hub app | Feedback Hub |
| Microsoft.WindowsMaps | Bing Maps app | Maps |
| Microsoft.WindowsSoundRecorder | Audio recording app | Voice Recorder |
| Microsoft.WindowsStore | Microsoft Store app | Microsoft Store |
| Microsoft.Xbox.TCUI | System, part of Xbox | None |
| Microsoft.XboxApp | Xbox Console Companion app | Xbox Console Companion |
| Microsoft.XboxGameOverlay | System, part of Xbox | None |
| Microsoft.XboxGamingOverlay | Xbox Game Bar app | Xbox Game Bar |
| Microsoft.XboxIdentityProvider | System, part of Xbox | None |
| Microsoft.XboxSpeechToTextOverlay | System, part of Xbox | None |
| Microsoft.YourPhone | Phone linking app | Your Phone |
| Microsoft.ZuneMusic | Groove Music app | Groove Music |
| Microsoft.ZuneVideo | Films & TV app | Films & TV |

### Configuration

Here’s a list of all the command line switches and example configurations.

| Command Line Switch | Description | Example |
| ------------------- | ----------- | ------- |
| -List | The full path to the txt file listing the apps to remove. | C:\scripts\w10-apps-1909.txt |
| -NoBanner | Use this option to hide the ASCII art title in the console. | N/A |
| -L | The path to output the log file to. The file name will be Remove-W10-Apps_YYYY-MM-dd_HH-mm-ss.log Do not add a trailing \ backslash. | C:\scripts\logs |

### Example

``` txt
Remove-W10-Apps.ps1 -List C:\scripts\w10-apps-1909.txt -L C:\scripts\logs
```

The above command will remove the apps listed in the specified text file and will generate a log file.
