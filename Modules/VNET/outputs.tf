output "vnet_names" {
  value = var.vnets[*].vnet_name
  description = "The AVD Virtual Network Name"
}

output "vnet_address_space" {
  value = flatten([[for nets in var.vnets : nets][*].address_space])
  description = "The AVD VNET address space with CIDR"
}

output "subnet_ids" {
     value = flatten(azurerm_virtual_network.vnet[*].subnet.*.id)
     description = "All subnet IDs"
}

output "subnets" {
  value = flatten([[for nets in var.vnets : nets][*].subnets.*.address])
  description = "All subnet addresses"
}

output "subnet_names" {
  value = flatten([[for nets in var.vnets : nets][*].subnets.*.name])
  description = "All Subnet Names"
}

#flatten(azurerm_virtual_network.vnet.*.subnet.*.address_prefix)
