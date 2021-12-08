<#PSScriptInfo

.VERSION 21.12.08

.GUID 888f5987-8b64-4a4a-ab8e-00a1bc99ff54

.AUTHOR Mike Galvin Contact: mike@gal.vin / twitter.com/mikegalvin_ / discord.gg/5ZsnJ5k

.COMPANYNAME Mike Galvin

.COPYRIGHT (C) Mike Galvin. All rights reserved.

.TAGS Remove Clean up Microsoft Store Windows UWP in-box built-in included app Windows 10 11 Customisable removal utility

.LICENSEURI

.PROJECTURI https://gal.vin/posts/remove-uwp-apps/

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#
    .SYNOPSIS
    Remove MS Store Apps - Customisable Windows 10/11 Microsoft Store app removal utility

    .DESCRIPTION
    Removes apps included in Windows 10/11

    To retrieve the names of the apps available to all users, run the following command in an elevated PowerShell session:

    Get-AppxProvisionedPackage -Online | Select Displayname

    To retrieve the names of the apps available to only the current user, run the following command in a PowerShell session:
    Get-AppxPackage | Select Name

    .PARAMETER List
    The full path to the txt file listing the apps to remove.

    .PARAMETER Wim
    The full path to the wim file to remove the apps from.

    .PARAMETER WimIndex
    The index number of the image to operate on.
    Run the following command to find out what images are present in the wim file:
    Get-WindowsImage -ImagePath "C:\foo\Windows 10\sources\install.wim" | Format-Table -Property ImageIndex, ImageName

    .PARAMETER WimMountPath
    The full path to a folder that the wim file should be mounted to.

    .PARAMETER NoBanner
    Use this option to hide the ASCII art title in the console.

    .PARAMETER L
    The path to output the log file to.
    The file name will be Remove-MS-Store-Apps_YYYY-MM-dd_HH-mm-ss.log
    Do not add a trailing \ backslash.

    .EXAMPLE
    Remove-MS-Store-Apps.ps1 -List C:\scripts\w10-apps-2004.txt -L C:\scripts\logs

    The above command will remove the apps in the specified text file from the running system for all users, and will generate a log file.
#>

## Set up command line switches.
[CmdletBinding()]
Param(
    [parameter(Mandatory=$True)]
    [alias("List")]
    $AppListFile,
    [alias("Wim")]
    $WimFile,
    [alias("WimIndex")]
    $WIndex,
    [alias("WimMountPath")]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    $WimMntPath,
    [alias("L")]
    $LogPath,
    [switch]$NoBanner)

If ($NoBanner -eq $False)
{
    Write-Host -Object ""
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                                     "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "    _____                                 __  __  _____    _____ _                   "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   |  __ \                               |  \/  |/ ____|  / ____| |                  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   | |__) |___ _ __ ___   _____   _____  | \  / | (___   | (___ | |_ ___  _ __ ___   "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   |  _  // _ \ '_ ' _ \ / _ \ \ / / _ \ | |\/| |\___ \   \___ \| __/ _ \| '__/ _ \  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   | | \ \  __/ | | | | | (_) \ V /  __/ | |  | |____) |  ____) | || (_) | | |  __/  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   |_|  \_\___|_| |_| |_|\___/ \_/ \___| |_|_ |_|_____/  |_____/ \__\___/|_|  \___|  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "       /\                     | |  | | | (_) (_) |                                   "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "      /  \   _ __  _ __  ___  | |  | | |_ _| |_| |_ _   _                            "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "     / /\ \ | '_ \| '_ \/ __| | |  | | __| | | | __| | | |                           "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "    / ____ \| |_) | |_) \__ \ | |__| | |_| | | | |_| |_| |                           "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   /_/    \_\ .__/| .__/|___/  \____/ \__|_|_|_|\__|\__, |                           "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "            | |   | |                                __/ |        Mike Galvin        "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "            |_|   |_|        Version 21.12.08       |___/       https://gal.vin      "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                                     "
    Write-Host -Object ""
}

