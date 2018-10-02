$computer = gc env:computername
$key = "aaaaa-bbbbb-ccccc-ddddd-eeeee"
$service = get-wmiObject -query "select * from SoftwareLicensingService" -computername $computer
$service.InstallProductKey($key)
$service.RefreshLicenseStatus()