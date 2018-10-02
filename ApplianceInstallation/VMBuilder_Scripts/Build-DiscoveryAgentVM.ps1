# Variables

$vmName = "MESDM010"
$vmHDDSize = 120GB
$vmRAMSize = 16GB
$vmCPUCount = 8
$vmSwitch = "VirtualSwitch"
$vmGen = 2
$vmNewOSVHDPath = $("D:\Hyper-V\Virtual Hard Disks\"+ $vmName + "\" + $vmName + "-OS.vhdx")
$vmConfigPath = "D:\Hyper-V\VM Configuration\"
$vmInstallISO = "C:\Deploy\ISO\WinServer2016.iso"
Write-Host "Build New Discovery Agent VM" -ForegroundColor Green
# Create VM
New-VM -Name $vmName -MemoryStartupBytes $vmRAMSize -BootDevice VHD -NewVHDPath $vmNewOSVHDPath -Path $vmConfigPath -NewVHDSizeBytes $vmHDDSize  -Generation $vmGen -Switch $vmSwitch
# Configure CPU
Set-VMProcessor $vmName -Count $vmCPUCount
# Configure DVD Install Disk
Add-VMDvdDrive -VMName $vmName -Path $vmInstallISO
Set-VMFirmware -VMName $vmName -FirstBootDevice $(Get-VMDvdDrive -VMName $vmName)
Start-VM -Name $vmName