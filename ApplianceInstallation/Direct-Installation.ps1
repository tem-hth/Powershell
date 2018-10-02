<#
  .SYNOPSIS

  .DESCRIPTION
        Direct Installation

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Direct-Installation.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>

Import-Module ".\Utility_Scripts\Add-AdminUser.ps1"
Import-Module ".\Utility_Scrupts\Add-StandardUser.ps1"

# Import config file
[xml]$ConfigFile = Get-Content ".\MES-Config.xml"



Write-Host "Script to configure Mindseyes Solutions Appliance" -ForegroundColor Blue



$adminUser = Read-Host "Please provide a username to be admin - Default is mesadmin: "
if($adminUser) {
    Add-AdminUser $adminUser
}else {
    Add-AdminUser $ConfigFile.UserAccounts.DefaultAdmin
}

$serviceUser = Read-Host "Please provide a username to be service - Default is messervice: "
if($serviceUser) {
    Add-AdminUser $serviceUser
}else {
    Add-AdminUser $ConfigFile.UserAccounts.DefaultService
}

$standardUser = Read-Host "Please provide a username for standard user - Default is mesuser: "
if($standardUser) {
    Add-StandardUser $standardUser
}else {
    Add-StandardUser $ConfigFile.UserAccounts.DefaultUser
}


Invoke-Expression ".\Install-DellFirmwareUpdates.ps1"
Invoke-Expression ".\Disable-IESec.ps1"
Invoke-Expression ".\Disable-UAC.ps1"
Invoke-Expression ".\Enable-RDP.ps1"
Invoke-Expression ".\Instal-OMSA.ps1"
Invoke-Expression ".\Install-Chrome.ps1"
Invoke-Expression ".\Install-HyperV.ps1"