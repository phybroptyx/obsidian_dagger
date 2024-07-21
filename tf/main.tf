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

module "environment" {
    source = "./environment"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "SDP" {
    source = "./vm/SDP"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-DC" {
    source = "./vm/STARK-Domain-Controllers"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-Servers" {
    source = "./vm/STARK-Member-Servers"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-HR" {
    source = "./vm/STARK-HR"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-DEV" {
    source = "./vm/STARK-DEV"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-OPS" {
    source = "./vm/STARK-OPS"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-RESEARCH" {
    source = "./vm/STARK-RESEARCH"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "TRAGIC_BEAR" {
    source = "./vm/TRAGIC_BEAR"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}