## If logging is configured, start logging.
## If the log file already exists, clear it.
If ($LogPath)
{
    ## Make sure the log directory exists.
    $LogPathFolderT = Test-Path $LogPath

    If ($LogPathFolderT -eq $False)
    {
        New-Item $LogPath -ItemType Directory -Force | Out-Null
    }

    $LogFile = ("Remove-MS-Store-Apps_{0:yyyy-MM-dd_HH-mm-ss}.log" -f (Get-Date))
    $Log = "$LogPath\$LogFile"

    $LogT = Test-Path -Path $Log

    If ($LogT)
    {
        Clear-Content -Path $Log
    }

    Add-Content -Path $Log -Encoding ASCII -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") [INFO] Log started"
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
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [INFO] $Evt"
        }
        
        Write-Host -Object "$(Get-DateFormat) [INFO] $Evt"
    }

    If ($Type -eq "Succ")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [SUCCESS] $Evt"
        }

        Write-Host -ForegroundColor Green -Object "$(Get-DateFormat) [SUCCESS] $Evt"
    }

    If ($Type -eq "Err")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [ERROR] $Evt"
        }

        Write-Host -ForegroundColor Red -BackgroundColor Black -Object "$(Get-DateFormat) [ERROR] $Evt"
    }

    If ($Type -eq "Conf")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$Evt"
        }

        Write-Host -ForegroundColor Cyan -Object "$Evt"
    }
}

## Configure the apps to be removed.
$AppsList = Get-Content $AppListFile

## getting Windows Version info
$OSVMaj = [environment]::OSVersion.Version | Select-Object -expand major
$OSVMin = [environment]::OSVersion.Version | Select-Object -expand minor
$OSVBui = [environment]::OSVersion.Version | Select-Object -expand build
$OSV = "$OSVMaj" + "." + "$OSVMin" + "." + "$OSVBui"

##
## Display the current config and log if configured.
##

Write-Log -Type Conf -Evt "************ Running with the following config *************."
Write-Log -Type Conf -Evt "Utility Version:.......21.12.08"
Write-Log -Type Conf -Evt "Hostname:..............$Env:ComputerName."
Write-Log -Type Conf -Evt "Windows Version:.......$OSV."
Write-Log -Type Conf -Evt "Using list from file:..$AppListFile."

If ($Null -ne $WimFile)
{
    Write-Log -Type Conf -Evt "Wim File:..............$WimFile."
}

else {
    Write-Log -Type Conf -Evt "Wim File:..............No Config"
}

If ($Null -ne $WIndex)
{
    Write-Log -Type Conf -Evt "Wim Index:.............$WIndex."
}

else {
    Write-Log -Type Conf -Evt "Wim Index:.............No Config."
}

If ($Null -ne $WimMntPath)
{
    Write-Log -Type Conf -Evt "Wim Mount Path:........$WimMntPath."
}

else {
    Write-Log -Type Conf -Evt "Wim Index:.............No Config."
}

If ($Null -ne $LogPath)
{
    Write-Log -Type Conf -Evt "Logs directory:........$LogPath."
}

else {
    Write-Log -Type Conf -Evt "Logs directory:........No Config"
}

Write-Log -Type Conf -Evt "Apps to remove:"

ForEach ($App in $AppsList)
{
    Write-Log -Type Conf -Evt ".......................$App"
}

Write-Log -Type Conf -Evt "************************************************************"
Write-Log -Type Info -Evt "Process started"
##
## Display current config ends here.
##

##
## Online Mode
##

If ($Null -eq $WimFile)
{
    ## Remove the Apps listed in the file or report if app not present.
    ForEach ($App in $AppsList)
    {
        $PackageFullName = (Get-AppxPackage $App).PackageFullName
        $ProPackageFullName = (Get-AppxProvisionedPackage -Online | Where-Object {$_.Displayname -eq $App}).PackageName

        If ($PackageFullName)
        {
            Write-Log -Type Info -Evt "Removing Package: $App"
            Remove-AppxPackage -Package $PackageFullName | Out-Null
        }

        else {
            Write-Log -Type Info -Evt "Unable to find package: $App"
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

    Write-Log -Type Info -Evt "Process finished."
}

##
## Offline Mode
##

If ($Null -ne $WimFile)
{
    ## Mount the Image
    Mount-WindowsImage –ImagePath $WimFile –Index $WIndex –Path $WimMntPath

    ## Remove the Apps listed above or report if app not present
    ForEach ($App in $AppsList)
    {
        $ProPackageFullName = (Get-AppxProvisionedPackage -Path $WimMntPath | Where-Object {$_.Displayname -eq $App}).PackageName

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

    ## Dismount the image and save changes
    Dismount-WindowsImage –Path $WimMntPath -Save

    Write-Log -Type Info -Evt "Process finished."
}

## End
