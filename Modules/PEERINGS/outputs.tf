output "peering_name" {
  value = var.peering_name
  description = "VNET Peering Name"
}

output "client_net_id" {
  value = var.client_net_id
  description = "/subscriptions/[Subscription ID]/resourceGroups/[Resource Group Name]/providers/Microsoft.Network/virtualNetworks/[Virtual Network Name]' format"
}