$notepadPlusPlusFile = "C:\temp\Deploy\npp.7.5.8.Installer.x64.exe"
$notepadPlusPlusInstallPath = "C:\Program Files\Notepad++\notepad++.exe"
Write-Host "Installing Notepad++" -ForegroundColor Green
$npp = Start-Process $notepadPlusPlusFile -ArgumentList '/S' -Wait -Verb runas 

if ( $(Try { Test-Path $notepadPlusPlusInstallPath.trim() } Catch { $false }) ) {
   Write-Host "Notepad Plus Plus Install Successful."  -ForegroundColor Green
 }
Else {
   Write-Host "Notepad Plus Plus Install Failed." -ForegroundColor Red 
 }
