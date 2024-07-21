Set-DnsClientServerAddress -InterfaceAlias 'Ethernet0' -ServerAddresses ('37.186.49.20')
Add-DnsServerPrimaryZone -NetworkID 37.186.49.0/24 -ZoneFile 49.186.37.in-addr.arpa.dns
Add-DnsServerForwarder -IPAddress 46.244.164.88 -PassThru
Add-DnsServerResourceRecordPtr -Name "20" -ZoneName "49.186.37.in-addr.arpa" -AllowUpdateAny -TimeToLive 01:00:00 -AgeRecord -PtrDomainName "stk-dc-01.stark-industries.midgard.mrvl"