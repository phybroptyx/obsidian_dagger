Rename-ADObject -Identity "CN=Default-First-Site-Name,CN=Sites,CN=Configuration,DC=stark-industries,DC=midgard,DC=mrvl" -NewName "NYC"
New-ADReplicationSubnet -Name "37.186.49.0/24" -Site "NYC"