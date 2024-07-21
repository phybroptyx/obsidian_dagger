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

data "vsphere_network" "pg_blue_ext" {
    name = var.Blue_Ext_Net
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "pg_blue_int" {
    name = var.Blue_Int_Net
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "pg_blue_soc" {
    name = var.Blue_SOC_Net
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "pg_red_ext" {
    name = var.Red_Ext_Net
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "pg_red_int" {
    name = var.Red_Int_Net
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_vyos" {
  # name          = "Base_VyOS_1.5"
  name          = "Templ_VyOS_1.5"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "SDP-STK-1" {
  name             = "SDP-STK-1"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 1
  memory           = 1024
  guest_id         = data.vsphere_virtual_machine.template_vyos.guest_id
  folder           = var.blue_infra_folder
  scsi_type        = data.vsphere_virtual_machine.template_vyos.scsi_type
  sync_time_with_host = true
  network_interface {
    network_id   = data.vsphere_network.pg_blue_ext.id
    # adapter_type = data.vsphere_virtual_machine.template_vyos.network_interface_types[0]
  }
  network_interface {
    network_id   = data.vsphere_network.pg_blue_int.id
    # adapter_type = data.vsphere_virtual_machine.template_vyos.network_interface_types[0]
  }
  network_interface {
    network_id   = data.vsphere_network.pg_blue_soc.id
    # adapter_type = data.vsphere_virtual_machine.template_vyos.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_vyos.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_vyos.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_vyos.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_vyos.id
  }

  wait_for_guest_net_timeout = 0
}

resource "vsphere_virtual_machine" "SDP-TGB-1" {
  name             = "SDP-TGB-1"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.store.id
  num_cpus         = 1
  memory           = 1024
  guest_id         = data.vsphere_virtual_machine.template_vyos.guest_id
  folder           = var.red_infra_folder
  scsi_type        = data.vsphere_virtual_machine.template_vyos.scsi_type
  sync_time_with_host = true
  network_interface {
    network_id   = data.vsphere_network.pg_red_ext.id
    # adapter_type = data.vsphere_virtual_machine.template_vyos.network_interface_types[0]
  }
  network_interface {
    network_id   = data.vsphere_network.pg_red_int.id
    # adapter_type = data.vsphere_virtual_machine.template_vyos.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_vyos.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_vyos.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_vyos.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_vyos.id
  }

  wait_for_guest_net_timeout = 0
}