resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = [var.avd_net_eastus_cidr]

  tags = var.tag_env
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.avd_net_eastus_subnet]
}  