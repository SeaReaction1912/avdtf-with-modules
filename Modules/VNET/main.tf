resource "azurerm_virtual_network" "vnet" {
  count               = length(var.vnets)
  name                = var.vnets[count.index].vnet_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = var.vnets[count.index].address_space
  dns_servers         = ["${var.vnet_dns1}", "${var.vnet_dns2}"]

  dynamic "subnet" {
    for_each = var.vnets[count.index].subnets

  content {
    name              = subnet.value.name
    address_prefix    = subnet.value.address
  }
}
}