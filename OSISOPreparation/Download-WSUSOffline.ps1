<#
    .SYNOPSIS

    .DESCRIPTION
        Checks and Installs Google Chrome  Version: 69.0.3497.100

	.NOTES
		Created on: 	9/18/2018
		Created by: 	Temitope Ogunfiditmii
		Filename:		Download-WSUSOffline.ps1
		Credits:		
		Requirements:	The installers executed via this script typically needs "Run As Administrator"
        Requires:       PSSoftware.psm1
#>

#Import-Module .\PSSoftware.psm1

$SoftwareName = "WSUS Offline"
$SoftwareVersion = "11.4"
$SoftwareSourceInstallURI = "http://download.wsusoffline.net/wsusoffline114.zip"
$SoftwareInstallerFileName = "wsusoffline114.zip"
$SoftwareInstallLog = "wsusoffline114.exe.log"
$SoftwareInstallerLocalFilePath = ".\SoftwarePackages"
$UnzipPath = ".\SoftwarePackages"
$WSUSOfflineRoot ="$UnzipPath\wsusoffline"
$TempPath = $env:TEMP; 

# Number of Seconds to Pause after Script Execution
$onScreenDelay = 5

# Gets State of Software Installation
$isInstalled = Test-Path "$WSUSOfflineRoot\UpdateGenerator.exe"

if($isInstalled){
     Write-Host "$SoftwareName Version: $SoftwareVersion Already Installed" -ForegroundColor Green
}
else {
    Write-Host "$SoftwareName Version: $SoftwareVersion Not Installed" -ForegroundColor Red
    Write-Host "Checking Local Software Pacakages for Installer" -ForegroundColor Yellow

    if(Test-Path "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName"){
        Write-Host "Found $SoftwareName Version: $SoftwareVersion in Software Packages" -ForegroundColor Yellow
        Write-Host "Unzip $SoftwareName Version: $SoftwareVersion - Please Wait" -ForegroundColor Yellow
        Expand-Archive "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName" -DestinationPath $UnzipPath

    
        if (Test-Path "$WSUSOfflineRoot\UpdateGenerator.exe") {
            Write-Host "$SoftwareName Version: $SoftwareVersion is Unzipped Successfully" -ForegroundColor Green
        }
        else{
            Write-Host "$SoftwareName Version: $SoftwareVersion Installation Failed - Check Logs" -ForegroundColor Red
        }

    }
    else{
        Write-Host "Downloading $SoftwareName Version: $SoftwareVersion" -ForegroundColor Yellow
        try {
            Invoke-WebRequest $SoftwareSourceInstallURI -OutFile "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName"
            Write-Host "Unzipping $SoftwareName Version: $SoftwareVersion - Please Wait" -ForegroundColor Yellow
            Expand-Archive "$SoftwareInstallerLocalFilePath\$SoftwareInstallerFileName" -DestinationPath $UnzipPath
      

            if (Test-Path "$WSUSOfflineRoot\UpdateGenerator.exe") {
                Write-Host "$SoftwareName Version: $SoftwareVersion is Unzipped Successfully" -ForegroundColor Green
            }
            else{
                Write-Host "$SoftwareName Version: $SoftwareVersion Installation Failed - Check Logs" -ForegroundColor Red
            }
      
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