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
    name = var.RED_OPNET
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_win10_Pro_1809" {
  name          = "Templ_Win10_Pro_1809"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_2012r2" {
  name          = "Templ_Server2012R2_3"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_fedora38" {
  name          = "Templ_Fedora_38"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_kali23_3" {
  # name          = "Templ_Kali_2023.3"
  name          = "Templ_Kali_2024.2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_virtual_machine" "template_ubu21_10" {
#   name          = "Templ_Ubuntu_21.10"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# Windows 10 Pro Build 1809 - 5.59.35.18

resource "vsphere_virtual_machine" "griz-w10-01" {
  name             = "griz-w10-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 2
  firmware         = "efi"
  memory           = 4096
  guest_id         = data.vsphere_virtual_machine.template_win10_Pro_1809.guest_id
  folder           = var.apt_cli_folder
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
        computer_name    = "griz-w10-01"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
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
        ipv4_address    = "5.59.35.18"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows 10 Pro Build 1809 - 5.59.35.21

resource "vsphere_virtual_machine" "griz-w10-02" {
  name             = "griz-w10-02"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 2
  firmware         = "efi"
  memory           = 4096
  guest_id         = data.vsphere_virtual_machine.template_win10_Pro_1809.guest_id
  folder           = var.apt_cli_folder
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
        computer_name    = "griz-w10-02"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
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
        ipv4_address    = "5.59.35.21"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows Server 2012 R2 - 5.59.35.10

resource "vsphere_virtual_machine" "griz-fs-01" {
  name             = "griz-fs-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_2012r2.guest_id
  folder           = var.apt_svr_folder
  scsi_type        = data.vsphere_virtual_machine.template_2012r2.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_2012r2.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_2012r2.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_2012r2.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_2012r2.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_2012r2.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "griz-fs-01"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
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
        ipv4_address    = "5.59.35.10"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Fedora 38 - 5.59.35.31

resource "vsphere_virtual_machine" "griz-f38-01" {
  name             = "griz-f38-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_fedora38.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_fedora38.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_fedora38.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_fedora38.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_fedora38.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_fedora38.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_fedora38.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-f38-01"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.31"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Ubuntu 21.10 - 5.59.35.42

# resource "vsphere_virtual_machine" "griz-ubu-01" {
#   name             = "griz-ubu-01"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.store.id
#   num_cpus         = 4
#   memory           = 8192
#   guest_id         = data.vsphere_virtual_machine.template_ubu21_10.guest_id
#   folder           = var.apt_cli_folder
#   scsi_type        = data.vsphere_virtual_machine.template_ubu21_10.scsi_type
#   network_interface {
#     network_id   = "${data.vsphere_network.pg.id}"
#     adapter_type = data.vsphere_virtual_machine.template_ubu21_10.network_interface_types[0]
#   }

#   disk {
#     label            = "disk0"
#     size             = data.vsphere_virtual_machine.template_ubu21_10.disks.0.size
#     eagerly_scrub    = data.vsphere_virtual_machine.template_ubu21_10.disks.0.eagerly_scrub
#     thin_provisioned = data.vsphere_virtual_machine.template_ubu21_10.disks.0.thin_provisioned
#   }

#   disk {
#     label            = "disk1"
#     size             = 400
#     unit_number      = 1
#     eagerly_scrub    = false
#     thin_provisioned = true
#   }

#   clone {
#     template_uuid = data.vsphere_virtual_machine.template_ubu21_10.id
    # timeout = var.vm_clone_timeout
    
#     customize {
#       linux_options {
#         host_name    = "griz-ubu-01"
#         domain       = "grizzly.org"
#         time_zone    = "Asia/Vladivostok"
#       }

#       network_interface {
#         ipv4_address    = "5.59.35.42"
#         ipv4_netmask    = 24
#         dns_server_list = [ "46.244.164.88" ]
#       }

#       ipv4_gateway = "5.59.35.1"
#       timeout = 30
#     }
#   }

#   wait_for_guest_net_timeout = 0
# }

# Kali 2023.3 - 5.59.35.71

resource "vsphere_virtual_machine" "griz-kali-01" {
  name             = "griz-kali-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-01"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.71"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.72

resource "vsphere_virtual_machine" "griz-kali-02" {
  name             = "griz-kali-02"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-02"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.72"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.73

resource "vsphere_virtual_machine" "griz-kali-03" {
  name             = "griz-kali-03"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-03"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.73"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.74

resource "vsphere_virtual_machine" "griz-kali-04" {
  name             = "griz-kali-04"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-04"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.74"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.75

resource "vsphere_virtual_machine" "griz-kali-05" {
  name             = "griz-kali-05"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-05"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.75"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.76

resource "vsphere_virtual_machine" "griz-kali-06" {
  name             = "griz-kali-06"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-06"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.76"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.77

resource "vsphere_virtual_machine" "griz-kali-07" {
  name             = "griz-kali-07"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-07"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.77"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.78

resource "vsphere_virtual_machine" "griz-kali-08" {
  name             = "griz-kali-08"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-08"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.78"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.79

resource "vsphere_virtual_machine" "griz-kali-09" {
  name             = "griz-kali-09"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-09"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.79"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}

# Kali 2023.3 - 5.59.35.80

resource "vsphere_virtual_machine" "griz-kali-10" {
  name             = "griz-kali-10"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_kali23_3.guest_id
  folder           = var.apt_cli_folder
  scsi_type        = data.vsphere_virtual_machine.template_kali23_3.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_kali23_3.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_kali23_3.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_kali23_3.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_kali23_3.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_kali23_3.id
    timeout = var.vm_clone_timeout
    
    customize {
      linux_options {
        host_name    = "griz-kali-10"
        domain       = "grizzly.org"
        time_zone    = "Asia/Vladivostok"
      }

      network_interface {
        ipv4_address    = "5.59.35.80"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "5.59.35.1"
    }
  }

  wait_for_guest_net_timeout = 0
}