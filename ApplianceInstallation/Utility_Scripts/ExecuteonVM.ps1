#$secusername = Read-Host "Enter UserNmae" 
#$secpassword = Read-Host "Enter User Password" -AsSecureString

#Set Username and Password 
#Clear after completing work on VM
$secusername = "fmuser"
#PLEASE CLEAR PASSWORD ON COMPLETION OF WORK with VM
$secpassword = ConvertTo-SecureString '' -AsPlainText -Force



$mycreds = New-Object System.Management.Automation.PSCredential($secusername,$secpassword)
# Set VM Type DA is Discovery Agent, DM is Discovery Manger, WEB is web server, SQL is SQL Server
$VMType = "DA"
#Starting Number of VM
$VMStartRange = 1
#Ending Number of VM
$VMEndRange = 10

#Path to Script that should be executed.
$ScriptPath = "C:\temp\MapShare.ps1"


For ($i=$VMStartRange; $i -le $VMEndRange; $i++) {
    $VMHostNumber = "{0:000}" -f $i 
    $VMHostName = "MES" + $VMType + $VMHostNumber
    Write-Host "Executing Script on $VMHostName"
    

    Invoke-Command -VMName $VMHostName -FilePath $ScriptPath -Credential $mycreds

    Write-Host "Execution Complete on $VMHostName"

}