Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Windows Server 2012 R2
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode 'Win2012R2' -DomainName 'stark-industries.midgard.mrvl' -DomainNetbiosName 'STARK' -ForestMode 'Win2012R2' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$false -SafeModeAdministratorPassword (ConvertTo-SecureString 'P@ssw0rdP@ssw0rd' -AsPlainText -Force) -SysvolPath 'C:\Windows\SYSVOL' -Force:$true

# Windows Server 2016
# Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode 'Win2016' -DomainName 'stark-industries.midgard.mrvl' -DomainNetbiosName 'STARK' -ForestMode 'Win2016' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$false -SafeModeAdministratorPassword (ConvertTo-SecureString 'P@ssw0rdP@ssw0rd' -AsPlainText -Force) -SysvolPath 'C:\Windows\SYSVOL' -Force:$true

# Windows Server 2019
# Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode 'Win2019' -DomainName 'stark-industries.midgard.mrvl' -DomainNetbiosName 'STARK' -ForestMode 'Win2019' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$false -SafeModeAdministratorPassword (ConvertTo-SecureString 'P@ssw0rdP@ssw0rd' -AsPlainText -Force) -SysvolPath 'C:\Windows\SYSVOL' -Force:$true

# Windows Server 2022
# Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode 'Win2022' -DomainName 'stark-industries.midgard.mrvl' -DomainNetbiosName 'STARK' -ForestMode 'Win2022' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$false -SafeModeAdministratorPassword (ConvertTo-SecureString 'P@ssw0rdP@ssw0rd' -AsPlainText -Force) -SysvolPath 'C:\Windows\SYSVOL' -Force:$true