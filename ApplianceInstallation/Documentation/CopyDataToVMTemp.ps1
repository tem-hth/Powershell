#Set Username and Password 
#Clear after completing work on VM
$secusername = "fmuser"
#PLEASE CLEAR PASSWORD ON COMPLETION OF WORK with VM
$secpassword = ConvertTo-SecureString "" -AsPlainText -Force

#Identical Path will be created on VM
$SourceFolder = "C:\Temp\Deploy"

$VMType = "DA"
$VMStartRange = 1
$VMEndRange = 10

For ($i=$VMStartRange; $i -le $VMEndRange; $i++) {
    $VMHostNumber = "{0:000}" -f $i 
    $VMHostName = "MES" + $VMType + $VMHostNumber

    $mycreds = New-Object System.Management.Automation.PSCredential($secusername,$secpassword)
    Get-ChildItem $SourceFolder -Recurse -File | % { Copy-VMFile $VMHostName -SourcePath $_.FullName -DestinationPath $_.FullName -CreateFullPath -FileSource Host}

}