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


$WinADKOSCDIMGPath ="C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
$WinInstallerSource = "C:\Deploy\OS\WinServer2016"
$WinISODest = "C:\Deploy\ISO\WinServer2016.iso"
Start-Process "$WinADKOSCDIMGPATH\oscdimg.exe" -Args "-m -o -u2 -udfver102 bootdata:2#p0,e,b$WinADKOSCDIMGPATH\etfsboot.com#pEF,e,b$WinADKOSCDIMGPATH\efisys.bin $WinInstallerSource $WinISODest"


