<#
  .SYNOPSIS

  .DESCRIPTION
        Install/Check Hyper V Status

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Install-HyperV.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>

$FeatureName = "Hyper-V"
$windowFeature = Get-WindowsFeature $FeatureName

if ($windowFeature.Installed) {
    Write-Host "$FeatureName Already Installed" -ForegroundColor Green
}
else {
    Write-Host "$FeatureName is Not Installed" -ForegroundColor Red
    Write-Host "Installing $FeatureName" -ForegroundColor Yellow
    Install-WindowsFeature -Name $FeatureName -IncludeManagementTools 
    $windowFeatureCheck = Get-WindowsFeature $FeatureName
    if ($windowFeatureCheck.Installed) {
        Write-Host "$FeatureName is Installed" -ForegroundColor Green
    }
    else {
        Write-Host "Unable to Install $FeatureName" -ForegroundColor Red
    }
}


