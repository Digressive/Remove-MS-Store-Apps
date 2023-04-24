# Remove MS Store Apps Utility

## Customisable Windows 10/11 Microsoft Store App removal utility, previously known as Remove-Win10-Apps

For full change log and more information, [visit my site.](https://gal.vin/utils/remove-ms-store-apps-utility/)

Remove MS Store Apps Utility is available from:

* [GitHub](https://github.com/Digressive/Remove-MS-Store-Apps)
* [The Microsoft PowerShell Gallery](https://www.powershellgallery.com/packages/Remove-MS-Store-Apps)

Please consider supporting my work:

* Sign up using [Patreon](https://www.patreon.com/mikegalvin).
* Support with a one-time donation using [PayPal](https://www.paypal.me/digressive).

Please report any problems via the ‘issues’ tab on GitHub.

-Mike

## Features and Requirements

* Remove specified apps for the current logged on user.
* Remove specified apps from the system for all users.
* Can be used for imaging and OS deployment, as well as individual user.
* Can be used on an offline Windows image.
* Requires a text file with a list of the apps to remove.
* Tested on Windows 10 and Windows 11.

## How to get a list of apps to remove

To create a text file with a list of the apps to remove, run the following and copy and paste the app names you wish to remove into a txt file and save it.

```powershell
Remove-MS-Store-Apps.ps1 -PCApps
```

To get a list of apps that are installed for the current user, use this command:

```powershell
Remove-MS-Store-Apps.ps1 -UserApps
```

## How to find the index number of the image in the wim file

Run the following command to find out how many images are present in the wim file:

``` powershell
Get-WindowsImage -ImagePath [path\]install.wim | Format-Table -Property ImageIndex, ImageName
```

## App Names Table

Here is a table of app names in PowerShell and what they relate to in Windows.

| PowerShell Display Name | App name | Windows 10 Notes | Windows 11 Notes |
| ----------------------- | -------- | ---------------- | ---------------- |
| Clipchamp.Clipchamp | Clipchamp | N/A | New in Win 11 22H2 |
| Microsoft.549981C3F5F10 | Cortana | New in 2004 | No change |
| Microsoft.BingNews | Microsoft News | N/A | New in Win 11 21H2 |
| Microsoft.BingWeather | Weather | No change | No change |
| Microsoft.DesktopAppInstaller | winget | No change | No change |
| Microsoft.GamingApp | Xbox | N/A | Name Changed from XboxApp |
| Microsoft.GetHelp | Get Help | No change | No change |
| Microsoft.Getstarted | Tips | No change | No change |
| Microsoft.HEIFImageExtension | None | No change | No change |
| Microsoft.HEVCVideoExtension | None | N/A | New in Win 11 22H2 |
| Microsoft.Messaging | Messaging | Removed in 2004 | Not present |
| Microsoft.Microsoft3DViewer | 3D Viewer | No change | Not present |
| Microsoft.MicrosoftEdge.Stable | Microsoft Edge | New in 21H1 | No change |
| Microsoft.MicrosoftOfficeHub | Office | No change | No change |
| Microsoft.MicrosoftSolitaireCollection | Microsoft Solitaire Collection | No change | No change |
| Microsoft.MicrosoftStickyNotes | Sticky Notes | No change | No change |
| Microsoft.MixedReality.Portal | Mixed Reality Portal | No change | Not present |
| Microsoft.Paint | Paint | N/A | New in Win 11 21H2 |
| Microsoft.MSPaint | Paint 3D | No change | Not present |
| Microsoft.Office.OneNote | OneNote | No change | Not present |
| Microsoft.OneConnect | None | Removed in 2004 | Not present |
| Microsoft.People | People | No change | No change |
| Microsoft.PowerAutomateDesktop | Power Automate | N/A | New in Win 11 21H2 |
| Microsoft.RawImageExtension | None | N/A | New in Win 11 22H2 |
| Microsoft.Print3D | Print 3D | Removed in 2004 | Not present |
| Microsoft.ScreenSketch | Snip & Sketch | No change | No change |
| Microsoft.SecHealthUI | None | N/A | New in Win 11 21H2 |
| Microsoft.SkypeApp | Skype | No change | Not present |
| Microsoft.StorePurchaseApp | None | No change | No change |
| Microsoft.Todos | Microsoft To Do | N/A | New in Win 11 21H2 |
| Microsoft.UI.Xaml.2.4 | None | N/A | New in Win 11 21H2 |
| Microsoft.VCLibs.140.00 | None | New in 2004 | No change |
| Microsoft.VP9VideoExtensions | None | No change | No change |
| Microsoft.Wallet | None | No change | Not present |
| Microsoft.WebMediaExtensions | None | No change | No change |
| Microsoft.WebpImageExtension | None | No change | No change |
| Microsoft.Windows.Photos | (2) "Photos" and "Video editor" | No change | No change |
| Microsoft.WindowsAlarms | Alarms & Clock | No change | No change |
| Microsoft.WindowsCalculator | Calculator | No change | No change |
| Microsoft.WindowsCamera | Camera | No change | No change |
| microsoft.windowscommunicationsapps | (2) "Calendar" and "Mail" | No change | No change |
| Microsoft.WindowsFeedbackHub | Feedback Hub | No change | No change |
| Microsoft.WindowsMaps | Maps | No change | No change |
| Microsoft.WindowsNotepad | Notepad | N/A | New in Win 11 21H2 |
| Microsoft.WindowsSoundRecorder | Voice Recorder | No change | No change |
| Microsoft.WindowsStore | Microsoft Store | No change | No change |
| Microsoft.WindowsTerminal | Terminal | N/A | New in Win 11 21H2 |
| Microsoft.Xbox.TCUI | None | No change | No change |
| Microsoft.XboxApp | Xbox Console Companion | No change | Name changed to GamingApp |
| Microsoft.XboxGameOverlay | None | No change | No change |
| Microsoft.XboxGamingOverlay | Xbox Game Bar | No change | No change |
| Microsoft.XboxIdentityProvider | None | No change | No change |
| Microsoft.XboxSpeechToTextOverlay | None | No change | No change |
| Microsoft.YourPhone | Your Phone | No change | No change |
| Microsoft.ZuneMusic | Groove Music | No change | App name is now Media Player |
| Microsoft.ZuneVideo | Films & TV | No change | No change |
| MicrosoftCorporationII.QuickAssist | Quick Assist | N/A | New in Win 11 22H2 |
| MicrosoftWindows.Client.WebExperience | None | N/A | New in Win 11 21H2 |

## Configuration

Here’s a list of all the command line switches and example configurations.

| Command Line Switch | Description | Example |
| ------------------- | ----------- | ------- |
| -List | The full path to the txt file listing the apps to remove. | [path\]apps-to-remove.txt |
| -Wim | The full path to the wim file to remove the apps from. | [path\]install.wim |
| -WimIndex | The index number of the image to operate on. | [number] |
| -WimMountPath | The full path to a folder that the wim file should be mounted to. If you do not configure this temp dir will be used. | [path\] |
| -PCApps | List apps that are currently installed on the system. | N/A |
| -UserApps | List apps that are currently installed for the user. | N/A |
| -L | The path to output the log file to. | [path\] |
| -LogRotate | Remove logs produced by the utility older than X days | [number] |
| -NoBanner | Use this option to hide the ASCII art title in the console. | N/A |
| -Help | Display usage information. No arguments also displays help. | N/A |

## Example

``` txt
[path\]Remove-MS-Store-Apps.ps1 -List [path\]apps-to-remove.txt
```

This will remove the apps in the txt file from your Windows installation for all users.

## Change Log

### 2023-04-24: Version 23.04.24

* Added script update checker - shows if an update is available in the log and console.

### 2022-06-14: Version 22.05.30

* Added checks and balances to help with configuration as I'm very aware that the initial configuration can be troublesome. Running the utility manually is a lot more friendly and step-by-step now.
* Added -Help to give usage instructions in the terminal. Running the script with no options will also trigger the -help switch.
* Cleaned user entered paths so that trailing slashes no longer break things or have otherwise unintended results.
* Added -LogRotate [days] to removed old logs created by the utility.
* Streamlined config report so non configured options are not shown.
* Added donation link to the ASCII banner.
* Cleaned up code, removed unneeded log noise.

### 2022-04-26: Version 22.04.26

* Added -PCApps switch to list all MS Store apps on the system.
* Added -UserApps switch to list all MS Store apps installed for the user.
* Added -Help to give usage instructions in the terminal. Also running the script with no options will also trigger the -help switch.
* Streamlined config report so non configured options are not shown.

### 2022-04-22: Version 22.04.22

* If the -WimMountPath is not configured by the user then the default Windows temp folder will be used instead.
* If the -WimMountPath is configured by the user but the path does not exist, it will be created.
* Added a -LogRotate option to delete logs older than X number of days.

### 2022-03-27: Version 22.03.27

* Utility now ignores blanks lines in Apps list file.

### 2021-12-08: Version 21.12.08

* Configured logs path now is created, if it does not exist.
* Added OS version info.
* Added Utility version info.
* Added Hostname info.
* Changed a variable to prevent conflicts with future PowerShell versions.

### 2021-09-07: Version 07.09.21

* Added ability to remove apps from offline images.

### 2020-03-13: Version 20.03.13 ‘Cool’

* Refactored code.
* Backwards compatible.
* Added logging.
* Added config report when ran.
* Added ASCII banner art when run in the console.
* Added option to disable the ASCII banner art.

### 2019-12-03 v2.0

* First public release.
