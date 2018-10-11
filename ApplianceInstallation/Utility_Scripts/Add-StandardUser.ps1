<#
  .SYNOPSIS

  .DESCRIPTION
        Create Standard User

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Add-StandardUser.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>


$Account = "mesuser"

function Add-StandardUser {
    Param($Account)

    if ((Get-LocalUser -Name $Account).Count -eq 1) {
        Write-Host "$Account Service Account Already Exist" -Foreground Green
    }
    else{
        Write-Host "Creating $Account Service Account" -ForegroundColor Yellow
        $AccountPW = Read-Host -Prompt "Please enter a password for $Account :" -AsSecureString
        New-LocalUser $Account -Password $AccountPW -FullName $Account 
        Add-LocalGroupMember -Group "Administrators" -Member $Account
        if((Get-LocalUser -Name $Account).Count -eq 1) {
            Write-Host "$Account has been created." -ForegroundColor Green
            return $AccountPW
        }else {
            Write-Host "Unable to create Service Account" -ForegroundColor Red
        }

    }
}