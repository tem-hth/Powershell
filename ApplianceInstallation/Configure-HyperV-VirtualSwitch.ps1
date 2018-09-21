<#
  .SYNOPSIS

  .DESCRIPTION
        Configure Hyper V Virtual Switch

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Configure-HyperV-VirtualSwitch.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>

#Select Team or Ethernet Adapter to use
$NetAdapater = "Team1"
#Select Hyper V Virtual Switch Name
$VMSwitchName = "VirtualSwitch"

if ((Get-VMSwitch -Name $VMSwitchName).Count -eq 1 ) {
    Write-Host "$VMSwitchName is already configured as Hyper V Virtual Switch"
}else {
    Write-Host "$VMSwitchName is not configured as Hyper V Virtual Switch" -ForegroundColor Red
    Write-Host "Configuring $VMSwitchName as a Hyper V Virtual Switch" -ForegroundColor Yellow
    New-VMSwitch -Name $VMSwitchName -AllowManagementOS $True -NetAdapterName $NetAdapater
    if((Get-VMSwitch -Name $VMSwitchName).Count -eq 1) {
        Write-Host "$VMSwitchName is configured as Hyper V Virtual Switch" -ForegroundColor Green
    }else {
        Write-Host "Unable to configure Hyper V Virtual Switch"  -ForegroundColor Red
    }
}
