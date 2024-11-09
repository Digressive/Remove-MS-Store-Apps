<#PSScriptInfo

.VERSION 24.11.09

.GUID 888f5987-8b64-4a4a-ab8e-00a1bc99ff54

.AUTHOR Mike Galvin Contact: digressive@outlook.com

.COMPANYNAME Mike Galvin

.COPYRIGHT (C) Mike Galvin. All rights reserved.

.TAGS Remove Clean up Microsoft Store Windows UWP in-box built-in included app Windows 11 10 Customisable removal utility

.LICENSEURI https://github.com/Digressive/Remove-MS-Store-Apps?tab=MIT-1-ov-file

.PROJECTURI https://gal.vin/utils/remove-ms-store-apps-utility/

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#
    .SYNOPSIS
    Remove MS Store Apps - Customisable Windows 11/10 Microsoft Store app removal utility

    .DESCRIPTION
    Removes apps included in Windows 11/10.
    Run with -help or no arguments for usage.
#>

## Set up command line switches.
[CmdletBinding()]
Param(
    [alias("List")]
    $AppListFile,
    [alias("Wim")]
    $WimFile,
    [alias("WimIndex")]
    $WIndex,
    [alias("WimMountPath")]
    $WimMntPath,
    [alias("L")]
    $LogPathUsr,
    [alias("LogRotate")]
    $LogHistory,
    [switch]$PCApps,
    [switch]$UserApps,
    [switch]$Uno,
    [switch]$PCOnly,
    [switch]$Help,
    [switch]$NoBanner)

If ($NoBanner -eq $False)
{
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "
         _____                                 __  __  _____    _____ _                     
        |  __ \                               |  \/  |/ ____|  / ____| |                    
        | |__) |___ _ __ ___   _____   _____  | \  / | (___   | (___ | |_ ___  _ __ ___     
        |  _  // _ \ '_ ' _ \ / _ \ \ / / _ \ | |\/| |\___ \   \___ \| __/ _ \| '__/ _ \    
        | | \ \  __/ | | | | | (_) \ V /  __/ | |  | |____) |  ____) | || (_) | | |  __/    
        |_|  \_\___|_| |_| |_|\___/ \_/ \___| |_|_ |_|_____/  |_____/ \__\___/|_|  \___|    
            /\                     | |  | | | (_) (_) |                                     
           /  \   _ __  _ __  ___  | |  | | |_ _| |_| |_ _   _                              
          / /\ \ | '_ \| '_ \/ __| | |  | | __| | | | __| | | |         Mike Galvin         
         / ____ \| |_) | |_) \__ \ | |__| | |_| | | | |_| |_| |       https://gal.vin       
        /_/    \_\ .__/| .__/|___/  \____/ \__|_|_|_|\__|\__, |                             
                 | |   | |                                __/ |      Version 24.11.09       
                 |_|   |_|                               |___/      See -help for usage     
                                                                                            
                              Donate: https://www.paypal.me/digressive                      
"
}

If ($PSBoundParameters.Values.Count -eq 0 -or $Help)
{
    Write-Host -Object "Usage:
    From an elevated terminal run: [path\]Remove-MS-Store-Apps.ps1 -List [path\]apps-to-remove.txt
    This will remove the apps in the txt file from your Windows installation for all users.

    You can also run: [path\]Remove-MS-Store-Apps.ps1 -Uno -List [path\]apps-to-keep.txt
    This will remove the all apps not in the txt file from your Windows installation for all users.

    To remove only PC apps and leave the current user apps untouched use: -PCOnly

    To list apps for all users: -PCApps.
    To list apps for the current user: -UserApps.

    To operate on a wim file: -Wim [path\]install.wim -WimIndex [number] (optional: -WimMountPath [path\])

    Run the following command to find out the WimIndex for your wim file:
    Get-WindowsImage -ImagePath [path\]install.wim | Format-Table -Property ImageIndex, ImageName

    To output a log: -L [path\].
    To remove logs produced by the utility older than X days: -LogRotate [number].
    Run with no ASCII banner: -NoBanner"
}

