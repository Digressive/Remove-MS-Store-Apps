<#PSScriptInfo

.VERSION 20.03.20

.GUID 888f5987-8b64-4a4a-ab8e-00a1bc99ff54

.AUTHOR Mike Galvin Contact: mike@gal.vin / twitter.com/mikegalvin_

.COMPANYNAME Mike Galvin

.COPYRIGHT (C) Mike Galvin. All rights reserved.

.TAGS Remove Clean up Microsoft Store Windows UWP in-box built-in included app Windows 10 Customisable removal utility

.LICENSEURI

.PROJECTURI 

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#
    .SYNOPSIS
    Remove Win10 Apps - Customisable Windows 10 app removal utility

    .DESCRIPTION
    Removes apps included in Windows 10
    
    To retrieve the names of the apps available to all users, run the following command in an elevated PowerShell session:

    Get-AppxProvisionedPackage -Online | Select Displayname

    To retrieve the names of the apps available to only the current user, run the following command in a PowerShell session:
    Get-AppxPackage | Select Name

    .PARAMETER List
    The full path to the txt file listing the apps to remove.

    .PARAMETER NoBanner
    Use this option to hide the ASCII art title in the console.

    .PARAMETER L
    The path to output the log file to.
    The file name will be Remove-W10-Apps_YYYY-MM-dd_HH-mm-ss.log
    Do not add a trailing \ backslash.

    .EXAMPLE
    Remove-W10-Apps.ps1 -List C:\scripts\w10-apps-1909.txt -L C:\scripts\logs

    The above command will remove the apps listed in the specified text file and will generate a log file.
#>

## Set up command line switches.
[CmdletBinding()]
Param(
    [parameter(Mandatory=$True)]
    [alias("List")]
    $AppListFile,
    [alias("L")]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    $LogPath,
    [switch]$NoBanner)

If ($NoBanner -eq $False)
{
    Write-Host -Object ""
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                                                          "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  888 88e                                                    Y8b Y8b Y888P ,e,           d88   e88 88e    "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  888 888D  ,e e,  888 888 8e   e88 88e  Y8b Y888P  ,e e,     Y8b Y8b Y8P      888 8e   d888  d888 888b   "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  888 88   d88 88b 888 888 88b d888 888b  Y8b Y8P  d88 88b     Y8b Y8b Y   888 888 88b d 888 C8888 8888D  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  888 b,   888   , 888 888 888 Y888 888P   Y8b     888   ,      Y8b Y8b    888 888 888   888  Y888 888P   "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  888 88b,   YeeP  888 888 888   88 88      Y8P      YeeP        Y8P Y     888 888 888   888    88 88     "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                                                          "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "      e Y8b                               8888 8888   d8   ,e, 888 ,e,   d8                               "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "     d8b Y8b    888 88e  888 88e   dP Y   8888 8888  d88       888      d88   Y8b Y888P                   "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "    d888b Y8b   888 888b 888 888b C88b    8888 8888 d88888 888 888 888 d88888  Y8b Y8P                    "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   d888888888b  888 888P 888 888P  Y88D   8888 8888  888   888 888 888  888     Y8b Y    Mike Galvin      "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  d8888888b Y8b 888 88   888 88   d,dP    'Y88 88P'  888   888 888 888  888      888   https://gal.vin    "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                888      888                                                     888                      "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                888      888                   Version 20.03.20 (⌐■_■)           888                      "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                                                          "
    Write-Host -Object ""
}

## If logging is configured, start logging.
## If the log file already exists, clear it.
If ($LogPath)
{
    $LogFile = ("Remove-Win10-Apps_{0:yyyy-MM-dd_HH-mm-ss}.log" -f (Get-Date))
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
Function Write-Log($Type, $Event)
{
    If ($Type -eq "Info")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [INFO] $Event"
        }
        
        Write-Host -Object "$(Get-DateFormat) [INFO] $Event"
    }

    If ($Type -eq "Succ")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [SUCCESS] $Event"
        }

        Write-Host -ForegroundColor Green -Object "$(Get-DateFormat) [SUCCESS] $Event"
    }

    If ($Type -eq "Err")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [ERROR] $Event"
        }

        Write-Host -ForegroundColor Red -BackgroundColor Black -Object "$(Get-DateFormat) [ERROR] $Event"
    }

    If ($Type -eq "Conf")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$Event"
        }

        Write-Host -ForegroundColor Cyan -Object "$Event"
    }
}

## Configure the apps to be removed.
$AppsList = Get-Content $AppListFile

##
## Display the current config and log if configured.
##
Write-Log -Type Conf -Event "************ Running with the following config *************."
Write-Log -Type Conf -Event "Using list from file:..$AppListFile."
Write-Log -Type Conf -Event "Apps to remove:........"

ForEach ($App in $AppsList)
{
    Write-Log -Type Conf -Event ".......................$App"
}

If ($Null -ne $LogPath)
{
    Write-Log -Type Conf -Event "Logs directory:........$LogPath."
}

else {
    Write-Log -Type Conf -Event "Logs directory:........No Config"
}

Write-Log -Type Conf -Event "************************************************************"
Write-Log -Type Info -Event "Process started"
##
## Display current config ends here.
##

## Remove the Apps listed in the file or report if app not present.
ForEach ($App in $AppsList)
{
    $PackageFullName = (Get-AppxPackage $App).PackageFullName
    $ProPackageFullName = (Get-AppxProvisionedPackage -Online | Where-Object {$_.Displayname -eq $App}).PackageName

    If ($PackageFullName)
    {
        Write-Log -Type Info -Event "Removing Package: $App"
        Remove-AppxPackage -Package $PackageFullName | Out-Null
    }

    else {
        Write-Log -Type Info -Event "Unable to find package: $App"
    }

    If ($ProPackageFullName)
    {
        Write-Log -Type Info -Event "Removing Provisioned Package: $ProPackageFullName"
        Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName | Out-Null
    }

    else {
        Write-Log -Type Info -Event "Unable to find provisioned package: $App"
    }
}

Write-Log -Type Info -Event "Process finished."

## End