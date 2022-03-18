resource "azuread_group" "dcadmins" {
  display_name = "AAD DC Administrators"
  security_enabled = true
}

resource "azuread_service_principal" "prod" {
  application_id = "2565bd9d-da50-47d4-8b85-4c97f669dc36"
}

resource "azurerm_active_directory_domain_service" "avd-domain" {
  name                = var.avd_domain_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  domain_name           = var.avd_domain_name
  sku                   = var.aadds_sku
  filtered_sync_enabled = false

  initial_replica_set {
    subnet_id = "${var.vnet_subnet_id}"
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

  tags = var.tag_env

  depends_on = [var.rg, var.vnets]
}