else {
    ## If logging is configured, start logging.
    ## If the log file already exists, clear it.
    If ($LogPathUsr)
    {
        ## Clean User entered string
        $LogPath = $LogPathUsr.trimend('\')

        ## Make sure the log directory exists.
        If ((Test-Path -Path $LogPath) -eq $False)
        {
            New-Item $LogPath -ItemType Directory -Force | Out-Null
        }

        $LogFile = ("Remove-MS-Store-Apps_{0:yyyy-MM-dd_HH-mm-ss}.log" -f (Get-Date))
        $Log = "$LogPath\$LogFile"

        If (Test-Path -Path $Log)
        {
            Clear-Content -Path $Log
        }
    }

    ## Function to get date in specific format.
    Function Get-DateFormat
    {
        Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    ## Function for logging.
    Function Write-Log($Type, $Evt)
    {
        If ($Type -eq "Info")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [INFO] $Evt"
            }
            
            Write-Host -Object "$(Get-DateFormat) [INFO] $Evt"
        }

        If ($Type -eq "Succ")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [SUCCESS] $Evt"
            }

            Write-Host -ForegroundColor Green -Object "$(Get-DateFormat) [SUCCESS] $Evt"
        }

        If ($Type -eq "Err")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [ERROR] $Evt"
            }

            Write-Host -ForegroundColor Red -BackgroundColor Black -Object "$(Get-DateFormat) [ERROR] $Evt"
        }

        If ($Type -eq "Conf")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$Evt"
            }

            Write-Host -ForegroundColor Cyan -Object "$Evt"
        }
    }

    ## Function for Update Check
    Function UpdateCheck()
    {
        $ScriptVersion = "24.11.09"
        $RawSource = "https://raw.githubusercontent.com/Digressive/Remove-MS-Store-Apps/master/Remove-MS-Store-Apps.ps1"

        try {
            $SourceCheck = Invoke-RestMethod -uri "$RawSource"
            $VerCheck = $SourceCheck -split '\n' | Select-String -Pattern ".VERSION $ScriptVersion" -SimpleMatch -CaseSensitive -Quiet

            If ($VerCheck -ne $True)
            {
                Write-Log -Type Conf -Evt "*** There is an update available. ***"
            }
        }
        catch {
        }
    }

    ## Check for the apps list file, if it exists then sanitise it and if it doesn't exist then report and exit.
    If ($AppListFile)
    {
        If (Test-Path -Path $AppListFile)
        {
            $AppsList = Get-Content $AppListFile | Where-Object {$_.trim() -ne ""}
        }
        else {
            Write-Log -Type Err -Evt "The app list file $AppListFile does not exist."
            Exit
        }
    }

    If ($null -eq $AppListFile -And $PCApps -eq $false -And $UserApps -eq $false)
    {
        Write-Log -Type Err -Evt "No app list specified."
        Exit
    }

    ## Getting Windows Version info
    $OSVMaj = [environment]::OSVersion.Version | Select-Object -expand major
    $OSVMin = [environment]::OSVersion.Version | Select-Object -expand minor
    $OSVBui = [environment]::OSVersion.Version | Select-Object -expand build
    $OSV = "$OSVMaj" + "." + "$OSVMin" + "." + "$OSVBui"

    ##
    ## Display the current config and log if configured.
    ##
    Write-Log -Type Conf -Evt "--- Running with the following config ---"
    Write-Log -Type Conf -Evt "Utility Version: 24.11.09"
    UpdateCheck ## Run Update checker function
    Write-Log -Type Conf -Evt "Hostname: $Env:ComputerName."
    Write-Log -Type Conf -Evt "Windows Version: $OSV."

    If ($AppListFile)
    {
        Write-Log -Type Conf -Evt "Using list from file: $AppListFile."
    }

    If ($WimFile)
    {
        Write-Log -Type Conf -Evt "Wim File: $WimFile."
    }

    If ($WIndex)
    {
        Write-Log -Type Conf -Evt "Wim Index: $WIndex."
    }

    If ($WimMntPath)
    {
        Write-Log -Type Conf -Evt "Wim Mount Path: $WimMntPath."
    }

    If ($LogPathUsr)
    {
        Write-Log -Type Conf -Evt "Logs directory: $LogPath."
    }

    If ($Null -ne $LogHistory)
    {
        Write-Log -Type Conf -Evt "Logs to keep: $LogHistory days"
    }

    If ($PCOnly)
    {
        Write-Log -Type Conf -Evt "-PCOnly option is: $PCOnly."
    }

    If ($Uno)
    {
        Write-Log -Type Conf -Evt "-Uno option is: $Uno."
    }

    If ($AppListFile)
    {
        If ($Uno -eq $false)
        {
            Write-Log -Type Conf -Evt "Apps to remove:"

            ForEach ($App in $AppsList)
            {
                Write-Log -Type Conf -Evt "$App"
            }
        }
        else {
            Write-Log -Type Conf -Evt "Apps to keep:"

            ForEach ($App in $AppsList)
            {
                Write-Log -Type Conf -Evt "$App"
            }
        }
    }

    Write-Log -Type Conf -Evt "---"
    Write-Log -Type Info -Evt "Process started"
    ##
    ## Display current config ends here.
    ##

    ##
    ## Online Mode
    ##
    If ($Null -eq $WimFile)
    {
        If ($Uno -eq $false)
        {
            ## Remove the Apps listed in the file or report if app not present.
            ForEach ($App in $AppsList)
            {
                $PackageFullName = (Get-AppxPackage $App).PackageFullName
                $ProPackageFullName = (Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $App}).PackageName

                If ($PCOnly -eq $false)
                {
                    If ($PackageFullName)
                    {
                        Write-Log -Type Info -Evt "Removing Package: $App"
                        Remove-AppxPackage -Package $PackageFullName | Out-Null
                    }
                    else {
                        Write-Log -Type Info -Evt "Unable to find package: $App"
                    }
                }

                If ($ProPackageFullName)
                {
                    Write-Log -Type Info -Evt "Removing Provisioned Package: $ProPackageFullName"
                    Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName | Out-Null
                }
                else {
                    Write-Log -Type Info -Evt "Unable to find provisioned package: $App"
                }
            }
        }
        else {
            $AppsToKeep = $AppsList -join "|"
            $AppsFullName = Get-AppxPackage | Where-Object {$_.PackageFullName -NotMatch $AppsToKeep} | Select-Object -ExpandProperty PackageFullName
            $ProvAppsFullName = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -NotMatch $AppsToKeep} | Select-Object -ExpandProperty PackageName
            
            If ($PCOnly -eq $false)
            {
                ForEach ($AppFullName in $AppsFullName)
                {
                    Write-Log -Type Info -Evt "Removing Package: $AppFullName"
                    Remove-AppxPackage -Package $AppFullName | Out-Null
                }
            }

            ForEach ($ProvAppFullName in $ProvAppsFullName)
            {
                Write-Log -Type Info -Evt "Removing Provisioned Package: $ProvAppFullName"
                Remove-AppxProvisionedPackage -Online -PackageName $ProvAppFullName | Out-Null
            }
        }
    }

    ## TODO Uno mode for WIM Image
    ##
    ## Offline Mode
    ##
    If ($WimFile)
    {
        ## Default Wim Mount Path if none is configured.
        If ($Null -eq $WimMntPath)
        {
            $WimMntPath = "$Env:temp\RemMSStoreApps-WimMount"
        }

        ## Make sure the mount directory exists, if it doesn't create it.
        If ((Test-Path -Path $WimMntPath) -eq $False)
        {
            New-Item $WimMntPath -ItemType Directory -Force | Out-Null
        }

        ## Mount the Image.
        Mount-WindowsImage -ImagePath $WimFile -Index $WIndex -Path $WimMntPath | Out-Null

        If ($Uno -eq $false)
        {
            ## Remove the Apps listed above or report if app not present.
            ForEach ($App in $AppsList)
            {
                $ProPackageFullName = (Get-AppxProvisionedPackage -Path $WimMntPath | Where-Object {$_.DisplayName -eq $App}).PackageName

                If ($ProPackageFullName)
                {
                    Write-Log -Type Info -Evt "Removing Provisioned Package: $ProPackageFullName"
                    Remove-AppxProvisionedPackage -Path $WimMntPath -PackageName $ProPackageFullName | Out-Null
                }
                else
                {
                    Write-Log -Type Info -Evt "Unable to find provisioned package: $App"
                }
            }
        }
        else {
            $AppsToKeep = $AppsList -join "|"
            $ProvAppsFullName = Get-AppxProvisionedPackage -Path $WimMntPath | Where-Object {$_.DisplayName -NotMatch $AppsToKeep} | Select-Object -ExpandProperty PackageName

            ForEach ($ProvAppFullName in $ProvAppsFullName)
            {
                Write-Log -Type Info -Evt "Removing Provisioned Package: $ProvAppFullName"
                Remove-AppxProvisionedPackage -Path $WimMntPath -PackageName $ProvAppFullName | Out-Null
            }
        }

        ## Dismount the image and save changes.
        Dismount-WindowsImage -Path $WimMntPath -Save | Out-Null
    }

    If ($PCApps)
    {
        Get-AppxProvisionedPackage -Online | Select-Object DisplayName | Format-Table -HideTableHeaders
        If ($LogPathUsr)
        {
            Get-AppxProvisionedPackage -Online | Select-Object DisplayName | Format-Table -HideTableHeaders | Out-File -Append $Log -Encoding ASCII
        }
    }

    If ($UserApps)
    {
        Get-AppxPackage | Select-Object Name | Format-Table -HideTableHeaders
        If ($LogPathUsr)
        {
            Get-AppxPackage | Select-Object Name | Format-Table -HideTableHeaders | Out-File -Append $Log -Encoding ASCII
        }
    }

    Write-Log -Type Info -Evt "Process finished."

    If ($Null -ne $LogHistory)
    {
        ## Cleanup logs.
        Write-Log -Type Info -Evt "Deleting logs older than: $LogHistory days"
        Get-ChildItem -Path "$LogPath\Remove-MS-Store-Apps_*" -File | Where-Object CreationTime -lt (Get-Date).AddDays(-$LogHistory) | Remove-Item -Recurse
    }
}
## End