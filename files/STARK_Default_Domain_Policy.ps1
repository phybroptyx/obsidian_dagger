# Define variables
$GPOName = "STARK Domain Default Policy"
$OUDistinguishedName = "OU=STARK,DC=stark-industries,DC=midgard,DC=mrvl"
$BannerTitle = "STARK Enterprises Notice of Consent"
$BannerContent = @"
***********************************************************************************
Welcome to STARK Enterprises IT Resources.

This system is for the use of authorized users only. Individuals using this
computer system without authority, or in excess of their authority, are subject
to having all of their activities on this system monitored and recorded by
system personnel.

In the course of monitoring individuals improperly using this system, or in the
course of system maintenance, the activities of authorized users may also be
monitored.

Anyone using this system expressly consents to such monitoring and is advised
that if such monitoring reveals possible evidence of criminal activity,
system personnel may provide the evidence of such monitoring to law enforcement
officials.
***********************************************************************************
"@
$LogonScreenImagePath = "\\stark-industries.midgard.mrvl\NETLOGON\Images\STARK_LOGON.jpg"
$DesktopImagePath = "\\stark-industries.midgard.mrvl\NETLOGON\Images\STARK_Desktop_1.jpg"
$AccentColor = "FF0000"  # Red color in hexadecimal

# Create new GPO
New-GPO -Name $GPOName -Comment "Default policy for STARK Enterprises" -Domain "stark-industries.midgard.mrvl" | Out-Null

# Set login banner
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "legalnoticecaption" -Type String -Value $BannerTitle | Out-Null
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "legalnoticetext" -Type String -Value $BannerContent | Out-Null

# Set lock screen and logon image
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" -ValueName "LockScreenImage" -Type String -Value $LogonScreenImagePath | Out-Null
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" -ValueName "LockScreenImageStatus" -Type DWord -Value 1 | Out-Null

# Set desktop background image and accent color
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "Wallpaper" -Type String -Value $DesktopImagePath | Out-Null
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "WallpaperStyle" -Type String -Value "10" | Out-Null  # 10 = Fill
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\DWM" -ValueName "AccentColor" -Type DWord -Value $AccentColor | Out-Null

# Link GPO to OU
$GPO = Get-GPO -Name $GPOName
New-GPLink -Name $GPO.DisplayName -Target $OUDistinguishedName -LinkEnabled Yes | Out-Null