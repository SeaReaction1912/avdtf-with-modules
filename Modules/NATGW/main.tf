module rg {
  source = "../RG"
}

resource "azurerm_public_ip" "natgw-pip" {
  name                = var.natgw_pip_name
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "natgw" {
  name                    = var.natgw_name
  location                = module.rg.rg_location
  resource_group_name     = module.rg.rg_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "natgw-pip-assoc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.natgw-pip.id
}