Write-Host "Starting Post-OS Installation Phase" -ForegroundColor Green

Invoke-Expression ".\Copy-DeployToCDrive.ps1"
Invoke-Expression ".\Install-DellFirmwareUpdates.ps1"
Invoke-Expression ".\Disable-IESec.ps1"
Invoke-Expression ".\Disable-UAC.ps1"
Invoke-Expression ".\Enable-RDP.ps1"
Invoke-Expression ".\Instal-OMSA.ps1"
Invoke-Expression ".\Install-Chrome.ps1"

Write-Host "Post-OS Installation Phase Complete" -ForegroundColor Green
Write-Host "Please Configure Team Nic and Hyper-V Switch" -ForegroundColor Green
Write-Host "Then Use VM Build Scripts" -ForegroundColor Green
