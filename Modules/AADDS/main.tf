module svcacct {
  source = "../SVCACCT"
  rr_svc_acct_username = "avdsa@cwpsdev.com"
  rr_svc_acct_pw = "*Sdwwhabpw1!"
}

module rg {
  source = "../RG"
}

module vnet {
  source = "../VNET"
}

resource "azuread_group" "dcadmins" {
  display_name = "AAD DC Administrators"
  security_enabled = true
}

resource "azuread_group_member" "admins" {
  group_object_id  = azuread_group.dcadmins.object_id
  member_object_id = module.svcacct.object_id
}

resource "azuread_service_principal" "prod" {
  application_id = "2565bd9d-da50-47d4-8b85-4c97f669dc36"
}

resource "azurerm_active_directory_domain_service" "avd-domain" {
  name                = var.avd_domain_name
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name

  domain_name           = var.avd_domain_name
  sku                   = "Enterprise"
  filtered_sync_enabled = false

  initial_replica_set {
    subnet_id = module.vnet.vnet_subnet_id
  }

  notifications {
    additional_recipients = ["avdpilot@redriver.com"]
    notify_dc_admins      = true
    notify_global_admins  = true
  }

  security {
    sync_kerberos_passwords = true
    sync_ntlm_passwords     = true
    sync_on_prem_passwords  = true
  }

  tags = {
    Environment = var.tag_env
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  address_space       = module.vnet.vnet_address_space
  dns_servers         = [var.avd_net_dns1, var.avd_net_dns2]

subnet {
    name           = var.subnet_name
    address_prefix = module.vnet.vnet_subnet
  }

  tags = {
    environment = var.tag_env
  }
}