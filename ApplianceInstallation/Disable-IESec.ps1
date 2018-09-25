<#
  .SYNOPSIS

  .DESCRIPTION
        Disables Internet Explorer Ehanced Security

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Disable-IESec.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>


#
# Define Environment Variables
# Define Registry Key for Admin and Current User for IE Enhanced Security 
#
$IE_ES_Admin_Key="HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$IE_ES_User_Key="HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
#
# Check Registry Key - System Profile Key Exists
#
Clear-Host
if ((Test-Path -Path $IE_ES_Admin_Key)) {
    $ARegistryValue=(Get-ItemProperty -Path $IE_ES_Admin_Key -Name IsInstalled).IsInstalled
    if ($IE_ES_Admin_Key -ne "") {
    if ($ARegistryValue -eq "" -or $ARegistryValue -ne 1)  {
        Write-Host `n$IE_ES_Admin_Key -BackgroundColor Black -ForegroundColor Green
        Write-Host "`nIE Enhanced Security is Already Disabled for Admin"
        write-host `n`nCurrently Registry Value is set to  $ARegistryValue `, No changes have been done. -ForegroundColor Black -BackgroundColor White

    } elseif ($ARegistryValue -eq 1) {
        Clear-Host
        Write-Host "`nIE Enhanced Security is Currently Enabled for Admin"
        Get-ItemProperty -Path $IE_ES_Admin_Key | Select-Object PSPath, IsInstalled, PSDrive | Format-List
        Write-Host "`nDisabling Now.. $IE_ES_Admin_Key `n`n##### Shown is the Updated Setting ####" -ForegroundColor DarkYellow -BackgroundColor Black
     
        Set-ItemProperty -Path $IE_ES_Admin_Key -Name "IsInstalled" -Value 0 -Force
        Get-ItemProperty -Path $IE_ES_Admin_Key | Select-Object PSPath, IsInstalled, PSDrive | Format-List
        }
    }
} 
#
# Check Registry Key - User Profile Key Exists
#
if ((Test-Path -Path $IE_ES_User_Key)) {
    $URegistryValue=(Get-ItemProperty -Path $IE_ES_User_Key -Name IsInstalled).IsInstalled
    if ($URegistryValue -eq "" -or $URegistryValue -ne 1)  {
        Write-Host `n$IE_ES_User_Key -BackgroundColor Black -ForegroundColor Green
        Write-Host "`nIE Enhanced Security is Already Disabled for User"
        write-host `n`nCurrently Registry Value is set to $URegistryValue `, No changes have been done.`n -ForegroundColor Black -BackgroundColor White

    } elseif ($URegistryValue -eq 1) {
        Write-Host "`nIE Enhanced Security is Currently Enabled for User"
        Get-ItemProperty -Path $IE_ES_User_Key | Select-Object PSPath, IsInstalled, PSDrive | Format-List
        Write-Host "`nDisabling Now.. $IE_ES_Admin_Key `n`n##### Shown is the Updated Setting ####" -ForegroundColor Yellow -BackgroundColor Black
        
        Set-ItemProperty -Path $IE_ES_User_Key -Name "IsInstalled" -Value 0 -Force
        Get-ItemProperty -Path $IE_ES_User_Key | Select-Object PSPath, IsInstalled, PSDrive | Format-List
    }
    } else {
    Write-Host "`nIE Enahanced Security Registry Keys in (Admin and User) - Is Not Configured"
    Write-host "`n $IE_ES_Admin_Key `n $IE_ES_User_Key " -ForegroundColor Black -BackgroundColor Cyan
    Write-Host "`nReigstry Key Not Found!" -ForegroundColor White -BackgroundColor Red
    }