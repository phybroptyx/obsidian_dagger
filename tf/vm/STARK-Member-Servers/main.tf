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

data "vsphere_virtual_machine" "template_2008r2" {
  name          = "Templ_Server2008R2"
  # name          = "Win2008R2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_virtual_machine" "template_2008r2_0" {
#   name          = "Template_2008R2"
#   # name          = "Win2008R2"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_2008r2_2" {
#   # name          = "Templ_Server2008R2"
#   name          = "Win2008R2"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

data "vsphere_virtual_machine" "template_2012r2" {
  name          = "Templ_Server2012R2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_2016" {
  name          = "Templ_Server2016"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_virtual_machine" "template_2019" {
#   name          = "Templ_Server2019"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_2022" {
#   name          = "Templ_Server2022"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# Windows Server 2012 R2

resource "vsphere_virtual_machine" "stk-ex-01" {
  name             = "stk-ex-01.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_2012r2.guest_id
  folder           = var.mbr_folder
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
        computer_name    = "stk-ex-01"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Disable-NetAdapterBinding -Name 'Ethernet*' -ComponentID 'ms_tcpip6'",
          "cmd.exe /C tzutil /s 'Eastern Standard Time'",
          "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
          "cmd.exe /C powercfg -change -standby-timeout-ac 0",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-In' -Protocol ICMPv4",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'Allow ICMPv4-Out' -Protocol ICMPv4 -Direction Outbound",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTP-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985",
          "cmd.exe /C Powershell.exe New-NetFirewallRule -DisplayName 'WinRM (HTTPS-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986",
          "cmd.exe /C winrm quickconfig -quiet",
          "cmd.exe /C Powershell.exe Restart-Service WinRM",
        ]

      }

      network_interface {
        ipv4_address    = "4.78.128.28"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows Server 2016

resource "vsphere_virtual_machine" "stk-as-01" {
  name             = "stk-as-01.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_2016.guest_id
  folder           = var.mbr_folder
  scsi_type        = data.vsphere_virtual_machine.template_2016.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_2016.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_2016.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_2016.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_2016.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_2016.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "stk-as-01"
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
        ipv4_address    = "4.78.128.11"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows Server 2008 R2

resource "vsphere_virtual_machine" "stk-lhm-01" {
  name             = "stk-lhm-01.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_2008r2.guest_id
  folder           = var.mbr_folder
  scsi_type        = data.vsphere_virtual_machine.template_2008r2.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_2008r2.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_2008r2.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_2008r2.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_2008r2.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_2008r2.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "stk-lhm-01"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Set-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\services\\TCPIP6\\Parameters\" -Name \"DisabledComponents\" -Value 0xffffffff",
          "cmd.exe /C tzutil /s \"Eastern Standard Time\"",
          "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
          "cmd.exe /C powercfg -change -standby-timeout-ac 0",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-In\" dir=in action=allow protocol=ICMPv4",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-Out\" dir=out action=allow protocol=ICMPv4",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTP-In)\" dir=in action=allow protocol=TCP localport=5985",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTPS-In)\" dir=in action=allow protocol=TCP localport=5986",
          "cmd.exe /C winrm quickconfig -quiet",
          "cmd.exe /C Powershell.exe Set-WSManInstance -ResourceURI winrm/config -ValueSet @{MaxEnvelopeSizekb = \"500\"}",
          "cmd.exe /C Powershell.exe Restart-Service WinRM",
        ]

      }

      network_interface {
        ipv4_address    = "4.78.128.66"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows Server 2008 R2

resource "vsphere_virtual_machine" "stk-fhm-01" {
  name             = "stk-fhm-01.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_2008r2.guest_id
  folder           = var.mbr_folder
  scsi_type        = data.vsphere_virtual_machine.template_2008r2.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_2008r2.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_2008r2.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_2008r2.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_2008r2.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_2008r2.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "stk-fhm-01"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Set-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\services\\TCPIP6\\Parameters\" -Name \"DisabledComponents\" -Value 0xffffffff",
          "cmd.exe /C tzutil /s \"Eastern Standard Time\"",
          "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
          "cmd.exe /C powercfg -change -standby-timeout-ac 0",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-In\" dir=in action=allow protocol=ICMPv4",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-Out\" dir=out action=allow protocol=ICMPv4",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTP-In)\" dir=in action=allow protocol=TCP localport=5985",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTPS-In)\" dir=in action=allow protocol=TCP localport=5986",
          "cmd.exe /C winrm quickconfig -quiet",
          "cmd.exe /C Powershell.exe Set-WSManInstance -ResourceURI winrm/config -ValueSet @{MaxEnvelopeSizekb = \"500\"}",
          "cmd.exe /C Powershell.exe Restart-Service WinRM",
        ]

      }

      network_interface {
        ipv4_address    = "4.78.128.25"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}

# Windows Server 2008 R2

resource "vsphere_virtual_machine" "stk-hst-01" {
  name             = "stk-hst-01.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 8192
  guest_id         = data.vsphere_virtual_machine.template_2008r2.guest_id
  folder           = var.mbr_folder
  scsi_type        = data.vsphere_virtual_machine.template_2008r2.scsi_type
  network_interface {
    network_id   = "${data.vsphere_network.pg.id}"
    adapter_type = data.vsphere_virtual_machine.template_2008r2.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_2008r2.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_2008r2.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_2008r2.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 400
    unit_number      = 1
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_2008r2.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "stk-hst-01"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 2
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Set-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\services\\TCPIP6\\Parameters\" -Name \"DisabledComponents\" -Value 0xffffffff",
          "cmd.exe /C tzutil /s \"Eastern Standard Time\"",
          "cmd.exe /C powercfg -change -monitor-timeout-ac 0",
          "cmd.exe /C powercfg -change -standby-timeout-ac 0",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-In\" dir=in action=allow protocol=ICMPv4",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"Allow ICMPv4-Out\" dir=out action=allow protocol=ICMPv4",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTP-In)\" dir=in action=allow protocol=TCP localport=5985",
          "cmd.exe /C netsh advfirewall firewall add rule name=\"WinRM (HTTPS-In)\" dir=in action=allow protocol=TCP localport=5986",
          "cmd.exe /C winrm quickconfig -quiet",
          "cmd.exe /C Powershell.exe Set-WSManInstance -ResourceURI winrm/config -ValueSet @{MaxEnvelopeSizekb = \"500\"}",
          "cmd.exe /C Powershell.exe Restart-Service WinRM",
        ]

      }

      network_interface {
        ipv4_address    = "4.78.128.37"
        ipv4_netmask    = 24
        dns_server_list = [ "4.78.128.20", "4.78.128.21" ]
      }

      ipv4_gateway = "4.78.128.1"
      timeout = 30
    }
  }

  wait_for_guest_net_timeout = 0
}