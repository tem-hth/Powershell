<#
  .SYNOPSIS

  .DESCRIPTION
        Team Network Cards

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Configure-TeamNic.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>

$Team1Name = "Team1"
$Team2Name = "Team2"



#Use Get-Netadapter to get network port names
$Member1Name = "Ethernet"
$Member2Name = "Ethernet 2"
$Member3Name = "Ethernet 3"
$Member4Name = "Ethernet 4"

$Team1Config = $Member1Name,$Member2Name
$Team2Config = $Member3Name,$Member4Name

$Team1Mode = "SwitchIndependent"
$Team2Mode = "SwitchIndependent"

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


