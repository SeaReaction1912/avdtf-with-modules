module rg {
  source = "../RG"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  address_space       = [var.avd_net_eastus_cidr]
  
subnet {
    name           = var.subnet_name
    address_prefix = var.avd_net_eastus_subnet
  }

  tags = {
    environment = var.tag_env
  }
}