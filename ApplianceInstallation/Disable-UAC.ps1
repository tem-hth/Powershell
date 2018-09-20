<#
  .SYNOPSIS

  .DESCRIPTION
        Disables UAC

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Disable-UAC.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>



$osversion = (Get-CimInstance Win32_OperatingSystem).Version
$version = $osversion.split(".")[0]



if ($version -eq 10) {

  $RegValue = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" 
  if($RegValue.ConsentPromptBehaviorAdmin -eq 0 ){
    Write-Host "UAC is Already Disabled" -ForegroundColor Green 
  }else {
    Write-Host "UAC Not Enabled" -ForegroundColor Red 
    Write-Host "Disabling UAC" -ForegroundColor Yellow 
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
  }

} ElseIf ($Version -eq 6) {
	$sub = $version.split(".")[1]
    if ($sub -eq 1 -or $sub -eq 0) {
		Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
    } Else {
		Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
    }
} ElseIf ($Version -eq 5) {
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
} Else {
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
}


