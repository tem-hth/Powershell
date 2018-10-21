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

# Get command line parameter auto to determine run method - Valid values (true or false). Default to false
param([string]$auto="false") 




# Change to secure later
[Byte[]] $key = (1..16)

# Import config file
$configFilePath = ".\MES-Config.xml"
[xml]$ConfigFile = Get-Content $configFilePath

# Initialize Config Account Variables
$adminAccount
$serviceAccount
$userAccount
$adminAccountPW
$serviceAccountPW
$userAccountPW
$saveXMLConfig = "n"

# Read Account Settings from XML
if ($ConfigFile.Settings.UserAccounts.AccountAdmin){
    $adminAccount = $ConfigFile.Settings.UserAccounts.AccountAdmin
    $adminAccountPW = $ConfigFile.Settings.UserAccounts.AdminPW | ConvertTo-SecureString -Key $key
}
else {
    $adminAccount = $ConfigFile.Settings.UserAccounts.DefaultAdmin
    $adminAccountPW = $ConfigFile.Settings.UserAccounts.DefaultPW | ConvertTo-SecureString -Key $key
}

if ($ConfigFile.Settings.UserAccounts.AccountService){
    $serviceAccount = $ConfigFile.Settings.UserAccounts.AccountService
    $serviceAccountPW = $ConfigFile.Settings.UserAccounts.ServicePW | ConvertTo-SecureString -Key $key
}
else {
    $serviceAccount = $ConfigFile.Settings.UserAccounts.DefaultService
    $serviceAccountPW = $ConfigFile.Settings.UserAccounts.DefaultPW | ConvertTo-SecureString -Key $key
}

if ($ConfigFile.Settings.UserAccounts.AccountUser){
    $userAccount = $ConfigFile.Settings.UserAccounts.AccountUser
    $userAccountPW = $ConfigFile.Settings.UserAccounts.UserPW | ConvertTo-SecureString -Key $key
}
else {
    $userAccount = $ConfigFile.Settings.UserAccounts.DefaultUser
    $userAccountPW = $ConfigFile.Settings.UserAccounts.DefaultPW | ConvertTo-SecureString -Key $key
}




if ($auto -eq "false") {
    Write-Host "#### Creating three MES Accounts in Manual Mode #####" -ForegroundColor Yellow
    $selectedAdminAccount = Read-Host "Please enter the name of the admin user(default is $adminAccount)"
    $selectedAdminAccountPW = Read-Host "Please enter the password for the admin user" -AsSecureString
    $selectedServiceAccount  = Read-Host "Please enter the name of the service account(default is $serviceAccount)"
    $selectedServiceAccountPW = Read-Host "Please enter the password for the service account" -AsSecureString
    $selectedUserAccount = Read-Host "Please enter the name of the standard user(default is $userAccount)"
    $selectedUserAccountPW = Read-Host "Please enter the password for the standard user" -AsSecureString
    Write-Host "You should save user config if you will like to use the credentials for VM Creation." -ForegroundColor Yellow
    $saveXMLConfig = Read-Host "Do you want to save user config?(y/n)"
}
elseif ($auto -eq "true") {
    Write-Host "#### Creating three MES Accounts in Auto Mode #####" -ForegroundColor Yellow
} else {
    Write-Host "Invalid Mode: Options true or false" -ForegroundColor Red
    Exit
}


if (([string]::IsNullOrEmpty($selectedAdminAccount))) {
    $selectedAdminAccount = $adminAccount
    $selectedAdminAccountPW = $adminAccountPW
}
if (([string]::IsNullOrEmpty($selectedServiceAccount))) {
    $selectedServiceAccount = $serviceAccount
    $selectedServiceAccountPW = $serviceAccountPW
}
if (([string]::IsNullOrEmpty($selectedUserAccount))) {
    $selectedUserAccount = $userAccount
    $selectedUserAccountPW = $userAccountPW
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


#Add Admin Account

try{
 $getUser = Get-LocalUser -Name $selectedAdminAccount -ErrorAction Stop
 $userExist = $getUser.Count -eq 1
 if($userExist) {
    Write-Host "$selectedAdminAccount Account Already Exist" -Foreground Green
 }
}
catch{
    Write-Host "User $selectedAdminAccount does not exist" -ForegroundColor Red
    Write-Host "Creating $selectedAdminAccount  Account" -ForegroundColor Yellow
    New-LocalUser $selectedAdminAccount -Password $selectedAdminAccountPW -FullName $selectedAdminAccount 
    Add-LocalGroupMember -Group "Administrators" -Member $selectedAdminAccount
    if((Get-LocalUser -Name $selectedAdminAccount).Count -eq 1) {
        Write-Host "$selectedAdminAccount has been created." -ForegroundColor Green
    }else {
        Write-Host "Unable to create $selectedAdminAccount" -ForegroundColor Red
    }

}

#Add Service Account
try{
    $getUser = Get-LocalUser -Name $selectedServiceAccount -ErrorAction Stop
    $userExist = $getUser.Count -eq 1 
    if($userExist) {
        Write-Host  "$selectedServiceAccount Account Already Exist" -Foreground Green
    }
}
catch{
    Write-Host "User $selectedServiceAccount does not exist" -ForegroundColor Red
    Write-Host "Creating $selectedServiceAccount  Account" -ForegroundColor Yellow
    New-LocalUser $selectedServiceAccount -Password $selectedServiceAccountPW -FullName $selectedServiceAccount 
    Add-LocalGroupMember -Group "Administrators" -Member $selectedServiceAccount
    if((Get-LocalUser -Name $selectedServiceAccount).Count -eq 1) {
        Write-Host "$selectedServiceAccount has been created." -ForegroundColor Green
    }else {
        Write-Host "Unable to create $selectedServiceAccount" -ForegroundColor Red
    }

}

#Add User Account
try{
    $getUser = Get-LocalUser -Name $selectedUserAccount -ErrorAction Stop
    $userExist = $getUser.Count -eq 1
    if($userExist) {
        Write-Host  "$selectedUserAccount Account Already Exist" -Foreground Green
    }
}
catch{
    Write-Host "User $selectedUserAccount does not exist" -ForegroundColor Red
    Write-Host "Creating $selectedUserAccount  Account" -ForegroundColor Yellow
    New-LocalUser $selectedUserAccount -Password $selectedUserAccountPW -FullName $selectedUserAccount 
    Add-LocalGroupMember -Group "Administrators" -Member $selectedUserAccount
    if((Get-LocalUser -Name $selectedUserAccount).Count -eq 1) {
        Write-Host "$selectedUserAccount has been created." -ForegroundColor Green
    }else {
        Write-Host "Unable to create $selectedUserAccount" -ForegroundColor Red
    }

}

