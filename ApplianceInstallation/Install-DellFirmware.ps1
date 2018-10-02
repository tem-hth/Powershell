
<#
    .SYNOPSIS

    .DESCRIPTION
        Checks and Installs Dell EMC OpenManage Systems Management Software	 Version: 9.1.0

	.NOTES
		Created on: 	9/18/2018
		Created by: 	Temitope Ogunfiditmii
		Filename:		Install-OMSA.ps1
		Credits:		
		Requirements:	The installers executed via this script typically needs "Run As Administrator"
        Requires:       PSSoftware.psm1
#>

Import-Module .\PSSoftware.psm1

$SoftwareName = "Dell EMC System Update"
$SoftwareVersion = "1.5.3"
$SoftwareSourceInstallURI = "https://downloads.dell.com/FOLDER04882840M/1/Systems-Management_Application_RT3W9_WN64_1.5.3_A00.EXE"
$SoftwareInstallerFileName = "Systems-Management_Application_RT3W9_WN64_1.5.3_A00.EXE"
$SoftwareInstallLog = "Systems-Management_Application_RT3W9_WN64_1.5.3_A00.EXE.log"
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
        $InstallExection = Start-Process "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName" -Args "/s" -Verb RunAs -Wait -PassThru

        if (Test-InstalledSoftware -Name $SoftwareName -Version $SoftwareVersion) {
            Write-Host "Updating Dell Firmware - Please Wait" -ForegroundColor Yellow
            $DSUExecution = Start-Process dsu.exe -Args "/q" -Verb RunAs -PassThru -Wait
            
        }
        else {
            Write-Host "Installing Software Failed" -ForegroundColor Red
        }

    }
    else{
        Write-Host "Downloading $SoftwareName Version: $SoftwareVersion" -ForegroundColor Yellow
        try {
            Invoke-WebRequest $SoftwareSourceInstallURI -OutFile $TempPath\$SoftwareInstallerFileName
            Write-Host "Installing $SoftwareName Version: $SoftwareVersion" -ForegroundColor Yellow
            $InstallExection = Start-Process "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName" -Args "/s" -Verb RunAs -Wait -PassThru

            if (Test-InstalledSoftware -Name $SoftwareName -Version $SoftwareVersion) {
                Write-Host "Updating Dell Firmware - Please Wait" -ForegroundColor Yellow
                $DSUExecution = Start-Process dsu.exe -Args "/q" -Verb RunAs -PassThru -Wait
                
            }
            else {
                Write-Host "Installing Software Failed" -ForegroundColor Red
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