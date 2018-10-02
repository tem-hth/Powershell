<#
  .SYNOPSIS

  .DESCRIPTION
        Copy Deployment Scripts to C Drive

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Copy-DeployToCDrive.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>

$DestFolder = "C:\Deploy"
$SourceFolder = "D:\Deploy"

Write-Host "Transferring Deployment Scripts" -ForegroundColor Yellow
Copy-Item -Path $SourceFolder -Destination $DestFolder -recurse -Force