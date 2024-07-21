variable "username" {
    description = "Vcenter Username"
    type        = string
    sensitive   = true
}

variable "password" {
    description = "Vcenter Password"
    type        = string
    sensitive   = true
}

variable "vcenter" {
    description = "VCenter FQDN"
    type        = string
    sensitive   = true
}

variable "dc" {
    default = "CDX Datacenter"
}

variable "vds" {
    default = "CDX-E"
}

variable "VM_parent_folder" {
    default = "CDX Environment/OBSIDIAN DAGGER"
}

variable "parent_folder" {
    default = "CDX Environment"
}

variable "datastore" {
    default = "Datastore_1"
}

variable "cluster" {
    default = "CDX"
}

variable "host_1" {
    default = "cdx-esxi-01.cdx.lab"
}

variable "host_2" {
    default = "cdx-esxi-02.cdx.lab"
}

variable "host_3" {
    default = "cdx-esxi-03.cdx.lab"
}