# Set up VSphere provider and credentials

provider "vsphere" {
    user            = var.username
    password        = var.password
    vsphere_server  = var.vcenter

    # For self-signed certificates
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
    name = var.dc
}

data "vsphere_distributed_virtual_switch" "vds" {
  name          = var.vds
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host_1" {
  name          = var.host_1
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_host" "host_2" {
#   name          = var.host_2
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_host" "host_3" {
#   name          = var.host_3
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

data "vsphere_compute_cluster" "cluster" {
    name = var.cluster
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_distributed_port_group" "STARK_Int_subnet_h1_pg" {
  name                = "STARK Internal"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
  vlan_id = 303
}

# resource "vsphere_distributed_port_group" "STARK_Int_subnet_h2_pg" {
#   name                = "STARK Internal"
#   host_system_id      = data.vsphere_host.host_2.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 303
# }

# resource "vsphere_distributed_port_group" "STARK_Int_subnet_h3_pg" {
#   name                = "STARK Internal"
#   host_system_id      = data.vsphere_host.host_3.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 303
# }

resource "vsphere_distributed_port_group" "STARK_Ext_subnet_h1_pg" {
  name                = "STARK External"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
  vlan_id = 303
}

# resource "vsphere_distributed_port_group" "STARK_Ext_subnet_h2_pg" {
#   name                = "STARK External"
#   host_system_id      = data.vsphere_host.host_2.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 303
# }

# resource "vsphere_distributed_port_group" "STARK_Ext_subnet_h3_pg" {
#   name                = "STARK External"
#   host_system_id      = data.vsphere_host.host_3.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 303
# }

resource "vsphere_distributed_port_group" "SOC_subnet_h1_pg" {
  name                = "Security Operations Center"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
  vlan_id = 300
}

# resource "vsphere_distributed_port_group" "SOC_subnet_h2_pg" {
#   name                = "Security Operations Center"
#   host_system_id      = data.vsphere_host.host_2.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 300
# }

# resource "vsphere_distributed_port_group" "SOC_subnet_h3_pg" {
#   name                = "Security Operations Center"
#   host_system_id      = data.vsphere_host.host_3.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 300
# }

resource "vsphere_distributed_port_group" "TRAGIC_BEAR_subnet_h1_pg" {
  name                = "TRAGIC BEAR"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
  vlan_id = 666
}

# resource "vsphere_distributed_port_group" "TRAGIC_BEAR_subnet_h2_pg" {
#   name                = "TRAGIC BEAR"
#   host_system_id      = data.vsphere_host.host_2.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 666
# }

# resource "vsphere_distributed_port_group" "TRAGIC_BEAR_subnet_h3_pg" {
#   name                = "TRAGIC BEAR"
#   host_system_id      = data.vsphere_host.host_3.id
#   virtual_switch_name = vsphere_host_virtual_switch.host_virtual_switch.name

#   vlan_id = 666
# }

# resource "time_sleep" "wait_20_seconds" {
#   create_duration = "20s"
# }

resource "vsphere_folder" "VM_parent" {
    path            = var.VM_parent_folder
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_BLUE_folder" {
    path            = "${vsphere_folder.VM_parent.path}/Blue Team"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_RED_folder" {
    path            = "${vsphere_folder.VM_parent.path}/Red Team"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_APT_folder" {
    path            = "${vsphere_folder.DAGGER_RED_folder.path}/TRAGIC BEAR"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_APT_infra_folder" {
    path            = "${vsphere_folder.DAGGER_APT_folder.path}/Infrastructure"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_APT_servers_folder" {
    path            = "${vsphere_folder.DAGGER_APT_folder.path}/Servers"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_APT_clients_folder" {
    path            = "${vsphere_folder.DAGGER_APT_folder.path}/Clients"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_DC_folder" {
    path            = "${vsphere_folder.DAGGER_BLUE_folder.path}/Domain Controllers"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_Mbr_folder" {
    path            = "${vsphere_folder.DAGGER_BLUE_folder.path}/Member Servers"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_infrastructure_folder" {
    path            = "${vsphere_folder.DAGGER_BLUE_folder.path}/Infrastructure"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "DAGGER_clients_folder" {
    path            = "${vsphere_folder.DAGGER_BLUE_folder.path}/Clients"
    type            = "vm"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

# OUTPUTS

output "DAGGER_DC_path" {
    value = vsphere_folder.DAGGER_DC_folder.path
}

output "DAGGER_Mbr_path" {
    value = vsphere_folder.DAGGER_Mbr_folder.path
}

output "DAGGER_Infra_path" {
    value = vsphere_folder.DAGGER_infrastructure_folder.path
}

output "DAGGER_Clients_path" {
    value = vsphere_folder.DAGGER_clients_folder.path
}

output "STARK_Int_subnet_h1_pg_net" {
    value = vsphere_distributed_port_group.STARK_Int_subnet_h1_pg
}

# output "STARK_Ext_subnet_h1_pg_net" {
#     value = vsphere_distributed_port_group.STARK_Ext_subnet_h1_pg
# }

output "SOC_subnet_h1_pg_net" {
    value = vsphere_distributed_port_group.SOC_subnet_h1_pg
}

output "TRAGIC_BEAR_subnet_h1_pg_net" {
    value = vsphere_distributed_port_group.STARK_Int_subnet_h1_pg
}