Install-WindowsFeature DHCP -IncludeManagementTools
Import-Module -Name DHCPServer
Add-DhcpServerInDC -DnsName 'stk-dc-01.stark-industries.midgard.mrvl' -IPAddress 37.186.49.20
Add-DhcpServerSecurityGroup
Restart-Service -Name DHCPServer -Force
Add-DhcpServerv4Scope -Name "Workstations Scope - 37.186.49.0/24" -StartRange 37.186.49.100 -EndRange 37.186.49.230 -SubnetMask 255.255.255.0 -State Active -LeaseDuration 7.00:00:00