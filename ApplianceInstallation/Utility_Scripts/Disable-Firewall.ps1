<#
  .SYNOPSIS

  .DESCRIPTION
        Disables Firewall

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Disable-Firewall.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>

Function Get-IsFirewallProfileEnabled([string]$profile)
{
    Return [bool](Get-NetFirewallProfile -name $profile | Where-Object Enabled -eq "True")
}


# If the firewall for some of the 3 profiles is not enabled
if ( -not(Get-IsFirewallProfileEnabled("Domain")) -and -not(Get-IsFirewallProfileEnabled("Private")) -and -not(Get-IsFirewallProfileEnabled("Public")) )
{
    Write-Output "Firewall is Already Disabled" -ForegroundColor Green

}
else {
    Write-Host "Disabling Firewall" -ForegroundColor Yellow
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
        if ( -not(Get-IsFirewallProfileEnabled("Domain")) -and -not(Get-IsFirewallProfileEnabled("Private")) -and -not(Get-IsFirewallProfileEnabled("Public")) )
        {
            Write-Output "Firewall is successfully disabled" -ForegroundColor Green
        }else {
            Write-Output "Unable to Disable Firewall" -ForegroundColor Red
        }

}