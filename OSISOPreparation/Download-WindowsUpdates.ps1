<#
    .SYNOPSIS

    .DESCRIPTION
        Downloads Windows Updates using wsusoffline

	.NOTES
		Created on: 	9/18/2018
		Created by: 	Temitope Ogunfiditmii
		Filename:		Download-WindowsUpdates.ps1
		Credits:		
		Requirements:	The installers executed via this script typically needs "Run As Administrator"
        Requires:       PSSoftware.psm1
#>

#Import-Module .\PSSoftware.psm1


$UnzipPath = ".\SoftwarePackages"
$WSUSOfflineRoot ="$UnzipPath\wsusoffline"
$TempPath = $env:TEMP; 

# Number of Seconds to Pause after Script Execution
$onScreenDelay = 5


$isInstalled = Test-Path "$WSUSOfflineRoot\UpdateGenerator.exe"
if($isInstalled){
    Write-Host "WSUS is Installed" -ForegroundColor Green
    Write-Host "Downloading Windows Updates - Please Wait" -ForegroundColor Yellow
    Start-Process "$WSUSOfflineRoot\cmd\DownloadUpdates.cmd" -Args "w100-x64 glb /verify" -Wait -PassThru


}