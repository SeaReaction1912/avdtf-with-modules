terraform {

  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }

    backend "azurerm" {
    resource_group_name = "rrautomation"
    storage_account_name = "tfstate338946086"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "random" {
  length           = 6
  special          = false
  min_numeric      = 6
}

resource "random_string" "pw" {
  length           = 24
  special          = true
  min_numeric      = 6
}

#module svcacct {
  #source = "./modules/SVCACCT"
  #rr_svc_acct_username = "avdsa@domain.com"
  #rr_svc_acct_pw = "${random_string.pw.result}"
  #group_ob_id = module.aadds.group_ob_id
#}

module rg {
  source           = "./modules/RG"
# rg_name          =
# rg_location      = 
}

module nsg {
  source           = "./modules/NSG"
# tag_env        =
# nsg_name       =
  rg_location    = module.rg.rg_location
  rg_name        = module.rg.rg_name
  vnet_subnet_id = module.vnet.vnet_subnet_id
}

module vnet {
  source         = "./modules/VNET"
  # tag_env      =
  vnet_name      = "vnet-avd-ctr"
  subnet_name    = "subnet-avd-ctr-1"
  avd_net_eastus_cidr     = "172.26.128.0/17"
  avd_net_eastus_subnet   = "172.26.128.0/23"
  rg_location    = module.rg.rg_location
  rg_name        = module.rg.rg_name
}

#module vnet {
  #source        = "./modules/VNET"
  # tag_env      =
  #vnet_name     = "vnet-avd-emp"
  #subnet_name   = "subnet-avd-emp-1"
  #avd_net_eastus2_cidr   = "172.26.0.0/17"
  #avd_net_eastus2_subnet = "172.16.0.0/23"
#}

module aadds {
  source         = "./modules/AADDS"
  # tag_env      = 
  avd_domain_name= "cloud.redriver.com"
  aadds_sku      =  "Standard"
  vnet_name      = "vnet-avd-ctr"
  subnet_name    = "subnet-avd-ctr-1"
  avd_net_dns1   = "172.26.128.4"
  avd_net_dns2   = "172.26.128.5"
  rg_location    = module.rg.rg_location
  rg_name        = module.rg.rg_name
  vnet_subnet_id = module.vnet.vnet_subnet_id
  rg             = module.rg.rg_id
}

 module vm {
  source         = "./modules/VM"
  count          = 1
  vm_count       = 1
  #tag_env       =
  avd_dc_vm_admin_password = "${random_string.pw.result}"
  vm_name        = join("", ["aadds-mgr-temp", count.index])
  vm_pip_name    = "aadds-mgr-temp-pip"
  vm_nic_name    = "aadds-mgr-temp-nic"
  rg_location    = module.rg.rg_location
  rg_name        = module.rg.rg_name
  vnet_subnet_id = module.vnet.vnet_subnet_id
  blob_endpoint  = module.storageacct.blob_endpoint
  sa_name        = join("", ["bootdiag", "${random_string.random.result}"])
}

#module natgw {
 # source        = "./modules/NATGW"
  # natgw_pip_name         =
  # natgw_name   =
  # rg_location  = module.rg.rg_location
  # rg_name      = module.rg.rg_name
#}


# module peerings {
  # source       = "./modules/PEERINGS"
  # peering_name =
  # client_net_id=
  # rg_name      = module.rg.rg_name
  # vnet_name    = module.vnet.vnet_name
#}

module storageacct {
  source         = "./modules/STORAGEACCT"
  # tag_env      =
   sa_name       = "avdfsctr"
   sa_fs_name    = "profiles"
   fs_quota      = "100"
   rg_location   = module.rg.rg_location
   rg_name       = module.rg.rg_name
}

# module vpn {
#  source        = "./modules/VPN"
#  tag_env       =
#  vpn_net_name  = 
#  avd_vpn_cidr  =
#  avd_vpn_gw_net=
#  vpn_pip_name  =
#  vpn_gw_name   =
#  client_local_gw_pip     =
#  client_local_gw_name    =
#  client_internal_subnet  =
#  vpn_to_client_gw1_psk   = 
#  vpn_connection_name     = 
#  rtable_name   = 
#  rg_location   = module.rg.rg_location
#  rg_name       = module.rg.rg_name
#}

#module alerts {
# source         = "./modules/ALERTS"
# client_name    = "client"
# workspace_id   = "/subscriptions/[Subscription ID]/resourceGroups/[Resource Group]/providers/Microsoft.OperationalInsights/workspaces/[Log Analytics Workspace ID]"
# storageacct_id = "/subscriptions/[Subscription ID]/resourceGroups/[Resource Group]/providers/Microsoft.Storage/storageAccounts/[Storage Account Name/ID]"
# storageacct_threshold_bytes= "26388279066624"
# storageacct_region       = 
#}