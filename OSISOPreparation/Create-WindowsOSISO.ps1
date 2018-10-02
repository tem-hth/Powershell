<#
    .SYNOPSIS

    .DESCRIPTION
        Creates Windows OS ISO

	.NOTES
		Created on: 	9/18/2018
		Created by: 	Temitope Ogunfiditmii
		Filename:		Create-WindowsOSISO.ps1
		Credits:		
		Requirements:	The installers executed via this script typically needs "Run As Administrator"
        Requires:       PSSoftware.psm1
#>


# Path to the Extracted or Mounted Windows ISO 
$ISOMediaFolder = "C:\Deploy\OS\WinServer2016\"
 
# Path to new re-mastered ISO
$ISOFile = 'C:\Deploy\ISO\WinServer2016_App.iso'
$ISOPath = "C:\Deploy\ISO"
 
# Need to specify the root directory of the oscdimg.exe utility which you need to download
$PathToOscdimg = 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg'
 
# Instead of pointing to normal efisys.bin, use the *_noprompt instead
$BootData='2#p0,e,b"{0}"#pEF,e,b"{1}"' -f "$ISOMediaFolder\boot\etfsboot.com","$ISOMediaFolder\efi\Microsoft\boot\efisys_noprompt.bin"

if (Test-Path $ISOPath) {
    if (Test-Path $ISOFile) {
        Write-Host "ISO Already Exist." -ForegroundColor Red
        Write-Host "Deleting old ISO" -ForegroundColor Yellow
        Remove-Item $ISOFile
    }
    Write-Host "Creating ISO Image" -ForegroundColor Yellow 
    # re-master Windows ISO
    $createISOProcess = Start-Process -FilePath "$PathToOscdimg\oscdimg.exe" -ArgumentList @("-bootdata:$BootData",'-u2','-udfver102',"$ISOMediaFolder","$ISOFile") -PassThru -Wait -NoNewWindow
    if (Test-Path $ISOFile) {
        Write-Host "Image Creation Process Complete" -ForegroundColor Green
    } else {
        Write-Host "Unable to create ISO" -ForegroundColor Red
    
    }
    
} else  {
    Write-Host "ISO Destination Path Does Not Exist" -ForegroundColor Red
    Write-Host "Creating Destination Path: $ISOPath" -ForegroundColor Yellow
    New-Item "$ISOPath" -ItemType Directory -Force
    if (Test-Path $ISOPath) {
        if (Test-Path $ISOFile) {
        Write-Host "ISO Already Exist." -ForegroundColor Red
        Write-Host "Deleting old ISO" -ForegroundColor Yellow
        Remove-Item $ISOFile
        }
        Write-Host "Creating ISO Image" -ForegroundColor Yellow 
        # re-master Windows ISO
        $createISOProcess = Start-Process -FilePath "$PathToOscdimg\oscdimg.exe" -ArgumentList @("-bootdata:$BootData",'-u2','-udfver102',"$ISOMediaFolder","$ISOFile") -PassThru -Wait -NoNewWindow
        if (Test-Path $ISOFile) {
        Write-Host "Image Creation Process Complete" -ForegroundColor Green
        } else {
        Write-Host "Unable to create ISO" -ForegroundColor Red
    
        }
        
    
    }

}


	


