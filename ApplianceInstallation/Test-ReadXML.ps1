
#Key is required to properly execute must be same key 
[Byte[]] $key = (1..16)

# Import config file

$configFilePath = ".\MES-Config.xml"
[xml]$ConfigFile = Get-Content $configFilePath
$SecureStringAsPlainText = $ConfigFile.Settings.UserAccounts.AdminPW

$SecureString = $SecureStringAsPlainText  | ConvertTo-SecureString -Key $key

$BSTR = `
[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) 


Write-Host $PlainPassword