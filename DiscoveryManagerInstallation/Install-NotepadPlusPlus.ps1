<#
    .SYNOPSIS

    .DESCRIPTION
        Checks and Installs Notepad Plus Plus Version: 69.0.3497.100

	.NOTES
		Created on: 	9/18/2018
		Created by: 	Temitope Ogunfiditmii
		Filename:		Install-NotepadPlusPlus.ps1
		Credits:		
		Requirements:	The installers executed via this script typically needs "Run As Administrator"
        Requires:       PSSoftware.psm1
#>

Import-Module .\PSSoftware.psm1


$SoftwareName = "Notepad++ (64-bit x64)"
$SoftwareVersion = "7.5.8"
$SoftwareSourceInstallURI = "https://notepad-plus-plus.org/repository/7.x/7.5.8/npp.7.5.8.Installer.x64.exe"
$SoftwareInstallerFileName = "npp.7.5.8.Installer.x64.exe"
$SoftwareInstallLog = "npp.7.5.8.Installer.x64.exe.log"
$SoftwareInstallerLocalFilePath = ".\SoftwarePackages"
$TempPath = $env:TEMP; 


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
        $InstallerExecution = Start-Process "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName" -Args "/S" -Verb RunAs -Wait -PassThru

    
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
            $InstallerExecution = Start-Process "$TempPath\$SoftwareInstallerFileName" -Args "/S" -Verb RunAs -Wait -PassThru
      

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
