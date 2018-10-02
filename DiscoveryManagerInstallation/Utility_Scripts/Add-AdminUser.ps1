<#
  .SYNOPSIS

  .DESCRIPTION
        Create Admin User

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Add-AdminUser.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>


$Account = "mesadmin"


if ((Get-LocalUser -Name $Account).Count -eq 1) {
    Write-Host "$Account Admin Account Already Exist" -Foreground Green
}
else{
    Write-Host "Creating $Account Admin Account" -ForegroundColor Yellow
    $AccountPW = Read-Host -Prompt "Please enter a password for $Account :" -AsSecureString
    New-LocalUser $Account -Password $AccountPW -FullName $Account 
    Add-LocalGroupMember -Group "Administrators" -Member $Account
    if((Get-LocalUser -Name $Account).Count -eq 1) {
        Write-Host "$Account has been created." -ForegroundColor Green
    }else {
        Write-Host "Unable to create Admin Account" -ForegroundColor Red
    }

}