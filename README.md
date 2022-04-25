# Remove MS Store Apps Utility

Customisable Windows 10/11 Microsoft Store App removal utility, previously known as Remove-Win10-Apps.

For full instructions and documentation, [visit my site.](https://gal.vin/utils/remove-ms-store-apps-utility/)

Please consider supporting my work:

* Sign up [using Patreon.](https://www.patreon.com/mikegalvin)
* Support with a one-time payment [using PayPal.](https://www.paypal.me/digressive)

Remove MS Store Apps Utility can also be downloaded from:

* [The Microsoft PowerShell Gallery](https://www.powershellgallery.com/packages/Remove-Win10-Apps)

Join the [Discord](http://discord.gg/5ZsnJ5k) or Tweet me if you have questions: [@mikegalvin_](https://twitter.com/mikegalvin_)

-Mike

## Features and Requirements

* The utility will remove specified apps for the current logged on user.
* The utility will remove specified provisioned apps from the system.
* This utility can be used for imaging and OS deployment, as well as single user.
* The utility requires a text file with a list of the apps to remove.
* This utility has been tested on Windows 10 and Windows 11.

## How to get create a list of apps to remove

To create a text file with a list of the apps to remove, run the following and copy and paste the app names you wish to remove into a txt file and save it.

```powershell
Remove-MS-Store-Apps.ps1 -PCApps
```

To get a list of apps that are installed for the current user, use this command:

```powershell
Remove-MS-Store-Apps.ps1 -UserApps
```

## How to find the index number of the image in the wim file

Run the following command to find out what images are present in the wim file:

``` powershell
Get-WindowsImage -ImagePath "C:\foo\Windows 10\sources\install.wim" | Format-Table -Property ImageIndex, ImageName
```

## App Names Table

Here is a table of app names in PowerShell and what they relate to in Windows.

| PowerShell Display Name | App name | Windows 10 Notes | Windows 11 Notes |
| ----------------------- | -------- | ---------------- | ---------------- |
| Microsoft.549981C3F5F10 | Cortana | New in 2004 | No change |
| Microsoft.BingNews | Microsoft News | N/A | New in Win 11 21H2 |
| Microsoft.BingWeather | Weather | No change | No change |
| Microsoft.DesktopAppInstaller | None | No change | No change |
| Microsoft.GamingApp | Xbox | N/A | Name Changed from XboxApp |
| Microsoft.GetHelp | Get Help | No change | No change |
| Microsoft.Getstarted | Tips | No change | No change |
| Microsoft.HEIFImageExtension | None | No change | No change |
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
| Microsoft.ZuneMusic | Groove Music | No change | No change |
| Microsoft.ZuneVideo | Films & TV | No change | No change |
| MicrosoftWindows.Client.WebExperience | None | N/A | New in Win 11 21H2 |

### Configuration

Here’s a list of all the command line switches and example configurations.

| Command Line Switch | Description | Example |
| ------------------- | ----------- | ------- |
| -List | The full path to the txt file listing the apps to remove. | ```C:\scripts\w10-apps-2004.txt``` |
| -Wim | The full path to the wim file to remove the apps from. | ```C:\foo\Windows 10\sources\install.wim``` |
| -WimIndex | The index number of the image to operate on. | 1 |
| -WimMountPath | The full path to a folder that the wim file should be mounted to. If you do not configure this the ```%temp%``` dir will be used. | ```C:\foo\w10mnt``` |
| -PCApps | List apps that are currently installed on the system. | N/A |
| -UserApps | List apps that are currently installed for the user. | N/A |
| -NoBanner | Use this option to hide the ASCII art title in the console. | N/A |
| -L | The path to output the log file to. The file name will be The file name will be Remove-MS-Store-Apps_YYYY-MM-dd_HH-mm-ss.log Do not add a trailing \ backslash. | ```C:\scripts\logs``` |
| -LogRotate | Instructs the utility to remove logs older than a specified number of days. | 30 |
| -Help | Show usage instructions. | N/A |

### Example

``` txt
Remove-MS-Store-Apps.ps1 -List C:\scripts\w10-21H2-apps-provisioned.txt -L C:\scripts\logs
```

The above command will remove the apps in the specified text file from the running system for all users, and will generate a log file.
