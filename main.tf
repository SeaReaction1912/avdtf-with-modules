terraform {

  required_version            = ">=0.12"
  
  required_providers {
    azurerm = {
      source                  = "hashicorp/azurerm"
      version                 = "~>2.0"
    }
  }

########################################################################################################################
# Remember to update this per your environment, however you end up wanting to managing state.  Here, it's stored in Blob
# Storage in the subscription where the Terraform SP has permissions.
########################################################################################################################
    backend "azurerm" {
    resource_group_name       = "rrautomation"
    storage_account_name      = "tfstate779643886"
    container_name            = "tfstate"
    key                       = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

########################################################################################################################
# For VM Boot Diagnostics storage.
########################################################################################################################
resource "random_string" "random" {
  count                       = 2
  length                      = 6
  special                     = false
  min_numeric                 = 6
}

########################################################################################################################
# Service Account Password, can be used in other modules though, like vpn for a Pre-shared Key.
########################################################################################################################
resource "random_string" "pw" {
  count                       = 2
  length                      = 24
  special                     = true
  min_numeric                 = 6
}

########################################################################################################################
# Deployment considerations for Module 'svcacct':
# Deploys to Azure AD, initial password will have to be changed in order to login to Desktops bound to AADDS domain,
# but they should have Domain Admin privileges in AADDS domain to run RSAT on the VM.
########################################################################################################################
module svcacct {
  count                       = 2
  source                      = "./modules/SVCACCT"
  rr_svc_acct_username        = "avdsa${count.index}@cwpsdev.com"
  rr_svc_acct_pw              = "${random_string.pw.0.result}"
  group_ob_id                 = module.aadds.group_ob_id
}

########################################################################################################################
# Deployment considerations for Module 'rg':
# Deploys a second Resource Group that should have networks available.
########################################################################################################################
module rg {
  count                       = 2
  source                      = "./modules/RG"
  rg_name                     = "rr-avd-rg${count.index}"
  rg_location                 = "eastus"
  #rg_tag                     = 
}

########################################################################################################################
# Deployment considerations for Module 'nsg':
# Deployed $NSG0 is associated to all $VNET0 subnets and VM0 NIC(s). And $NSG1 is associated to all $VNET1 subnets and 
# VM1 NIC(s).
# NSG Inbound rules allow 5986 for psremoting for Azure Devops(not ours) to configure the serverless DCs. Does not deploy
# without it.
# NSG Inbound rules allow 3389 from personal IP Address: 24.119.52.203 and needs updated per needs.
# NSG Outbound rules allow 80 and 443.  Inter-network(VNET to VNET) connectivity works regardless.
######################################################################################################################## 
module nsg {
  count                       = 2
  source                      = "./modules/NSG"
  tag_env                     = module.rg[count.index].rg_tag
  nsg_name                    = "nsg${count.index}"
  rg_location                 = module.rg[count.index].rg_location
  rg_name                     = module.rg[count.index].rg_name
  vnet_subnet_id              = module.vnet[count.index].subnet_ids[*]
  vnets                       = var.vnets
}

########################################################################################################################
# Deployment considerations for Module 'vnet':
# Deploys $VNETS per the terraform.tfvars file with the below specified DNS Servers.  Core to pretty much everything.
########################################################################################################################
module vnet {
  count                       = 2
  source                      = "./modules/VNET"
  tag_env                     = module.rg[count.index].rg_tag
  rg_name                     = module.rg[count.index].rg_name
  rg_location                 = module.rg[count.index].rg_location
  vnet_dns1                   = "192.168.0.4"
  vnet_dns2                   = "192.168.0.5"
  vnets                       = var.vnets
}

########################################################################################################################
# Deployment considerations for Module 'aadds':
# Deployed domain is bound to $VNET0.
# Change 'aadds_sku' to 'Standard', 'Enterprise', or 'Premium'.
# All users from Azure Tenant will have to change their password to access AADDS domain bound desktops.
########################################################################################################################
module aadds {
  source                      = "./modules/AADDS"
  tag_env                     = module.rg[0].rg_tag
  avd_domain_name             = "cwpsdev.com"
  aadds_sku                   = "Enterprise"
  vnet_name                   = "vnet-avd-ctr"
  subnet_name                 = "subnet-avd-ctr-1"
  avd_net_dns1                = "172.26.128.4"
  avd_net_dns2                = "172.26.128.5"
  rg_location                 = module.rg[0].rg_location
  rg_name                     = module.rg[0].rg_name
  vnet_subnet_id              = module.vnet[0].subnet_ids[0]
  rg                          = module.rg[0].rg_id
  vnets                       = var.vnets 
}

########################################################################################################################
# Deployment considerations for Module 'vm':
# VM0 is bound to $VNET0 (avd_net0).
# VM1 is bound to $VNET1 (avd_net0)
########################################################################################################################
module vm {
  count                       = 2
  source                      = "./modules/VM"
  tag_env                     = module.rg[0].rg_tag
  avd_dc_vm_admin_password    = "${random_string.pw.0.result}"
  vm_name                     = "aadds-mgr-temp${count.index}"
  vm_nic_name                 = "aadds-mgr-temp-nic${count.index}"
  rg_location                 = module.rg[count.index].rg_location
  rg_name                     = module.rg[count.index].rg_name
  vnet_subnet_id              = module.vnet[count.index].subnet_ids[0]
  blob_endpoint               = module.storageacct[count.index].blob_endpoint
  sa_name                     = "bootdiag${random_string.random[count.index].result}"
  nic-ip-cfg-name             = "avd-nic-ip-name${count.index}"
  nsg_ids                     = module.nsg[count.index].nsg_ids[0]
  vnets                       = var.vnets 
}

########################################################################################################################
# Deployment considerations for Module 'natgw':
# Binds only to $VNET0 (avd_net0).
########################################################################################################################
module natgw { 
  source                      = "./modules/NATGW"
#  natgw_pip_name             = 
  natgw_name                  = "avd-net-natgw"
  rg_location                 = module.rg[0].rg_location
  rg_name                     = module.rg[0].rg_name
  vnet_subnet_id              = module.vnet[0].subnet_ids[0]
  vnets                       = var.vnets
}

########################################################################################################################
# Deployment considerations for Module 'peerings':
# Peers $VNET0(avd_net0) and $VNET0(avd_net1)
########################################################################################################################
#module peerings {
#  source                      = "./modules/PEERINGS"
#  rg_name                     = module.rg[0].rg_name
#  peering_name                = "avdnet-to-dev-wvd-net"
#  client_net_id               = "/subscriptions/ab664da6-f5d7-408e-a8a6-4d0243b2edd2/resourceGroups/${module.rg[0].rg_name}/providers/Microsoft.Network/virtualNetworks/${module.vnet[0].vnet_names[1]}"
#  vnet_name                   = module.vnet[0].vnet_names[0]
#  peering_name1               = "dev-wvd-net-to-avdnet"
#  client_net_id1              = "/subscriptions/ab664da6-f5d7-408e-a8a6-4d0243b2edd2/resourceGroups/${module.rg[0].rg_name}/providers/Microsoft.Network/virtualNetworks/${module.vnet[0].vnet_names[0]}"
#  vnet_name1                  = module.vnet[0].vnet_names[1]
#  vnets                       = module.vnet[0]
#}

########################################################################################################################
# Deployment considerations for Module 'storageacct':
# Deploys both Storage Accounts to same Resource Group.
########################################################################################################################
module storageacct {
  count                       = 2
  source                      = "./modules/STORAGEACCT"
  tag_env                     = module.rg[0].rg_tag
  rg_name                     = module.rg[0].rg_name
  rg_location                 = module.rg[0].rg_location
  sa_name                     = "avdfsctr${count.index}"
  sa_fs_name                  = "profiles"
  fs_quota                    = "100"
  aadds                       = module.aadds
}

########################################################################################################################
# Deployment considerations for Module 'vpn':
# GatewaySubnet is required to deploy a VPN and is configured in the main.tf.
# VPN Client Address Space is required to be in a different address space than GatewaySubnet.
# Default config will not work, update 'client_local_gw_pip' and 'client_internal_subnet'.
# Gateway Transit is configured on the tunnel(allow_gateway_transit=true).
########################################################################################################################
 module vpn {
  source                      = "./modules/VPN"
  tag_env                     = module.rg[0].rg_tag
  rg_name                     = module.rg[0].rg_name
  rg_location                 = module.rg[0].rg_location
  vnet_subnet_id              = module.vnet[0].subnet_ids[0]
  vpn_net_addr_spc            = "192.168.254.0/24"
  vpn_pip_name                = "vpnpip"
  vpn_gw_name                 = "vpngw"
  client_local_gw_pip         = "1.2.3.4"
  client_local_gw_name        = "clientgw"
  client_internal_subnet      = "10.125.125.0/24"
  vpn_to_client_gw1_psk       = "${random_string.pw.1.result}"
  vpn_connection_name         = "vpnconnection"
  rtable_name                 = "vpn-rtable"
  vnets                       = var.vnets
}

########################################################################################################################
# Deployment considerations for Module alerts:
# Uncomment after Nerdio is built up and Log Analytics Workspace has been deployed from console.
########################################################################################################################
module alerts {
 source                       = "./modules/ALERTS"
 client_name                  = "CWPSDEV"
 workspace_id                 = "/subscriptions/ab664da6-f5d7-408e-a8a6-4d0243b2edd2/resourceGroups/${module.rg[0].rg_name}/providers/Microsoft.OperationalInsights/workspaces/web-admin-portal-law-4waqphok2643o"
 storageacct_id               = "/subscriptions/ab664da6-f5d7-408e-a8a6-4d0243b2edd2/resourceGroups/${module.rg[0].rg_name}/providers/Microsoft.Storage/storageAccounts/${module.storageacct[0].sa_name}/fileServices/default"
 storageacct_threshold_bytes  = "26388279066624"
 rg_name                      = module.rg[0].rg_name
 rg_id                        = module.rg[0].rg_id
 rg_location                  = module.rg[0].rg_location
}