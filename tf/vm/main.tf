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

module "SDP" {
    source = "./SDP"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-DC" {
    source = "./STARK-Domain-Controllers"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-Servers" {
    source = "./STARK-Member-Servers"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-HR" {
    source = "./STARK-HR"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-DEV" {
    source = "./STARK-DEV"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-OPS" {
    source = "./STARK-OPS"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "STARK-RESEARCH" {
    source = "./STARK-RESEARCH"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}

module "TRAGIC_BEAR" {
    source = "./TRAGIC_BEAR"
    username        = var.username
    password        = var.password
    vcenter         = var.vcenter
}