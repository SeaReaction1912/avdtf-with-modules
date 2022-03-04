output "vm_name" {
  value = azurerm_virtual_machine.vm.*.name
  description = "VM Name"
}