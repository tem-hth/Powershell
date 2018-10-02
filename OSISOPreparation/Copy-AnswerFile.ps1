$WindowsInstallerSource = "C:\Deploy\OS\WinServer2016"
$AnswerFile = "..\..\AnswerFiles\WinServer2016DC\mesapp\autounattend.xml" 

if(TestPath "$WindowsInstallerSource\autounattend.xml") {
    Write-Host "Answer File already Exist" -ForegroundColor Red
    Write-Host "Deleting old Answer File" -ForegroundColor Yellow
    Remove-Item "$WindowsInstallerSource\autounattend.xml"
    Write-Host "Copying Answer File" -ForegroundColor Green
    Copy-Item $AnswerFile
}
else {
    Write-Host "Copying Answer File" -ForegroundColor Green
    Copy-Item $AnswerFile 
}
