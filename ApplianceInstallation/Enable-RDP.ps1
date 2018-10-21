<#
  .SYNOPSIS

  .DESCRIPTION
        Enable Remote Desktop

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Enable-RDP.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>

# Get command line parameter auto to determine run method - Valid values (true or false). Default to false
param([string]$RDPMembers 
) 

	
# Import config file
[xml]$ConfigFile = Get-Content ".\MES-Config.xml"


if([string]::IsNullOrEmpty($RDPMembers)) {

    if ($ConfigFile.Settings.UserAccounts.AccountAdmin) 
    {
          # Set RDP Members from config file
          $RDPMembers = $ConfigFile.Settings.UserAccounts.AccountAdmin
    }else {
          # Set RDP Members to Default settings from config file
          $RDPMembers =  $ConfigFile.Settings.UserAccounts.DefaultAdmin
    }
}

Write-Host "#### Enabling Remote Desktop #####" -ForegroundColor Yellow
New-ItemProperty -Path "HKLM:System\CurrentControlSet\Control\Terminal Server" -Name 'fDenyTSConnections' -Value 0 -PropertyType dword -Force
New-ItemProperty -Path "HKLM:System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name 'UserAuthentication' -Value 1 -PropertyType dword -Force
Write-Host "Enabled Remote Desktop" -ForegroundColor Green
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
Write-Host "Enabled Remote Desktop Firewall Rules" -ForegroundColor Green
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $RDPMembers
Write-Host "$RDPMembers have been given remote desktop access" -ForegroundColor Green

# SIG # Begin signature block
# MIIOCgYJKoZIhvcNAQcCoIIN+zCCDfcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUTecW/g0RrZuZor2v287SbHX8
# viegggtBMIIFWTCCBEGgAwIBAgIQHvPrkrypow2D/voZH0ZhxTANBgkqhkiG9w0B
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
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUvUtxeHoawtV1
# Pkcv8WBJAYdEQkIwDQYJKoZIhvcNAQEBBQAEggEAj5LAEdaSfF3q2DWtkaBuw+XU
# S3FEai4B7cPTSZzBtyEaCXZGbJobxw6+Mvd0Q3eOVnvTFvQJObnKfxVmgllX2T66
# iClSoMjp/7AaBWETNGBhvKIxIF7ixQc02+DTSJ2OplM3NOVOCCiCZQyfapQOGU+W
# 6TFMwvTLQPB+oopHt+ON3nzXpjA0BxUyCQQ/0B5BtyESWwEFtukbGGmo8e64myb8
# NEUmmplgNQDLmT4UP3mx21gbZy40aPf/eR4ry/6Z11UKz2ABVOsbouZQDVgiJHHl
# tp/P9NKU4fA6SSo5bSA2imQhi0j2DcKbWAEHCJ879TraCEWCzKlFAZLtLLiCwA==
# SIG # End signature block
