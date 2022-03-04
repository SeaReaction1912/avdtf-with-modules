resource "azurerm_virtual_network_peering" "peering" {
  name                         = var.peering_name
  resource_group_name          = var.rg_name
  virtual_network_name         = var.vnet_name
  remote_virtual_network_id    = var.client_net_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = true
}