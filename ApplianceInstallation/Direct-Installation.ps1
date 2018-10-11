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
$adminPW = ""
if($adminUser) {
    $adminPW = Add-AdminUser $adminUser

}else {
    $adminPW = Add-AdminUser $ConfigFile.UserAccounts.DefaultAdmin
}

$serviceUser = Read-Host "Please provide a username to be service - Default is messervice: "
$servicePW = ""
if($serviceUser) {
   $servicePW = Add-AdminUser $serviceUser
}else {
    $servicePW = Add-AdminUser $ConfigFile.UserAccounts.DefaultService
}

$standardUser = Read-Host "Please provide a username for standard user - Default is mesuser: "
$standardPW = ""
if($standardUser) {
    $standardPW = Add-StandardUser $standardUser
}else {
    $standardPW = Add-StandardUser $ConfigFile.UserAccounts.DefaultUser
}


Invoke-Expression ".\Install-DellFirmwareUpdates.ps1"
Invoke-Expression ".\Disable-IESec.ps1"
Invoke-Expression ".\Disable-UAC.ps1"
Invoke-Expression ".\Enable-RDP.ps1"
Invoke-Expression ".\Instal-OMSA.ps1"
Invoke-Expression ".\Install-Chrome.ps1"
Invoke-Expression ".\Install-HyperV.ps1"

Write-Host "Initial Phase of Installation Complete" -ForegroundColor Green
Write-Host "Please Configure Team Nic and Hyper-V Switch using Script" -ForegroundColor Green
Write-Host "After using Hyper-V Switch Script Use VM Build Scripts" -ForegroundColor Green
