<#
  .SYNOPSIS

  .DESCRIPTION
        Create Share Directory

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Create-ShareDrive.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>


$ShareDirectory = "D:\Share"
$ShareName = "Share"
$FullAccessUsers = "messervice, mesuser, mesadmin"
$ReadAccessUser = ""


if(Test-Path $ShareDirectory){
    Write-Host "$ShareDirectory Directory already exist." -ForegroundColor Green
    if(Get-SMBShare -Name $ShareName -ea 0){
        Write-Host "$ShareDirectory Share already exist" -ForegroundColor Green
    }else {
        Write-Host "$ShareDirectory Share does not exist" -ForegroundColor Red
        Write-Host "Creating Share" -ForegroundColor Yellow
        New-SMBShare -Name $ShareName -Path $ShareDirectory -FullAccess $FullAccessUsers -ReadAccess $ReadAccessUser -Verbose
        if(Get-SMBShare -Name $ShareName -ea 0){
            Write-Host "$ShareDirectory Share created successfully" -ForegroundColor Green
        } else {
            Write-Host "Unable to create Share: $ShareDirectory " -ForegroundColor Red 
        }
    }
}else {
    Write-Host "$ShareDirectory does not exist." -ForegroundColor Red
    Write-Host "Creating $ShareDirectory " -ForegroundColor Yellow
    New-Item $ShareDirectory -force -type directory
    if(Test-Path $ShareDirectory){
        Write-Host "$ShareDirectory Directory created successfully" -ForegroundColor Green
        Write-Host "Creating Share" -ForegroundColor Yellow
        New-SMBShare -Name $ShareName -Path $ShareDirectory -FullAccess $FullAccessUsers -ReadAccess $ReadAccessUser -Verbose
        if(Get-SMBShare -Name $ShareName -ea 0){
            Write-Host "$ShareDirectory Share created successfully" -ForegroundColor Green
        } else {
            Write-Host "Unable to create Share: $ShareDirectory " -ForegroundColor Red 
        }
    }
}
New-Item $ShareDirectory -force -type directory

