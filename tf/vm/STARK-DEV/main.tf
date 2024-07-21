# Stark Industries Development Department Workstations
# 15 Total Workstations:
# - 5 x Windows 10 Professional Build 1809
# - 4 x CentOS 9
# - 6 x CentOS 8
# - 2 x CentOS 7

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

# data "vsphere_virtual_machine" "template_win7" {
#   name          = "Templ_Win7_Ent"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

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

# Windows 10 Pro Build 1809 - 4.78.128.129

resource "vsphere_virtual_machine" "stk-dev-0f7d34" {
  name             = "stk-dev-0f7d34.stark-industries.midgard.mrvl"
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
        computer_name    = "stk-dev-0f7d34"
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
        ipv4_address    = "4.78.128.129"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows 10 Pro Build 1809 - 4.78.128.156

resource "vsphere_virtual_machine" "stk-dev-99ba3e" {
  name             = "stk-dev-99ba3e.stark-industries.midgard.mrvl"
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
        computer_name    = "stk-dev-99ba3e"
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
        ipv4_address    = "4.78.128.156"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows 10 Pro Build 1809 - 4.78.128.147

resource "vsphere_virtual_machine" "stk-dev-816dce" {
  name             = "stk-dev-816dce.stark-industries.midgard.mrvl"
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
        computer_name    = "stk-dev-816dce"
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
        ipv4_address    = "4.78.128.147"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows 10 Pro Build 1809 - 4.78.128.142

resource "vsphere_virtual_machine" "stk-dev-bbae60" {
  name             = "stk-dev-bbae60.stark-industries.midgard.mrvl"
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
        computer_name    = "stk-dev-bbae60"
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
        ipv4_address    = "4.78.128.142"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows 10 Pro Build 1809 - 4.78.128.130

resource "vsphere_virtual_machine" "stk-dev-ac4834" {
  name             = "stk-dev-ac4834.stark-industries.midgard.mrvl"
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
        computer_name    = "stk-dev-ac4834"
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
        ipv4_address    = "4.78.128.130"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# CentOS 9 Workstation - 4.78.128.150

# resource "vsphere_virtual_machine" "stk-dev-a27e28" {
#   name             = "stk-dev-a27e28.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_9.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_9.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_9.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_9.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_9.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_9.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_9.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_9.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-a27e28"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.150"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 9 Workstation - 4.78.128.133

# resource "vsphere_virtual_machine" "stk-dev-ad26de" {
#   name             = "stk-dev-ad26de.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_9.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_9.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_9.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_9.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_9.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_9.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_9.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_9.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-ad26de"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.133"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 9 Workstation - 4.78.128.144

# resource "vsphere_virtual_machine" "stk-dev-77ffea" {
#   name             = "stk-dev-77ffea.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_9.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_9.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_9.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_9.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_9.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_9.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_9.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_9.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-77ffea"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.144"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 9 Workstation - 4.78.128.136

# resource "vsphere_virtual_machine" "stk-dev-17dce4" {
#   name             = "stk-dev-17dce4.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_9.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_9.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_9.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_9.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_9.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_9.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_9.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_9.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-17dce4"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.136"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 8 Workstation - 4.78.128.154

# resource "vsphere_virtual_machine" "stk-dev-29afec" {
#   name             = "stk-dev-29afec.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_8.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_8.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_8.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_8.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_8.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_8.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_8.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_8.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-29afec"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.154"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 8 Workstation - 4.78.128.157

# resource "vsphere_virtual_machine" "stk-dev-28eeca" {
#   name             = "stk-dev-28eeca.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_8.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_8.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_8.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_8.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_8.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_8.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_8.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_8.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-28eeca"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.157"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 8 Workstation - 4.78.128.135

# resource "vsphere_virtual_machine" "stk-dev-0385dd" {
#   name             = "stk-dev-0385dd.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_8.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_8.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_8.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_8.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_8.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_8.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_8.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_8.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-0385dd"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.135"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 8 Workstation - 4.78.128.139

# resource "vsphere_virtual_machine" "stk-dev-34fcea" {
#   name             = "stk-dev-34fcea.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_8.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_8.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_8.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_8.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_8.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_8.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_8.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_8.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-34fcea"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.139"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 8 Workstation - 4.78.128.141

# resource "vsphere_virtual_machine" "stk-dev-e37ace" {
#   name             = "stk-dev-e37ace.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_8.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_8.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_8.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_8.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_8.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_8.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_8.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_8.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-e37ace"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.141"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 8 Workstation - 4.78.128.158

# resource "vsphere_virtual_machine" "stk-dev-eee5ac" {
#   name             = "stk-dev-eee5ac.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_8.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_8.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_8.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_8.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_8.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_8.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_8.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_8.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-eee5ac"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.158"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 7 Workstation - 4.78.128.179

# resource "vsphere_virtual_machine" "stk-dev-26db55" {
#   name             = "stk-dev-26db55.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_7.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_7.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_7.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_7.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_7.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_7.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_7.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_7.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-26db55"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.179"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# # CentOS 7 Workstation - 4.78.128.177

# resource "vsphere_virtual_machine" "stk-dev-5ae36b" {
#   name             = "stk-dev-5ae36b.stark-industries.midgard.mrvl"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 2
#   memory           = 4096
#   guest_id         = data.vsphere_virtual_machine.template_centos_7.guest_id
#   firmware         = data.vsphere_virtual_machine.template_centos_7.firmware
#   folder           = var.cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_centos_7.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_centos_7.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_centos_7.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_centos_7.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_centos_7.disks.0.thin_provisioned
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_centos_7.id
#     timeout = var.vm_clone_timeout

#     customize {
#       linux_options {
#         host_name = "stk-dev-5ae36b"
#         domain = "stark-industries.midgard.mrvl"
#       }
#       network_interface {
#         ipv4_address = "4.78.128.177"
#         ipv4_netmask = 24
#       }
#       ipv4_gateway = "4.78.128.1"
      # timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }