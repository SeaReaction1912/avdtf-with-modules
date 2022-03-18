output "vnet_subnet_ids" {
  value = azurerm_virtual_network_gateway.vpngw.ip_configuration.0.subnet_id
  description = "The AVD Virtual Network Name"
}