
<#PSScriptInfo

.VERSION 0.0.2

.GUID c45797b3-ffa0-4463-b81a-bee0728245f6

.AUTHOR Gael Colas

.COMPANYNAME SynEdgy Limited

.COPYRIGHT (c) 2021 Gael Colas. All rights reserved.

.TAGS

.LICENSEURI https://github.com/chocolatey-community/Chocolatey/blob/master/LICENSE

.PROJECTURI https://github.com/chocolatey-community/Chocolatey/

.ICONURI https://blog.chocolatey.org/assets/images/chocolatey-icon.png

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Updated author, copyright notice, and URLs.

.PRIVATEDATA

#>

<#

.DESCRIPTION
 This is an unofficial module with DSC resource to Install and configure Chocolatey.

#>

param ()


configuration Chocolatey
{
    Import-DscResource -ModuleName Chocolatey

    Node localhost {
        ChocolateyPin AddPintoPackage {
            Ensure  = 'Absent'
            Name    = 'Putty'
            Version = '0.71'
        }
    }
}
