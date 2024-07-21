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

variable "blue_infra_folder" {
    default = "/CDX Environment/OBSIDIAN DAGGER/Blue Team/Infrastructure"
}

variable "red_infra_folder" {
    default = "/CDX Environment/OBSIDIAN DAGGER/Red Team/TRAGIC BEAR/Infrastructure"
}

variable "datastore" {
    default = "Datastore_1"
}

variable "cluster" {
    default = "CDX"
}

variable "Blue_Ext_Net" {
    default = "Tier 2 - Toronto"
}

variable "Blue_Int_Net" {
    default = "STARK Internal"
}

variable "Blue_SOC_Net" {
    default = "Security Operations Center"
}

variable "Red_Ext_Net" {
    default = "Tier 2 - Vladivostok"
}

variable "Red_Int_Net" {
    default = "TRAGIC BEAR"
}