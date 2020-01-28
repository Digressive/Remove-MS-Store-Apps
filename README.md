# Remove-UWP-Apps

Remove Microsoft store/UWP in-box apps from Windows 10

For full instructions and documentation, [visit my blog post](https://gal.vin/2019/12/04/remove-uwp-apps/)

Please consider donating to support my work:

* You can support me [using Patreon](https://www.patreon.com/mikegalvin)
* You can support me [using PayPal](https://www.paypal.me/digressive)
* You can support me [using Kofi](https://ko-fi.com/mikegalvin)

Send me a tweet if you have questions: [@mikegalvin_](https://twitter.com/mikegalvin_)

-Mike

## Configuration

To use the script you'll need to make a text file with a list of the apps to remove.

To get a list of installed UWP apps for the current user:

``` powershell
Get-AppxPackage | Select Name
```

To get a list of all the apps, use this command in an elevated PowerShell session:

Note: Provisioned apps are the UWP apps that will be installed for all new users when they first log on.

``` powershell
Get-AppxProvisionedPackage -Online | Select Displayname
```

``` txt
-List
```

Use this switch along with the full path to the txt file contain the list of applications to remove. I've included example files in this repo.

### Example

``` txt
Remove-UWP-Apps.ps1 -List C:\foo\uwp-apps-1909.txt
```

This will remove the apps listed in the txt file for both the current logged on user and for the device itself.

### Table of app display names in PowerShell and their app name in Windows

| PowerShell Display Name                 | Description                    | App name in Start Menu          |
| --------------------------------------- | ------------------------------ | ------------------------------- |
| Microsoft.BingWeather                   | Weather UWP app                | Weather                         |
| Microsoft.DesktopAppInstaller           | System                         | None                            |
| Microsoft.GetHelp                       | Help UWP app                   | Get Help                        |
| Microsoft.Getstarted                    | Tips UWP app                   | Tips                            |
| Microsoft.HEIFImageExtension            | System                         | None                            |
| Microsoft.Messaging                     | Messaging UWP app              | Messaging                       |
| Microsoft.Microsoft3DViewer             | 3D Viewer UWP app              | 3D Viewer                       |
| Microsoft.MicrosoftOfficeHub            | Office 365 hub app             | Office                          |
| Microsoft.MicrosoftSolitaireCollection  | Collection of games            | Microsoft Solitaire Collection  |
| Microsoft.MicrosoftStickyNotes          | Sticky Notes UWP app           | Sticky Notes                    |
| Microsoft.MixedReality.Portal           | Mixed Reality UWP app          | Mixed Reality Portal            |
| Microsoft.MSPaint                       | Paint 3D UWP app               | Paint 3D                        |
| Microsoft.Office.OneNote                | OneNote UWP app                | OneNote                         |
| Microsoft.OneConnect                    | ???                            | None                            |
| Microsoft.People                        | Contacts management UWP app    | People                          |
| Microsoft.Print3D                       | 3D Printing UWP app            | Print 3D                        |
| Microsoft.ScreenSketch                  | Screen shot UWP app            | Snip & Sketch                   |
| Microsoft.SkypeApp                      | Skype UWP app                  | Skype                           |
| Microsoft.StorePurchaseApp              | System                         | None                            |
| Microsoft.VP9VideoExtensions            | System                         | None                            |
| Microsoft.Wallet                        | System                         | None                            |
| Microsoft.WebMediaExtensions            | System                         | None                            |
| Microsoft.WebpImageExtension            | System                         | None                            |
| Microsoft.Windows.Photos                | Microsoft Photos UWP app       | (2) "Photos" and "Video editor" |
| Microsoft.WindowsAlarms                 | Clock and Alarams UWP app      | Alarms & Clock                  |
| Microsoft.WindowsCalculator             | Calculator UWP app             | Calculator                      |
| Microsoft.WindowsCamera                 | Camera UWP app                 | Camera                          |
| microsoft.windowscommunicationsapps     | Calendar and Mail UWP apps     | (2) "Calendar" and "Mail"       |
| Microsoft.WindowsFeedbackHub            | Feedback Hub UWP app           | Feedback Hub                    |
| Microsoft.WindowsMaps                   | Bing Maps UWP app              | Maps                            |
| Microsoft.WindowsSoundRecorder          | Audio recording UWP app        | Voice Recorder                  |
| Microsoft.WindowsStore                  | Microsoft Store UWP app        | Microsoft Store                 |
| Microsoft.Xbox.TCUI                     | System, part of Xbox           | None                            |
| Microsoft.XboxApp                       | Xbox Console Companion UWP app | Xbox Console Companion          |
| Microsoft.XboxGameOverlay               | System, part of Xbox           | None                            |
| Microsoft.XboxGamingOverlay             | Xbox Game Bar UWP app          | Xbox Game Bar                   |
| Microsoft.XboxIdentityProvider          | System, part of Xbox           | None                            |
| Microsoft.XboxSpeechToTextOverlay       | System, part of Xbox           | None                            |
| Microsoft.YourPhone                     | Phone linking UWP app          | Your Phone                      |
| Microsoft.ZuneMusic                     | Groove Music UWP app           | Groove Music                    |
| Microsoft.ZuneVideo                     | Films & TV UWP app             | Films & TV                      |
