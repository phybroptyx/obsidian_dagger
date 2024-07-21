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

variable "win_admin_password" {
    default = "P@ssw0rd303"
}

variable "vcenter" {
    description = "VCenter FQDN"
    type        = string
    sensitive   = true
}

variable "dc" {
    default = "CDX Datacenter"
}

variable "dc_folder" {
    default = "/CDX Environment/OBSIDIAN DAGGER/Blue Team/Domain Controllers"
}

variable "mbr_folder" {
    default = "/CDX Environment/OBSIDIAN DAGGER/Blue Team/Member Servers"
}

variable "cli_folder" {
    default = "/CDX Environment/OBSIDIAN DAGGER/Blue Team/Clients"
}

variable "apt_cli_folder" {
    default = "/CDX Environment/OBSIDIAN DAGGER/Red Team/TRAGIC BEAR/Clients"
}

variable "apt_srv_folder" {
    default = "/CDX Environment/OBSIDIAN DAGGER/Red Team/TRAGIC BEAR/Servers"
}

variable "datastore" {
    default = "Datastore_3"
}

variable "cluster" {
    default = "CDX"
}

variable "Datacenter_Net" {
    default = "STARK Internal"
}

variable "RED_OPNET" {
    default = "TRAGIC BEAR"
}

variable "vm_clone_timeout" {
    default = "60"
}