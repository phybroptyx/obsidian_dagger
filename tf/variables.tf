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

variable "VM_parent_folder" {
    default = "CDX Environment"
}

variable "datastore" {
    default = "Datastore_1"
}

variable "cluster" {
    default = "CDX"
}

variable "vm_clone_timeout" {
    default = "20"
}
