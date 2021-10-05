module rg {
  source = "../RG"
}

module vnet {
  source = "../VNET"
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  subnet_id                 = module.vnet.vnet_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}