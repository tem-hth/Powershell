Set-ExecutionPolicy -ExecutionPolicy Bypass
Invoke-Expression ".\Disable-UAC.ps1" 
Invoke-Expression ".\Install-DellFirmware.ps1"
Invoke-Expression ".\Download-WSUSOffline.ps1"
Invoke-Expression ".\Download-WindowsUpdates.ps1"
Invoke-Expression ".\SlipStream-WindowsUpdates.ps1"
Invoke-Expression ".\Copy-AnswerFile.ps1"
Invoke-Expression ".\Create-WindowsOSISO.ps1"