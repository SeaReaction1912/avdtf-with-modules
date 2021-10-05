terraform {

  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module aadds {
  source = "./modules/AADDS"
  # tag_env = 
  # avd_domain_name = 
  # vnet_name =
  # subnet_name = 
  # avd_net_dns1 = 
  # avd_net_dns2 =
}

module natgw {
  source = "./modules/NATGW"
  # natgw_pip_name =
  # natgw_name =
}

module nsg {
  source = "./modules/NSG"
  # tag_env =
  # nsg_name =
}

# module peerings {
  # source = "./modules/PEERINGS"
  # peering_name =
  # client_net_id =
#}

module rg {
  source = "./modules/RG"
  # tag_env = 
  # rg_name =
  # rg_location = 
}

module storageacct {
  source = "./modules/STORAGEACCT"
  # tag_env =
  # sa_name =
  # sa_fs_name =
  # fs_quota =
}

module svcacct {
  source = "./modules/SVCACCT"
  rr_svc_acct_username = "avdsa@domain.com"
  rr_svc_acct_pw = ""
}

module vm {
  source = "./modules/VM"
  avd_dc_vm_admin_password = ""
  # tag_env =
  # vm_name =
  # vm_pip_name =
  # vm_nic_name =
}

module vnet {
  source = "./modules/VNET"
  # tag_env =
  # vnet_name =
  # subnet_name =
  # avd_net_eastus_cidr = 
  # avd_net_eastus_subnet =
}

# module vpn {
#  source = "./modules/VPN"
#  tag_env =
#  vpn_net_name = 
#  avd_vpn_cidr =
#  avd_vpn_gw_net =
#  vpn_pip_name =
#  vpn_gw_name =
#  client_local_gw_pip =
#  client_local_gw_name =
#  client_internal_subnet =
#  vpn_to_client_gw1_psk = 
#  vpn_connection_name = 
#  rtable_name = 
#}
