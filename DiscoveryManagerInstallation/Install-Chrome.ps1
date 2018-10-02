<#
    .SYNOPSIS

    .DESCRIPTION
        Checks and Installs Google Chrome  Version: 69.0.3497.100

	.NOTES
		Created on: 	9/18/2018
		Created by: 	Temitope Ogunfiditmii
		Filename:		Install-Chrome.ps1
		Credits:		
		Requirements:	The installers executed via this script typically needs "Run As Administrator"
        Requires:       PSSoftware.psm1
#>

Import-Module .\PSSoftware.psm1

$SoftwareName = "Google Chrome"
$SoftwareVersion = "69.0.3497.100"
$SoftwareSourceInstallURI = "http://dl.google.com/chrome/install/375.126/chrome_installer.exe"
$SoftwareInstallerFileName = "chrome_installer.exe"
$SoftwareInstallLog = "chrome_installer.exe.log"
$SoftwareInstallerLocalFilePath = ".\SoftwarePackages"
$TempPath = $env:TEMP; 

# Number of Seconds to Pause after Script Execution
$onScreenDelay = 5

# Gets State of Software Installation
$isInstalled = Test-InstalledSoftware -Name $SoftwareName -Version $SoftwareVersion

if($isInstalled){
     Write-Host "$SoftwareName Version: $SoftwareVersion Already Installed" -ForegroundColor Green
}
else {
    Write-Host "$SoftwareName Version: $SoftwareVersion Not Installed" -ForegroundColor Red
    Write-Host "Checking Local Software Pacakages for Installer" -ForegroundColor Yellow

    if(Test-Path "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName"){
        Write-Host "Found $SoftwareName Version: $SoftwareVersion in Software Packages" -ForegroundColor Yellow
        Write-Host "Installing $SoftwareName Version: $SoftwareVersion - Please Wait" -ForegroundColor Yellow
        $InstallerExecution = Start-Process "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName" -Args "/silent /install" -Verb RunAs -Wait -PassThru

    
        if (Test-InstalledSoftware -Name $SoftwareName -Version $SoftwareVersion) {
            Write-Host "$SoftwareName Version: $SoftwareVersion is Installed" -ForegroundColor Green
        }
        else{
            Write-Host "$SoftwareName Version: $SoftwareVersion Installation Failed - Check Logs" -ForegroundColor Red
        }

    }
    else{
        Write-Host "Downloading $SoftwareName Version: $SoftwareVersion" -ForegroundColor Yellow
        try {
            Invoke-WebRequest $SoftwareSourceInstallURI -OutFile "$TempPath\$SoftwareInstallerFileName"
            Write-Host "Installing $SoftwareName Version: $SoftwareVersion - Please Wait" -ForegroundColor Yellow
            $InstallerExecution = Start-Process "$TempPath\$SoftwareInstallerFileName" -Args "/silent /install" -Verb RunAs -Wait -PassThru
      

            if (Test-InstalledSoftware -Name $SoftwareName -Version $SoftwareVersion) {
                Write-Host "$SoftwareName Version: $SoftwareVersion is Installed" -ForegroundColor Green
            }
            else{
                Write-Host "$SoftwareName Version: $SoftwareVersion Installation Failed - Check Logs" -ForegroundColor Red
            }
            # Cleans up downloaded installation file
            Remove-Item $TempPath\$SoftwareInstallerFileName
        }
        Catch {
            $weberror = $_.Exception.Message
            $error2 = $_.Exception.Response.GetResponseStream()
            $stream = New-Object System.IO.StreamReader($error2)
            $response = $stream.ReadToEnd();

            Write-Host "Error Downloading Software: $weberror" -ForegroundColor Red
        }
    }


}

#On Screen Delay - Status on Screen
Start-Sleep -Seconds $onScreenDelay