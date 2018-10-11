<#
  .SYNOPSIS

  .DESCRIPTION
        Team Network Cards and Generates Random Mac Address for Team

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Configure-TeamNic.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>


# Import config file
[xml]$ConfigFile = Get-Content ".\MES-Config.xml"


$Team1Name = $ConfigFile.Settings.NetworkTeamSettings.Team1Name
$Team2Name = $ConfigFile.Settings.NetworkTeamSettings.Team2Name

$SelectedMembers = New-Object System.Collections.Generic.List[System.Object]
#Use Get-Netadapter to get network port names
$NicMembers = Get-NetAdapter | Sort-Object -Property Name 



Foreach ($NicMember in $NicMembers)
{
    if ($NicMember.InterfaceDescription -ne "Hyper-V Virtual Ethernet Adapter" -and $NicMember.InterfaceDescription -notmatch "Microsoft Network Adapter Multiplexor*"){
    
        #Write-Host $NicMember.Name $NicMember.InterfaceDescription
        $SelectedMembers.Add($NicMember)
    }
}

Foreach ($Member in $SelectedMembers) {

    Write-Host "Selected: " $Member.Name

}


#Use Get-Netadapter to get network port names
$Member1Name = $SelectedMembers[0].Name
$Member2Name = $SelectedMembers[1].Name
$Member3Name = $SelectedMembers[2].Name
$Member4Name = $SelectedMembers[3].Name

$Team1Config = $Member1Name,$Member2Name
$Team2Config = $Member3Name,$Member4Name


$Team1Mode = $ConfigFile.Settings.NetworkTeamSettings.Team1Mode
$Team2Mode = $ConfigFile.Settings.NetworkTeamSettings.Team2Mode

# Generates random mac address for team to prevent conflict with underlying network card.
$Team1MacAddress = Get-RandomMacAddress
$Team2MacAddress = Get-RandomMacAddress

$ListofTeams = Get-NetLbfoTeam

#Default is Two Teams 
#Todo Modify to be more flexible on number of Teams.
$NumofTeams = 2 

if ($ListofTeams.TeamNics.Count -eq $NumofTeams) {
    Write-Host "Two Teams are Already Configured" -ForegroundColor Green
}
else {
    Write-Host "Desired Number of Teams Don't Exist" -ForegroundColor Yellow
    Write-Host "Clearing Teams" -ForegroundColor Yellow
    Get-NetLbfoTeam | Remove-NetLbfoTeam -Confirm:$false
    if((Get-NetLbfoTeam).count -eq 0) {
        Write-Host "Configuring Teams" -ForegroundColor Yellow
        New-NetLbfoTeam -Name $Team1Name -TeamMembers $Team1Config -TeamingMode $Team1Mode -Confirm:$false
        New-NetLbfoTeam -Name $Team2Name -TeamMembers $Team2Config -TeamingMode $Team2Mode -Confirm:$false 
        Set-NetAdapter -Name $Team1Name -MacAddress $Team1MacAddress -Confirm:$false 
        Set-NetAdapter -Name $Team2Name -MacAddress $Team2MacAddress -Confirm:$false 

        #Check State of Teaming
        if((Get-NetLbfoTeam).TeamNics.Count -eq $NumofTeams) {
            Write-Host "Two Teams are Configured" -ForegroundColor Green
        }
        else {
            Write-Host "Error Unable to Team Nics" -ForegroundColor Red
        }


    }else {
        Write-Host "Unable to clear existing Teams" -ForegroundColor Red
    }
}
	
function Get-RandomMacAddress{
 
    $MacAddress = (0..5 | ForEach-Object { '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15),(Get-Random -Minimum 0 -Maximum 15)})  -join ':'    
    return $MacAddress
 
}



