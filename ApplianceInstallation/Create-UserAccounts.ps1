<#
  .SYNOPSIS

  .DESCRIPTION
        Create Share Directory

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Create-UserAccounts.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>


# Change to secure later
[Byte[]] $key = (1..16)

# Import config file
$configFilePath = ".\MES-Config.xml"
[xml]$ConfigFile = Get-Content $configFilePath

$adminAccount
$serviceAccount
$userAccount

# Read Account Settings from XML
if ($ConfigFile.Settings.UserAccounts.AccountAdmin){
    $adminAccount = $ConfigFile.Settings.UserAccounts.AccountAdmin
}
else {
    $adminAccount = $ConfigFile.Settings.UserAccounts.DefaultAdmin
}

if ($ConfigFile.Settings.UserAccounts.AccountService){
    $serviceAccount = $ConfigFile.Settings.UserAccounts.AccountService
}
else {
    $serviceAccount = $ConfigFile.Settings.UserAccounts.DefaultService
}

if ($ConfigFile.Settings.UserAccounts.AccountUser){
    $userAccount = $ConfigFile.Settings.UserAccounts.AccountUser
}
else {
    $userAccount = $ConfigFile.Settings.UserAccounts.DefaultUser
}





Write-Host "#### Creating three MES User Accounts #####" -ForegroundColor Yellow
$selectedAdminAccount = Read-Host "Please enter the name of the admin user(default is $adminAccount)"
$selectedAdminAccountPW = Read-Host "Please enter the password for the admin user" -AsSecureString
$selectedServiceAccount  = Read-Host "Please enter the name of the service account(default is $serviceAccount)"
$selectedServiceAccountPW = Read-Host "Please enter the password for the service account" -AsSecureString
$selectedUserAccount = Read-Host "Please enter the name of the standard user(default is $userAccount)"
$selectedUserAccountPW = Read-Host "Please enter the password for the standard user" -AsSecureString
Write-Host "You should save user config if you will like to use the credentials for VM Creation." -ForegroundColor Yellow
$saveXMLConfig = Read-Host "Do you want to save user config?(y/n)"



if (([string]::IsNullOrEmpty($selectedAdminAccount))) {
    $selectedAdminAccount = $adminAccount
}
if (([string]::IsNullOrEmpty($selectedServiceAccount))) {
    $selectedServiceAccount = $serviceAccount
}
if (([string]::IsNullOrEmpty($selectedUserAccount))) {
    $selectedUserAccount = $userAccount
}

if ($saveXMLConfig -eq "y" -or "Y") {
    $ConfigFile.Settings.UserAccounts.AccountUser = [string]$selectedUserAccount
    $userPW = $selectedUserAccountPW | ConvertFrom-SecureString -Key $key
    $ConfigFile.Settings.UserAccounts.UserPW = [string]$userPW
    $ConfigFile.Settings.UserAccounts.AccountService = [string]$selectedServiceAccount
    $servicePW = $selectedServiceAccountPW | ConvertFrom-SecureString -Key $key
    $ConfigFile.Settings.UserAccounts.ServicePW = [string]$servicePW
    $ConfigFile.Settings.UserAccounts.AccountAdmin = [string]$selectedAdminAccount
    $adminPW = $selectedAdminAccountPW | ConvertFrom-SecureString -Key $key
    $ConfigFile.Settings.UserAccounts.AdminPW = [string]$adminPW
    $ConfigFile.Save($configFilePath)
}



if ((Get-LocalUser -Name $selectedAdminAccount).Count -eq 1) {
    Write-Host "$selectedAdminAccount Account Already Exist" -Foreground Green
}
else{
    Write-Host "Creating $selectedAdminAccount  Account" -ForegroundColor Yellow
    New-LocalUser $selectedAdminAccount -Password $selectedAdminAccountPW -FullName $selectedAdminAccount 
    Add-LocalGroupMember -Group "Administrators" -Member $selectedAdminAccount
    if((Get-LocalUser -Name $selectedAdminAccount).Count -eq 1) {
        Write-Host "$selectedAdminAccount has been created." -ForegroundColor Green
    }else {
        Write-Host "Unable to create $selectedAdminAccount" -ForegroundColor Red
    }

}

if ((Get-LocalUser -Name $selectedServiceAccount).Count -eq 1) {
    Write-Host  "$selectedServiceAccount Account Already Exist" -Foreground Green
}
else{
    Write-Host "Creating $selectedServiceAccount  Account" -ForegroundColor Yellow
    New-LocalUser $selectedServiceAccount -Password $selectedServiceAccountPW -FullName $selectedServiceAccount 
    Add-LocalGroupMember -Group "Administrators" -Member $selectedServiceAccount
    if((Get-LocalUser -Name $selectedServiceAccount).Count -eq 1) {
        Write-Host "$selectedServiceAccount has been created." -ForegroundColor Green
    }else {
        Write-Host "Unable to create $selectedServiceAccount" -ForegroundColor Red
    }

}


if ((Get-LocalUser -Name $selectedUserAccount).Count -eq 1) {
    Write-Host  "$selectedUserAccount Account Already Exist" -Foreground Green
}
else{
    Write-Host "Creating $selectedUserAccount  Account" -ForegroundColor Yellow
    New-LocalUser $selectedUserAccount -Password $selectedUserAccountPW -FullName $selectedUserAccount 
    Add-LocalGroupMember -Group "Administrators" -Member $selectedUserAccount
    if((Get-LocalUser -Name $selectedUserAccount).Count -eq 1) {
        Write-Host "$selectedUserAccount has been created." -ForegroundColor Green
    }else {
        Write-Host "Unable to create $selectedUserAccount" -ForegroundColor Red
    }

}
