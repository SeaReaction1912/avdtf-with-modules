output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
  description = "The AVD Virtual Network Name"
}

output "vnet_subnet_id" {
  value = azurerm_virtual_network.vnet.subnet.*.id[0]
  description = "The AVD Virtual Network Subnet ID"
}

output "vnet_address_space" {
  value = azurerm_virtual_network.vnet.address_space
  description = "The AVD VNET address space with CIDR"
}

output "vnet_subnet" {
  value = var.avd_net_eastus_subnet
  description = "The AVD Virtual Network Subnet address prefix"
}
