Write-Host "Executing Install Dot Net 4.7"

$Path = $env:TEMP; 
$Installer = "NDP47-KB3186497-x86-x64-AllOS-ENU.exe"; 
Invoke-WebRequest "https://download.microsoft.com/download/D/D/3/DD35CC25-6E9C-484B-A746-C5BE0C923290/NDP47-KB3186497-x86-x64-AllOS-ENU.exe" -OutFile $Path\$Installer; 
Start-Process -FilePath $Path\$Installer -Args "/q /norestart" -Verb RunAs -Wait; 
Remove-Item $Path\$Installer
