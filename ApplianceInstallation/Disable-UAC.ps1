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



if ([int]$version -ge 6) {
  $RegValueConsent = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" 
  $RegValueEnableLUA = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" 
  
  if(($RegValueConsent.ConsentPromptBehaviorAdmin -eq 0) -and ($RegValueEnableLUA.EnableLUA -eq 0) ){
    Write-Host "UAC is Already Disabled" -ForegroundColor Green 
  }else {
    Write-Host "UAC Not Enabled" -ForegroundColor Red 
    Write-Host "Disabling UAC" -ForegroundColor Yellow 
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
    $RegValueConsentCheckSet = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" 
    $RegValueEnableLUACheckSet = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA"   
    if(($RegValueConsentCheckSet.ConsentPromptBehaviorAdmin -eq 0) -and ($RegValueEnableLUACheckSet.EnableLUA -eq 0)) {
        Write-Host "UAC is Enabled" -ForegroundColor Green
    } 
    else {
        Write-Host "Setting UAC Failed - Check Permissions" - -ForegroundColor Red
    }
  
  }

} 
else {
    Write-Host "Windows Version Not Supported" -ForegroundColor Red
}