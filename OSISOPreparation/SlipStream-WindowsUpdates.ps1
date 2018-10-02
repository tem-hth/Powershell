$WindowsInstallerSource = "C:\Deploy\OS\WinServer2016"
$WSUSWindowsUpdatePath = ".\SoftwarePackages\wsusoffline\client\w100-x64\glb"
$TempPath = $env:TEMP;
$MountPoint = "$TempPath\WinMount"
if (Test-Path $MountPoint)  {
    Write-Host "Cleaning Up Orphan Mount Points" -ForegroundColor Yellow
    Dismount-WindowsImage -Path $MountPoint -Discard
    Clear-WindowsCorruptMountPoint

    #$cleanProcess = Start-Process dism -Args "/cleanup-mountPoints" -Verb RunAs -Wait -PassThru -NoNewWindow
    Write-Host "Mount Point Directory Exist" -ForegroundColor Green
    Write-Host "Mounting Windows Installer - Please Wait" -ForegroundColor Yellow
    Mount-WindowsImage -ImagePath "$WindowsInstallerSource\sources\install.wim" -Index 1 -Path $MountPoint -Optimize
    #$mountProcess = Start-Process dism -Args "/mount-wim /wimfile:$WindowsInstallerSource\sources\install.wim /mountdir:$MountPoint /index:1" -Verb RunAs -Wait -PassThru -NoNewWindow
  
  

    Write-Host "Scanning for available updates - Please Wait" -ForegroundColor Yellow
    $cabs = get-childitem $WSUSWindowsUpdatePath -Recurse | where-object name -like "*.cab"
    $msus = get-childitem $WSUSWindowsUpdatePath -Recurse | where-object name -like "*.msu"
  
    Write-Host "Slipstreaming Updates" -ForegroundColor Yellow
    Add-WindowsPackage -Path $MountPoint -PackagePath $WSUSWindowsUpdatePath 
   <# foreach ($cab in $cabs) {
        $fullcab = $cab.fullname
        Write-Host "Slipstreaming $cab" -ForegroundColor Yellow
        $cabProcess = Start-Process dism -Args "/image:$MountPoint /add-package /packagepath:$fullcab" -Verb RunAs -Wait -PassThru -NoNewWindow
    } #foreach 

    foreach ($msu in $msus) {
        $fullmsu = $msu.fullname
        Write-Host "Slipstreaming $msu" -ForegroundColor Yellow
        $msuProcess = Start-Process dism -Args "/image:$MountPoint /add-package /packagepath:$fullmsu" -Verb RunAs -Wait -PassThru -NoNewWindow
     } #foreach
    #>
    Write-Host "Slipstream Complete"  -ForegroundColor Green
    Dismount-WindowsImage -Path $MountPoint -Save 
    #$unmountProcess = Start-Process dism -Args "/unmount-wim /mountdir:$MountPoint /commit" -Verb RunAs -Wait -PassThru -NoNewWindow
}else {
    Write-Host "Mount Point Directory does not exist." -ForegroundColor Red
    Write-Host "Creating the Mount Point Directory" -ForegroundColor Yellow
    New-Item -Path $MountPoint -ItemType Directory
    if(Test-Path  $MountPoint){
        Write-Host "Mount Point Directory created successfully" -ForegroundColor Green
        Write-Host "Mounting Windows Installer - Please Wait" -ForegroundColor Yellow
        $mountProcess = Start-Process dism -Args "/mount-wim /wimfile:$WindowsInstallerSource\sources\install.wim /mountdir:$MountPoint /index:1" -Verb RunAs -Wait -PassThru -NoNewWindow
        Write-Host "Scanning for available updates - Please Wait" -ForegroundColor Yellow
        $cabs = get-childitem $WSUSWindowsUpdatePath -Recurse | where-object name -like "*.cab"
        $msus = get-childitem $WSUSWindowsUpdatePath -Recurse | where-object name -like "*.msu"

        Write-Host "Slipstreaming Updates" -ForegroundColor Yellow
        Add-WindowsPackage -Path $MountPoint -PackagePath $WSUSWindowsUpdatePath 
       <# foreach ($cab in $cabs) {
            $fullcab = $cab.fullname
            Write-Host "Slipstreaming $cab" -ForegroundColor Yellow
            $cabProcess = Start-Process dism -Args "/image:$MountPoint /add-package /packagepath:$fullcab" -Verb RunAs -Wait -PassThru -NoNewWindow
        } #foreach 

        foreach ($msu in $msus) {
            $fullmsu = $msu.fullname
            Write-Host "Slipstreaming $msu" -ForegroundColor Yellow
            $msuProcess = Start-Process dism -Args "/image:$MountPoint /add-package /packagepath:$fullmsu" -Verb RunAs -Wait -PassThru -NoNewWindow
         } #foreach
        #>
        Write-Host "Slipstream Complete"  -ForegroundColor Green
        Dismount-WindowsImage -Path $MountPoint -Save 
        #$unmountProcess = Start-Process dism -Args "/unmount-wim /mountdir:$MountPoint /commit" -Verb RunAs -Wait -PassThru -NoNewWindow
    
    } else {
        Write-Host "Unable to create mount point" -ForegroundColor Red
    }
}



