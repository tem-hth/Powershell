<#
  .SYNOPSIS

  .DESCRIPTION
        Enable Remote Desktop

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Enable-RDP.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>



	
# Import config file
[xml]$ConfigFile = Get-Content ".\MES-Config.xml"




if ($ConfigFile.Settings.RDPMembersSettings.RDPMembers) 
{
      # Set RDP Members from config file
      $RDPMembers = $ConfigFile.Settings.RDPMembersSettings.RDPMembers
}else {
      # Set RDP Members to Default settings from config file
      $RDPMembers =  $ConfigFile.Settings.RDPMembersSettings.DefaultRDPMembers
}


New-ItemProperty -Path 'HKLM:SystemCurrentControlSetControlTerminal Server' -Name 'fDenyTSConnections' -Value 0 -PropertyType dword -Force
New-ItemProperty -Path 'HKLM:SystemCurrentControlSetControlTerminal ServerWinStationsRDP-Tcp' -Name 'UserAuthentication' -Value 1 -PropertyType dword -Force
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $RDPMembers