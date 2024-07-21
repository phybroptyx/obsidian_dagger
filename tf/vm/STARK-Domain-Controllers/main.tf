# Stark Industries Development Domain Controllers
# 1 Total Domain Controller:
# - 1 x Windows Server 2016

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

# data "vsphere_virtual_machine" "template_2008r2" {
#   # name          = "Base_Server2008R2"
#   name          = "Templ_Server2008R2"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

data "vsphere_virtual_machine" "template_2012r2" {
  # name          = "Base_Server2012R2"
  name          = "Templ_Server2012R2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_virtual_machine" "template_2016" {
#   # name          = "Base_Server2016"
#   name          = "Templ_Server2016"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_2019" {
#   # name          = "Base_Server2019"
#   name          = "Templ_Server2019"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_virtual_machine" "template_2022" {
#   # name          = "Base_Server2022"
#   name          = "Templ_Server2022"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

resource "vsphere_virtual_machine" "stk-dc-01" {
  name             = "stk-dc-01.stark-industries.midgard.mrvl"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 4
  memory           = 32768
  guest_id         = data.vsphere_virtual_machine.template_2012r2.guest_id
  folder           = var.dc_folder
  scsi_type        = data.vsphere_virtual_machine.template_2012r2.scsi_type
  sync_time_with_host = true
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

  clone {
    template_uuid = data.vsphere_virtual_machine.template_2012r2.id
    timeout = var.vm_clone_timeout
    
    customize {
      windows_options {
        computer_name    = "stk-dc-01"
        admin_password   = var.win_admin_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 3
        run_once_command_list = [
          "cmd.exe /C Powershell.exe Get-ScheduledTask -TaskName ServerManager | Enable-ScheduledTask",
          "cmd.exe /C Powershell.exe Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\ServerManager\\Roles\\12' -Name ConfigurationState -Value 2"
        ]

      }

      network_interface {
        ipv4_address    = "4.78.128.20"
        ipv4_netmask    = 24
        dns_server_list = [ "46.244.164.88" ]
      }

      ipv4_gateway = "4.78.128.1"
    }
  }

  wait_for_guest_net_timeout = 5
}