<#
  .SYNOPSIS

  .DESCRIPTION
        Configure Hyper V Virtual Switch

	.NOTES
      Created on: 	9/18/2018
      Created by: 	Temitope Ogunfiditmii
      Filename:		Configure-HyperV-VirtualSwitch.ps1
      Credits:		
      Requirements:	The installers executed via this script typically needs "Run As Administrator"
      Requires:      
#>
# Get command line parameter auto to determine run method - Valid values (true or false). Default to false
param([string]$NetAdapater,
      [string]$VMSwitchName

) 


# Import config file
[xml]$ConfigFile = Get-Content ".\MES-Config.xml"

# if paramaters are empty read from config file.
if([string]::IsNullOrEmpty($NetAdapater) -and [string]::IsNullOrEmpty($VMSwitchName)){
    #Select Team or Ethernet Adapter to use
    $NetAdapater = $ConfigFile.Settings.HyperVSwitch.NetAdapter
    #Select Hyper V Virtual Switch Name
    $VMSwitchName = $ConfigFile.Settings.HyperVSwitch.VMSwitchName
}

$configTeams = New-Object System.Collections.Generic.List[System.Object]
if(![string]::IsNullOrEmpty($ConfigFile.Settings.NetworkTeamSettings.ConfiguredTeams) ){
    $configTeams = $ConfigFile.Settings.NetworkTeamSettings.ConfiguredTeams -split ","
    Write-Host "Using teams from configuration to create Virtual Switch" -ForegroundColor Yellow
    Write-Host "The following teams have been identified: $configTeams" -ForegroundColor Yellow

    foreach ($team in $configTeams) {
        if ($team -eq "Team 1") {
            $VMSwitchName = "vSwitch1"
        }elseif ($team -eq "Team2") {
            $VMSwitchName = "vSwitch2" 
        }elseif ($team -eq "10GBTEAM") {
            $VMSwitchName = "vSwitch10GB"
        }elseif ($team -eq "1GBTEAM") {
            $VMSwitchName = "vSwitch1GB"
        } 

        if ((Get-VMSwitch -Name $VMSwitchName).Count -eq 1 ) {
            Write-Host "$VMSwitchName is already configured as Hyper V Virtual Switch"
        }else {
            Write-Host "$VMSwitchName is not configured as Hyper V Virtual Switch" -ForegroundColor Red
            Write-Host "Configuring $VMSwitchName as a Hyper V Virtual Switch" -ForegroundColor Yellow
            New-VMSwitch -Name $VMSwitchName -AllowManagementOS $True -NetAdapterName $team
            if((Get-VMSwitch -Name $VMSwitchName).Count -eq 1) {
                Write-Host "$VMSwitchName is configured as Hyper V Virtual Switch" -ForegroundColor Green
            }else {
                Write-Host "Unable to configure Hyper V Virtual Switch"  -ForegroundColor Red
            }
        }



    }


}else {

    if ((Get-VMSwitch -Name $VMSwitchName).Count -eq 1 ) {
        Write-Host "$VMSwitchName is already configured as Hyper V Virtual Switch"
    }else {
        Write-Host "$VMSwitchName is not configured as Hyper V Virtual Switch" -ForegroundColor Red
        Write-Host "Configuring $VMSwitchName as a Hyper V Virtual Switch" -ForegroundColor Yellow
        New-VMSwitch -Name $VMSwitchName -AllowManagementOS $True -NetAdapterName $NetAdapater
        if((Get-VMSwitch -Name $VMSwitchName).Count -eq 1) {
            Write-Host "$VMSwitchName is configured as Hyper V Virtual Switch" -ForegroundColor Green
        }else {
            Write-Host "Unable to configure Hyper V Virtual Switch"  -ForegroundColor Red
        }
    }
}

# SIG # Begin signature block
# MIIOCgYJKoZIhvcNAQcCoIIN+zCCDfcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUneHhSxnHBwrDjsIeKFaFseVY
# ORegggtBMIIFWTCCBEGgAwIBAgIQHvPrkrypow2D/voZH0ZhxTANBgkqhkiG9w0B
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
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUB3r+nDE24+aj
# RavfJyqa5VRtlo4wDQYJKoZIhvcNAQEBBQAEggEAYJWvLahWAx/KgDf1DuDRsp0O
# 3v5VzJehsczAxx3+G5IHGhKHEUnI0ffILcMdNAQ++QBc+wLjxs4FJ31UtqLc6+1e
# MFG4AqreioeLZZRmw9kAIhPRrrnaOpTYTttng4+pwraO8xd65SdLe/V/wLC4TRu8
# arkQNElBjpbu9TNTxWW3uPhv/YPL+w8GLSsUJmtW/Hfeuz6hROjpsE6lC5w2hTMV
# di8e8ccR2hjGO8zDc6P6bwuolkgt5t3UjH9pUqyg75L91P33GMcf0s/gL0mryOAz
# ilGF/ZudZlBsDU8p6Mj7R9OXJu5uQDXtNkwnVz2PCIjdgY5dIJVCH8RpFwVITg==
# SIG # End signature block
