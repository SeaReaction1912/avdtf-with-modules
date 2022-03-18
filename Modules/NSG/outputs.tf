output "tag_env" {
  value = var.tag_env
  description = "The environment tag"
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg[*].*.name
  description = "Network Security Group Names"
}

output "nsg_ids" {
  value = flatten(azurerm_network_security_group.nsg[*].*.id)
  description = "Network Security Group IDs"
}