output "peering_name" {
  value = azurerm_virtual_network_peering.peering.name
  description = "VNET Peering Name"
}

output "client_net_id" {
  value = azurerm_virtual_network_peering.peering.remote_virtual_network_id
  description = "/subscriptions/[Subscription ID]/resourceGroups/[Resource Group Name]/providers/Microsoft.Network/virtualNetworks/[Virtual Network Name]' format"
}