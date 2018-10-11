<#
  .SYNOPSIS

  .DESCRIPTION
        Team Network Cards and Generates Random Mac Address for Team

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Configure-TeamNic.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>


# Import config file
[xml]$ConfigFile = Get-Content ".\MES-Config.xml"


$Team1Name = $ConfigFile.Settings.NetworkTeamSettings.Team1Name
$Team2Name = $ConfigFile.Settings.NetworkTeamSettings.Team2Name



#Use Get-Netadapter to get network port names
$Member1Name = $ConfigFile.Settings.NetworkTeamSettings.Member1Name
$Member2Name = $ConfigFile.Settings.NetworkTeamSettings.Member2Name
$Member3Name = $ConfigFile.Settings.NetworkTeamSettings.Member3Name
$Member4Name = $ConfigFile.Settings.NetworkTeamSettings.Member4Name

$Team1Config = $ConfigFile.Settings.NetworkTeamSettings.Team1Config
$Team2Config = $ConfigFile.Settings.NetworkTeamSettings.Team2Config

$Team1Mode = $ConfigFile.Settings.NetworkTeamSettings.Team1Mode
$Team2Mode = $ConfigFile.Settings.NetworkTeamSettings.Team2Mode

# Generates random mac address for team to prevent conflict with underlying network card.
$Team1MacAddress = Get-RandomMacAddress
$Team2MacAddress = Get-RandomMacAddress

$ListofTeams = Get-NetLbfoTeam

#Default is Two Teams 
#Todo Modify to be more flexible on number of Teams.
$NumofTeams = 2 

if ($ListofTeams.TeamNics.Count -eq $NumofTeams) {
    Write-Host "Two Teams are Already Configured" -ForegroundColor Green
}
else {
    Write-Host "Desired Number of Teams Don't Exist" -ForegroundColor Yellow
    Write-Host "Clearing Teams" -ForegroundColor Yellow
    Get-NetLbfoTeam | Remove-NetLbfoTeam -Confirm:$false
    if((Get-NetLbfoTeam).count -eq 0) {
        Write-Host "Configuring Teams" -ForegroundColor Yellow
        New-NetLbfoTeam -Name $Team1Name -TeamMembers $Team1Config -TeamingMode $Team1Mode -Confirm:$false
        New-NetLbfoTeam -Name $Team2Name -TeamMembers $Team2Config -TeamingMode $Team2Mode -Confirm:$false 
        Set-NetAdapter -Name $Team1Name -MacAddress $Team1MacAddress
        Set-NetAdapter -Name $Team2Name -MacAddress $Team2MacAddress

        #Check State of Teaming
        if((Get-NetLbfoTeam).TeamNics.Count -eq $NumofTeams) {
            Write-Host "Two Teams are Configured" -ForegroundColor Green
        }
        else {
            Write-Host "Error Unable to Team Nics" -ForegroundColor Red
        }


    }else {
        Write-Host "Unable to clear existing Teams" -ForegroundColor Red
    }
}
	
