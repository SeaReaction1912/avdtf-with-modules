output "tag_env" {
  value = var.tag_env
  description = "The environment tag"
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
  description = "Network Security Group Name"
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
  description = "Network Security Group ID"
}