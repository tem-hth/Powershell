$Path = $env:TEMP; 
$Installer = "SSMS-Setup-ENU.exe"; 
Invoke-WebRequest "https://download.microsoft.com/download/B/8/3/B839AD7D-DDC7-4212-9643-28E148251DC1/SSMS-Setup-ENU.exe" -OutFile $Path\$Installer; 
Start-Process -FilePath $Path\$Installer -Args "/install /quiet /norestart" -Verb RunAs -Wait; 
Remove-Item $Path\$Installer