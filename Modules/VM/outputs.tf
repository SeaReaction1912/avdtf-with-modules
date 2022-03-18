output "vm_name" {
  value = azurerm_virtual_machine.vm[*].*.name
  description = "VM Name"
}

output "vm_nic_net_id" {
  description = "VM NIC Subnet IDs"
  value = azurerm_network_interface.vm-nic[*].ip_configuration.*.subnet_id
}

output "vm_nic_id" {
  description = "VM NIC IDs"
  value = azurerm_network_interface.vm-nic.*.id
}
