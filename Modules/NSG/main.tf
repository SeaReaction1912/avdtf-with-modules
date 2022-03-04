resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.rg_location
  resource_group_name = var.rg_name

security_rule {
    name                       = "Allow5986"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow3389"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "24.119.52.203"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  subnet_id                 = var.vnet_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}