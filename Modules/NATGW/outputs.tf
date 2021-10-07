output "natgw_pip_name" {
  value = azurerm_public_ip.natgw-pip.name
  description = "NAT Gateway Public IP Name"
}

output "natgw_name" {
  value = azurerm_nat_gateway.natgw.name
  description = "NAT Gateway Name"
}