<#PSScriptInfo

.VERSION 2.0

.GUID 888f5987-8b64-4a4a-ab8e-00a1bc99ff54

.AUTHOR Mike Galvin twitter.com/mikegalvin_

.COMPANYNAME Mike Galvin

.COPYRIGHT (C) Mike Galvin. All rights reserved.

.TAGS Microsoft Store Windows UWP in-box apps

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
    Removes specified UWP/Microsoft Store in-box apps from Windows 10

    .DESCRIPTION
    Remove UWP/Microsoft Store in-box apps from Windows 10
    To retreive the names of the apps availble to all users, run the following command in an elevated PowerShell session:
    Get-AppxProvisionedPackage -Online | Select Displayname

    To retreive the names of the apps availble to only the current user, run the following command in a PowerShell session:
    Get-AppxPackage | Select Name

    .PARAMETER List
    The full path to the txt file listing the apps to remove.

    .EXAMPLE
    Remove-UWP-Apps.ps1 -List C:\foo\uwp-apps-1909.txt

    This command will attempt to remove all UWP apps listed in the specified text file.
#>

# Define switches and what variables they map to.
[CmdletBinding()]
Param(
    [parameter(Mandatory=$True)]
    [alias("List")]
    $AppListFile)

# Configure the apps to be removed.
$AppsList = Get-Content $AppListFile

# Remove the Apps listed in the file or report if app not present.
ForEach ($App in $AppsList)
{
    $PackageFullName = (Get-AppxPackage $App).PackageFullName
    $ProPackageFullName = (Get-AppxProvisionedPackage -Online | Where-Object {$_.Displayname -eq $App}).PackageName
        
    If ($PackageFullName) 
    { 
        Write-Verbose "Removing Package: $App"
        Remove-AppxPackage -Package $PackageFullName 
    }
     
    Else 
    { 
        Write-Host "Unable to find package: $App" 
    } 
 
    If ($ProPackageFullName) 
    { 
        Write-Verbose "Removing Provisioned Package: $ProPackageFullName"
        Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName 
    } 

    Else 
    { 
        Write-Verbose "Unable to find provisioned package: $App" 
    }
}

# End