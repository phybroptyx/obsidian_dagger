# Stark Industries Operations Department Workstations
# 6 Total Workstations:
# - 1 x Windows 7 Enterprise
# - 2 x Windows 10 Professional Build 1809
# - 3 x Windows 10 Professional Build 21H2

data "vsphere_datacenter" "dc" {
    name = var.dc
}

data "vsphere_datastore" "store" {
    name            = var.datastore
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
    name = var.cluster
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "pg" {
    name = var.Datacenter_Net
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_win7" {
  name          = "Templ_Win7_Ent"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_virtual_machine" "template_win81" {
#   name          = "Templ_Win8.1_Pro"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_win10_Pro_1511" {
#   name          = "Templ_Win10_Pro_1511"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

data "vsphere_virtual_machine" "template_win10_Pro_1809" {
  name          = "Templ_Win10_Pro_1809"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_virtual_machine" "template_win10_Pro_21H2" {
#   name          = "Templ_Win10_Pro_21H2"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_ubu1604" {
#   name          = "Templ_Ubuntu_16.04"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_ubu1804" {
#   name          = "Templ_Ubuntu_18.04"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_ubu2004" {
#   name          = "Templ_Ubuntu_20.04"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_ubu2204" {
#   name          = "Templ_Ubuntu_22.04"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_centos_7" {
#   name          = "Templ_CentOS_7"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_centos_8" {
#   name          = "Templ_CentOS_8"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_centos_9" {
#   name          = "Templ_CentOS_9"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_fedora_38" {
#   name          = "Templ_Fedora_38"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_fedora_38_server" {
#   name          = "Base_Fedora_38_Server"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# Windows 10 Pro Build 1809 - 4.78.128.162

resource "vsphere_virtual_machine" "stk-ops-7cb6b9" {
  name             = "stk-ops-7cb6b9.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 2
  firmware         = "efi"
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_win10_Pro_1809.guest_id
  folder           = var.cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_win10_Pro_1809.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_win10_Pro_1809.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_win10_Pro_1809.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_win10_Pro_1809.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_win10_Pro_1809.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_win10_Pro_1809.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "stk-ops-7cb6b9"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
          "cmd.exe /C Powershell.exe slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX",
          "cmd.exe /C Powershell.exe Set-TimeZone -Id 'Eastern Standard Time'",
          "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
          "cmd.exe /C powercfg -change -standby-timeout-ac 0",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-In' -Protocol ICMPv4",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-Out' -Protocol ICMPv4 -Direction Outbound",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTP-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTPS-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986",
          "cmd.exe /C Powershell.exe -Command \"$host = $env:COMPUTERNAME; $certificateThumbprint = (New-SelfSignedCertificate -DnsName $host -CertStoreLocation Cert:\\LocalMachine\\My).Thumbprint; winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=`$host; CertificateThumbprint=`\"$certificateThumbprint`\"}'\"",
          "cmd.exe /C Powershell.exe Restart-Service WinRM",
        ]

      }

      network_interface {
        ipv4_address    = "4.78.128.162"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows 10 Pro Build 1809 - 4.78.128.165

resource "vsphere_virtual_machine" "stk-ops-26eacf" {
  name             = "stk-ops-26eacf.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 2
  firmware         = "efi"
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_win10_Pro_1809.guest_id
  folder           = var.cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_win10_Pro_1809.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_win10_Pro_1809.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_win10_Pro_1809.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_win10_Pro_1809.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_win10_Pro_1809.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_win10_Pro_1809.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "stk-ops-26eacf"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
          "cmd.exe /C Powershell.exe slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX",
          "cmd.exe /C Powershell.exe Set-TimeZone -Id 'Eastern Standard Time'",
          "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
          "cmd.exe /C powercfg -change -standby-timeout-ac 0",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-In' -Protocol ICMPv4",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-Out' -Protocol ICMPv4 -Direction Outbound",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTP-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTPS-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986",
          "cmd.exe /C Powershell.exe -Command \"$host = $env:COMPUTERNAME; $certificateThumbprint = (New-SelfSignedCertificate -DnsName $host -CertStoreLocation Cert:\\LocalMachine\\My).Thumbprint; winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=`$host; CertificateThumbprint=`\"$certificateThumbprint`\"}'\"",
          "cmd.exe /C Powershell.exe Restart-Service WinRM",
        ]

      }

      network_interface {
        ipv4_address    = "4.78.128.165"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# # Windows 10 Pro Build 21H2 - 4.78.128.170

# resource "vsphere_virtual_machine" "stk-ops-173eeb" {
#   name             = "stk-ops-173eeb.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   firmware         = "efi"
#   memory           = 8192
#   guest_id         = data.vsphere_virtual_machine.template_win10_Pro_21H2.guest_id
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_win10_Pro_21H2.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_win10_Pro_21H2.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_win10_Pro_21H2.id
#     timeout = var.vm_clone_timeout
    
#     customize {
#       windows_options {
#         computer_name    = "stk-ops-173eeb"
#         admin_password   = var.win_admin_password
#         workgroup        = "WORKGROUP"
#         auto_logon       = true
#         auto_logon_count = 1
#         run_once_command_list = [
#           "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
#           "cmd.exe /C Powershell.exe slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX",
#           "cmd.exe /C Powershell.exe Set-TimeZone -Id 'Eastern Standard Time'",
#           "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
#           "cmd.exe /C powercfg -change -standby-timeout-ac 0",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-In' -Protocol ICMPv4",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-Out' -Protocol ICMPv4 -Direction Outbound",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTP-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTPS-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986",
#           "cmd.exe /C Powershell.exe -Command \"$host = $env:COMPUTERNAME; $certificateThumbprint = (New-SelfSignedCertificate -DnsName $host -CertStoreLocation Cert:\\LocalMachine\\My).Thumbprint; winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=`$host; CertificateThumbprint=`\"$certificateThumbprint`\"}'\"",
#           "cmd.exe /C Powershell.exe Restart-Service WinRM",
#         ]

#       }

#       network_interface {
#         ipv4_address    = "4.78.128.170"
#         ipv4_netmask    = 24
#         dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
#       }

#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # Windows 10 Pro Build 21H2 - 4.78.128.187

# resource "vsphere_virtual_machine" "stk-ops-100caa" {
#   name             = "stk-ops-100caa.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   firmware         = "efi"
#   memory           = 8192
#   guest_id         = data.vsphere_virtual_machine.template_win10_Pro_21H2.guest_id
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_win10_Pro_21H2.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_win10_Pro_21H2.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_win10_Pro_21H2.id
#     timeout = var.vm_clone_timeout
    
#     customize {
#       windows_options {
#         computer_name    = "stk-ops-100caa"
#         admin_password   = var.win_admin_password
#         workgroup        = "WORKGROUP"
#         auto_logon       = true
#         auto_logon_count = 1
#         run_once_command_list = [
#           "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
#           "cmd.exe /C Powershell.exe slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX",
#           "cmd.exe /C Powershell.exe Set-TimeZone -Id 'Eastern Standard Time'",
#           "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
#           "cmd.exe /C powercfg -change -standby-timeout-ac 0",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-In' -Protocol ICMPv4",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-Out' -Protocol ICMPv4 -Direction Outbound",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTP-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTPS-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986",
#           "cmd.exe /C Powershell.exe -Command \"$host = $env:COMPUTERNAME; $certificateThumbprint = (New-SelfSignedCertificate -DnsName $host -CertStoreLocation Cert:\\LocalMachine\\My).Thumbprint; winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=`$host; CertificateThumbprint=`\"$certificateThumbprint`\"}'\"",
#           "cmd.exe /C Powershell.exe Restart-Service WinRM",
#         ]

#       }

#       network_interface {
#         ipv4_address    = "4.78.128.187"
#         ipv4_netmask    = 24
#         dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
#       }

#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # Windows 10 Pro Build 21H2 - 4.78.128.186

# resource "vsphere_virtual_machine" "stk-ops-547002" {
#   name             = "stk-ops-547002.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   firmware         = "efi"
#   memory           = 8192
#   guest_id         = data.vsphere_virtual_machine.template_win10_Pro_21H2.guest_id
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_win10_Pro_21H2.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_win10_Pro_21H2.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_win10_Pro_21H2.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_win10_Pro_21H2.id
#     timeout = var.vm_clone_timeout
    
#     customize {
#       windows_options {
#         computer_name    = "stk-ops-547002"
#         admin_password   = var.win_admin_password
#         workgroup        = "WORKGROUP"
#         auto_logon       = true
#         auto_logon_count = 1
#         run_once_command_list = [
#           "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
#           "cmd.exe /C Powershell.exe slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX",
#           "cmd.exe /C Powershell.exe Set-TimeZone -Id 'Eastern Standard Time'",
#           "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
#           "cmd.exe /C powercfg -change -standby-timeout-ac 0",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-In' -Protocol ICMPv4",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-Out' -Protocol ICMPv4 -Direction Outbound",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTP-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985",
#           "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTPS-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986",
#           "cmd.exe /C Powershell.exe -Command \"$host = $env:COMPUTERNAME; $certificateThumbprint = (New-SelfSignedCertificate -DnsName $host -CertStoreLocation Cert:\\LocalMachine\\My).Thumbprint; winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname=`$host; CertificateThumbprint=`\"$certificateThumbprint`\"}'\"",
#           "cmd.exe /C Powershell.exe Restart-Service WinRM",
#         ]

#       }

#       network_interface {
#         ipv4_address    = "4.78.128.186"
#         ipv4_netmask    = 24
#         dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
#       }

#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# Windows 7 Enterprise - 4.78.128.189

# resource "vsphere_virtual_machine" "stk-ops-bb6587" {
#   name             = "stk-ops-bb6587.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   firmware         = "bios"
#   memory           = 8192
#   guest_id         = data.vsphere_virtual_machine.template_win7.guest_id
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_win7.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_win7.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_win7.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_win7.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_win7.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_win7.id
#     timeout = var.vm_clone_timeout
    
#     customize {
#       windows_options {
#         computer_name    = "stk-ops-bb6587"
#         admin_password   = var.win_admin_password
#         workgroup        = "WORKGROUP"
#         auto_logon       = true
#         auto_logon_count = 1
#         run_once_command_list = [
#           "cmd.exe /C Powershell.exe Set-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\services\\TCPIP6\\Parameters\" -Name \"DisabledComponents\" -Value 0xffffffff",
#           "cmd.exe /C tzutil /s \"Eastern Standard Time\"",
#           "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
#           "cmd.exe /C powercfg -change -standby-timeout-ac 0",
#           "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-In\" dir=in action=allow protocol=ICMPv4",
#           "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-Out\" dir=out action=allow protocol=ICMPv4",
#           "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTP-In)\" dir=in action=allow protocol=TCP localport=5985",
#           "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTPS-In)\" dir=in action=allow protocol=TCP localport=5986",
#           "cmd.exe /C netsh advfirewall set allprofiles settings remotemanagement enable",
#           "cmd.exe /C winrm quickconfig -quiet",
#           "cmd.exe /C winrm set winrm/config/winrs '@{MaxMemoryPerShellMB=\"1024\"}'",
#           "cmd.exe /C winrm set winrm/config '@{MaxTimeoutms=\"1800000\"}'",
#           "cmd.exe /C winrm set winrm/config/service '@{AllowUnencrypted=\"true\"}'",
#           "cmd.exe /C winrm set winrm/config/service/auth '@{Basic=\"true\"}'",
#           "cmd.exe /C winrm set winrm/config/client/auth '@{Basic=\"true\"}'",
#           "cmd.exe /C Powershell.exe Set-WSManInstance -ResourceURI winrm/config -ValueSet @{MaxEnvelopeSizekb = \"500\"}",
#           "cmd.exe /C Powershell.exe Restart-Service WinRM",
#         ]

#       }

#       network_interface {
#         ipv4_address    = "4.78.128.189"
#         ipv4_netmask    = 24
#         dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
#       }

#       ipv4_gateway = "4.78.128.1"
#       timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }