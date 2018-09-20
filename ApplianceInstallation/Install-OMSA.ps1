
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

$SoftwareName = "Dell EMC OpenManage Systems Management Software (64-Bit)"
$SoftwareVersion = "9.1.0"
$SoftwareSourceInstallURI = "https://downloads.dell.com/FOLDER04657110M/1/OM-SrvAdmin-Dell-Web-WINX64-9.1.0-2757_A00.exe"
$SoftwareInstallerFileName = "OM-SrvAdmin-Dell-Web-WINX64-9.1.0-2757_A00.exe"
$SoftwareInstallLog = "OM-SrvAdmin-Dell-Web-WINX64-9.1.0-2757_A00.log"
$SoftwareInstallerLocalFilePath = ".\SoftwarePackages"
$TempPath = $env:TEMP; 
$UnzipPath = "C:\OpenManage"
# MSI Path is relative to the unzip path
$SoftwareInstallerMSIPath = "windows\SystemsManagementx64\SysMgmtx64.msi"
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
        Write-Host "Unzipping $SoftwareName Version: $SoftwareVersion" -ForegroundColor Yellow
        $UnzipExection = Start-Process "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName" -Args "$UnzipPath /auto" -Verb RunAs -Wait -PassThru

        if (Test-Path "$UnzipPath\$SoftwareInstallerMSIPath") {
            Write-Host "Installing $SoftwareName Version: $SoftwareVersion - Please Wait" -ForegroundColor Yellow
            $InstallerExecution = Start-Process msiexec.exe -Args "/i $UnzipPath\$SoftwareInstallerMSIPath /q /passive /norestart /L*v $TempPath\$SoftwareInstallLog" -Verb RunAs -PassThru -Wait
            
        }
        else {
            Write-Host "Unzipping Software Failed" -ForegroundColor Red
        }
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
            Invoke-WebRequest $SoftwareSourceInstallURI -OutFile $TempPath\$SoftwareInstallerFileName
            Write-Host "Unzipping $SoftwareName Version: $SoftwareVersion" -ForegroundColor Yellow
            $UnzipExection = Start-Process $TempPath\$SoftwareInstallerFileName -Args "$UnzipPath /auto" -Verb RunAs -Wait -PassThru
    
            if (Test-Path $UnzipPath\$SoftwareInstallerMSIPath) {
                Write-Host "Installing $SoftwareName Version: $SoftwareVersion - Please Wait" -ForegroundColor Yellow
                $InstallerExecution = Start-Process msiexec.exe -Args "/i $UnzipPath\$SoftwareInstallerMSIPath /q /passive /norestart /L*v $TempPath\$SoftwareInstallLog" -Verb RunAs -PassThru -Wait
                
            }
            else {
                Write-Host "Unzipping Software Failed" -ForegroundColor Red
            }

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