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
