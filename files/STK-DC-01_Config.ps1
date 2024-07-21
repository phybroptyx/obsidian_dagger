Disable-NetAdapterBinding -Name 'Ethernet0' -ComponentID 'ms_tcpip6'
New-NetFirewallRule -DisplayName 'Allow ICMPv4-In' -Protocol ICMPv4
New-NetFirewallRule -DisplayName 'Allow ICMPv4-Out' -Protocol ICMPv4 -Direction Outbound
New-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985
New-NetFirewallRule -DisplayName 'Windows Remote Management (HTTPS-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986
cscript.exe C:\Windows\System32\slmgr.vbs /skms kms.activation.sls.microsoft.com
cscript.exe C:\Windows\System32\slmgr.vbs /ato
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet0' -ServerAddresses ('37.186.49.20')
Set-TimeZone -Id 'Eastern Standard Time'
Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\ServerManager\\Roles\\12' -Name ConfigurationState -Value 2