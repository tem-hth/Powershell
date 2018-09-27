$WindowsInstallerSource = "C:\Deploy\OS\WinServer2016"
$WSUSWindowsUpdatePath = ".\SoftwarePackages\wsusoffline\client\w100-x64\glb"
$TempPath = $env:TEMP;
$MountPoint = "$TempPath\WinMount"
if (Test-Path $MountPoint)  {
    Write-Host "Mount Point Exist" -ForegroundColor Green
    Write-Host "Slipstreaming Updates - Please Wait" -ForegroundColor Yellow
    Start-Process dism -Args "/mount-wim /wimfile:$WindowsInstallerSource\sources\install.wim /mountdir:$MountPoint /index:1" -Verb RunAs -Wait -PassThru

    $cabs = get-childitem $WSUSWindowsUpdatePath -Recurse | where-object name -like "*.cab"
    foreach ($cab in $cabs) {
    $fullcab = $cab.fullname
    Start-Process dism -Args "/image:$MountPoint /add-package /packagepath:$fullcab" -Verb RunAs -Wait -PassThru
    } #foreach

    Write-Host "Slipstream Complete"  -ForegroundColor Green
    Start-Process dism -Args "/unmount-wim /mountdir:$MountPoint /commit" -Verb RunAs -Wait -PassThru
}else {
    Write-Host "Mount Point does not exist." -ForegroundColor Red
    Write-Host "Creating the Mount Point" -ForegroundColor Yellow
    New-Item -Path $MountPoint -ItemType Directory
    if(Test-Path  $MountPoint){
        Write-Host "Mount Point created successfully" -ForegroundColor Green
        Write-Host "Slipstreaming Updates - Please Wait" -ForegroundColor Yellow
        Start-Process dism -Args "/mount-wim /wimfile:$WindowsInstallerSource\sources\install.wim /mountdir:$MountPoint /index:1" -Verb RunAs -Wait -PassThru

        $cabs = get-childitem $WSUSWindowsUpdatePath -Recurse | where-object name -like "*.cab"
        foreach ($cab in $cabs) {
        $fullcab = $cab.fullname
        Start-Process dism -Args "/image:$MountPoint /add-package /packagepath:$fullcab" -Verb RunAs -Wait -PassThru
        } #foreach

        Write-Host "Slipstream Complete"  -ForegroundColor Green
        Start-Process dism -Args "/unmount-wim /mountdir:$MountPoint /commit" -Verb RunAs -Wait -PassThru
    
    } else {
        Write-Host "Unable to create mount point" -ForegroundColor Red
    }
}



