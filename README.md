# Remove-UWP-Apps

Remove pre-installed UWP apps from Windows 10

Please consider donating to support my work:

* You can support me on a monthly basis [using Patreon.](https://www.patreon.com/mikegalvin)
* You can support me with a one-time payment [using PayPal](https://www.paypal.me/digressive) or by [using Kofi.](https://ko-fi.com/mikegalvin)

* For full instructions and documentation, [visit my blog post](https://gal.vin/2017/04/06/removing-uwp-apps-mdt/)

-Mike

Tweet me if you have questions: [@mikegalvin_](https://twitter.com/mikegalvin_)

## Configuration

To get a list of apps, run the following commands;

To get a list of installed UWP apps for the current user:

``` powershell
Get-AppxPackage | Select Name
```

To get a list of all the apps currently provisioned, use this following PowerShell command:

Note: Provisioned apps are the UWP apps that will be installed for all new users when they first log on.

``` powershell
Get-AppxProvisionedPackage -Online | Select Displayname
```

Edit the list of apps to be removed at the top of the script.
Be sure to put them in quotes (") and ending the line with a comma (,) except for the final app in the list.

``` powershell
$AppsList = "Microsoft.BingWeather",
            "Microsoft.DesktopAppInstaller",
            "Microsoft.GetHelp",
            "Microsoft.Getstarted",
            "Microsoft.HEIFImageExtension",
            "Microsoft.Messaging",
            "Microsoft.Microsoft3DViewer",
            "Microsoft.MicrosoftOfficeHub",
            "Microsoft.MicrosoftSolitaireCollection",
            "Microsoft.MicrosoftStickyNotes",
            "Microsoft.MixedReality.Portal",
            "Microsoft.MSPaint",
            "Microsoft.Office.OneNote",
            "Microsoft.OneConnect",
            "Microsoft.People",
            "Microsoft.Print3D",
            "Microsoft.ScreenSketch",
            "Microsoft.SkypeApp",
            "Microsoft.StorePurchaseApp",
            "Microsoft.VP9VideoExtensions",
            "Microsoft.Wallet",
            "Microsoft.WebMediaExtensions",
            "Microsoft.WebpImageExtension",
            "Microsoft.Windows.Photos",
            "Microsoft.WindowsAlarms",
            "Microsoft.WindowsCalculator",
            "Microsoft.WindowsCamera",
            "microsoft.windowscommunicationsapps",
            "Microsoft.WindowsFeedbackHub",
            "Microsoft.WindowsMaps",
            "Microsoft.WindowsSoundRecorder",
            "Microsoft.WindowsStore",
            "Microsoft.Xbox.TCUI",
            "Microsoft.XboxApp",
            "Microsoft.XboxGameOverlay",
            "Microsoft.XboxGamingOverlay",
            "Microsoft.XboxIdentityProvider",
            "Microsoft.XboxSpeechToTextOverlay",
            "Microsoft.YourPhone",
            "Microsoft.ZuneMusic",
            "Microsoft.ZuneVideo"
```