function Get-RandomMacAddress{
 
    $MacAddress = (0..5 | ForEach-Object { '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15),(Get-Random -Minimum 0 -Maximum 15)})  -join ':'    
    return $MacAddress
 
}


# SIG # Begin signature block
# MIIOCgYJKoZIhvcNAQcCoIIN+zCCDfcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvgDr6QPX5Xj5PTTd9JR3RFRp
# LUmgggtBMIIFWTCCBEGgAwIBAgIQHvPrkrypow2D/voZH0ZhxTANBgkqhkiG9w0B
# AQsFADB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEj
# MCEGA1UEAxMaQ09NT0RPIFJTQSBDb2RlIFNpZ25pbmcgQ0EwHhcNMTgxMDAyMDAw
# MDAwWhcNMTkxMDAyMjM1OTU5WjCBpzELMAkGA1UEBhMCVVMxDjAMBgNVBBEMBTIw
# MDExMR0wGwYDVQQIDBREaXN0cmljdCBvZiBDb2x1bWJpYTETMBEGA1UEBwwKV2Fz
# aGluZ3RvbjEaMBgGA1UECQwRMTAxIEtlbm5lZHkgU1QgTkUxDjAMBgNVBBIMBTIw
# MDExMRMwEQYDVQQKDApFcGlzb2YgTExDMRMwEQYDVQQDDApFcGlzb2YgTExDMIIB
# IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnVqmEX0vuCM2zNZrzsks3T60
# fmPqUlAcacCTnl/JBYxQJfroZrVGuuKdk8IKlGeBGjNhWBXRcRJ7FVIMFIU2KCZS
# e1mFEPNNNZjrw4cJiirfDCKROHygXbgPih8pfxQGJl3wGdF+PjuOYrSUmFIgTLzq
# WDrSDa03n25g4S+gbaH9pf8LjVaS0Wm1Q+Q063kaymygLCmnnlqApjLGeV1QPA67
# B9lbyGl69qcOLsB6L8NwNAHYr7NTpOGliaFRyOjsxaYImxXDSS7RLpi1+ig6Ak79
# i9fOVfkX/GtrtvDo7lKAb/pzdZ6j9auDqssaerBfKH7+uecoqBr/CqRAHPiUlwID
# AQABo4IBqDCCAaQwHwYDVR0jBBgwFoAUKZFg/4pN+uv5pmq4z/nmS71JzhIwHQYD
# VR0OBBYEFCyN0y4HPzt4aNbqEw490H/m3qB4MA4GA1UdDwEB/wQEAwIHgDAMBgNV
# HRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBEGCWCGSAGG+EIBAQQEAwIE
# EDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDAjArMCkGCCsGAQUFBwIBFh1odHRw
# czovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBDBgNVHR8EPDA6MDigNqA0hjJodHRw
# Oi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmluZ0NBLmNybDB0
# BggrBgEFBQcBAQRoMGYwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jcnQuY29tb2RvY2Eu
# Y29tL0NPTU9ET1JTQUNvZGVTaWduaW5nQ0EuY3J0MCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5jb21vZG9jYS5jb20wGQYDVR0RBBIwEIEOdGVtQGVwaXNvZi5jb20w
# DQYJKoZIhvcNAQELBQADggEBAHeDSZCt98BR+s4hW78rf9EpMghiEGVsy8CqFS7N
# n5KDXL2eefh6CHEzYPiHywCnDdUbVTrH4fnf+nvXaKP5nGCGpq68ELaWYtzjAWKY
# TFN4nwhYDjJq+Nye0XNfUf8I0+8sMurFZ6hz3BK0TvcOZRoa+ld5xRUvVXqyKYHB
# 0q+1DvCebW6VxLDPrkFHnHAhKNaKA0+K3C5R5jdAyzuGe/Qo7l9NRU/cxvmMzeEw
# n8b76kIoliEAN8BQ6BdB9vfg7TZ6yQKR6BUvNOPWLD39duFLSs1dZqSVO+cgdNNq
# n6/uJm3EdyS2iFUj2zFyAaYSnAF1u5//K9LOFKjGwAaIQ6gwggXgMIIDyKADAgEC
# AhAufIfMDpNKUv6U/Ry3zTSvMA0GCSqGSIb3DQEBDAUAMIGFMQswCQYDVQQGEwJH
# QjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3Jk
# MRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RPIFJT
# QSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xMzA1MDkwMDAwMDBaFw0yODA1
# MDgyMzU5NTlaMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNo
# ZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1p
# dGVkMSMwIQYDVQQDExpDT01PRE8gUlNBIENvZGUgU2lnbmluZyBDQTCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBAKaYkGN3kTR/itHd6WcxEevMHv0xHbO5
# Ylc/k7xb458eJDIRJ2u8UZGnz56eJbNfgagYDx0eIDAO+2F7hgmz4/2iaJ0cLJ2/
# cuPkdaDlNSOOyYruGgxkx9hCoXu1UgNLOrCOI0tLY+AilDd71XmQChQYUSzm/sES
# 8Bw/YWEKjKLc9sMwqs0oGHVIwXlaCM27jFWM99R2kDozRlBzmFz0hUprD4DdXta9
# /akvwCX1+XjXjV8QwkRVPJA8MUbLcK4HqQrjr8EBb5AaI+JfONvGCF1Hs4NB8C4A
# NxS5Eqp5klLNhw972GIppH4wvRu1jHK0SPLj6CH5XkxieYsCBp9/1QsCAwEAAaOC
# AVEwggFNMB8GA1UdIwQYMBaAFLuvfgI9+qbxPISOre44mOzZMjLUMB0GA1UdDgQW
# BBQpkWD/ik366/mmarjP+eZLvUnOEjAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/
# BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEFBQcDAzARBgNVHSAECjAIMAYGBFUd
# IAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09N
# T0RPUlNBQ2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwcQYIKwYBBQUHAQEEZTBj
# MDsGCCsGAQUFBzAChi9odHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FB
# ZGRUcnVzdENBLmNydDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2Eu
# Y29tMA0GCSqGSIb3DQEBDAUAA4ICAQACPwI5w+74yjuJ3gxtTbHxTpJPr8I4LATM
# xWMRqwljr6ui1wI/zG8Zwz3WGgiU/yXYqYinKxAa4JuxByIaURw61OHpCb/mJHSv
# HnsWMW4j71RRLVIC4nUIBUzxt1HhUQDGh/Zs7hBEdldq8d9YayGqSdR8N069/7Z1
# VEAYNldnEc1PAuT+89r8dRfb7Lf3ZQkjSR9DV4PqfiB3YchN8rtlTaj3hUUHr3pp
# J2WQKUCL33s6UTmMqB9wea1tQiCizwxsA4xMzXMHlOdajjoEuqKhfB/LYzoVp9QV
# G6dSRzKp9L9kR9GqH1NOMjBzwm+3eIKdXP9Gu2siHYgL+BuqNKb8jPXdf2WMjDFX
# MdA27Eehz8uLqO8cGFjFBnfKS5tRr0wISnqP4qNS4o6OzCbkstjlOMKo7caBnDVr
# qVhhSgqXtEtCtlWdvpnncG1Z+G0qDH8ZYF8MmohsMKxSCZAWG/8rndvQIMqJ6ih+
# Mo4Z33tIMx7XZfiuyfiDFJN2fWTQjs6+NX3/cjFNn569HmwvqI8MBlD7jCezdsn0
# 5tfDNOKMhyGGYf6/VXThIXcDCmhsu+TJqebPWSXrfOxFDnlmaOgizbjvmIVNlhE8
# CYrQf7woKBP7aspUjZJczcJlmAaezkhb1LU3k0ZBfAfdz/pD77pnYf99SeC7MH1c
# gOPmFjlLpzGCAjMwggIvAgEBMIGRMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJH
# cmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNP
# TU9ETyBDQSBMaW1pdGVkMSMwIQYDVQQDExpDT01PRE8gUlNBIENvZGUgU2lnbmlu
# ZyBDQQIQHvPrkrypow2D/voZH0ZhxTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUNfFk+NR61zda
# 8hegGPeHgeNvUoAwDQYJKoZIhvcNAQEBBQAEggEAh5MHMCfROs0+AfhkZN3y3/2W
# dgA9Ncb8GvA+2BmD3CQ5E318+Qym+SmjcwSa7L4Lsw2e2KBQoFvMKVr6vmhksjIs
# Cx3EaLif3IuFAySco22m6kAenYuipZPamYX2B65HCowqkjnD+yM1C/83SSL5x8UY
# KtMf6jr5EnBAY8YDongqn3yl9+vBYSLx8jm6IEDz8gXhuX0ya0YPUxyAdJgSZ4b4
# 7qYpKdWdmMraKvA2MCB3BevcVuNG4Yx/eZ5rkN578RiXMap1+fK+1kKM+wok41+7
# izvQ+Y1+pVYygcnKyNIxqqnpzX9NQK0b/yNZPTOUWQsLKfOtKPll+NSMwP41Ig==
# SIG # End signature block
