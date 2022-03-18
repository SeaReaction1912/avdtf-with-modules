resource "azurerm_storage_account" "bootdiag" {
  name                     = var.sa_name
  location                 = var.rg_location
  resource_group_name      = var.rg_name
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = var.tag_env
}

resource "azurerm_network_interface" "vm-nic" {
  name                      = "${var.vm_nic_name}"
  location                  = var.rg_location
  resource_group_name       = var.rg_name

  ip_configuration {
    name                          = var.nic-ip-cfg-name
    subnet_id                     = "${var.vnet_subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tag_env
}

resource "azurerm_virtual_machine" "vm" {
    name                  = "${var.vm_name}"
    location              = var.rg_location
    resource_group_name   = var.rg_name
    network_interface_ids = [azurerm_network_interface.vm-nic.id]
    vm_size               = "Standard_DS1_v2"
  
    storage_os_disk {
      name              = "${var.vm_name}-os-disk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Premium_LRS"
    }
  
    storage_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
  
    os_profile {
      computer_name  = "${var.vm_name}"
      admin_username = "rradmin"
      admin_password = var.avd_dc_vm_admin_password
    }
  
    os_profile_windows_config {
      provision_vm_agent = true
    }
  
    boot_diagnostics {
      enabled     = true
      storage_uri = azurerm_storage_account.bootdiag.primary_blob_endpoint
    }
  
    tags = var.tag_env

    depends_on = [azurerm_network_interface.vm-nic, var.vnets]
  }

resource "azurerm_network_interface_security_group_association" "nsg-assoc" {
  count                                = length(azurerm_virtual_machine.vm[*].network_interface_ids[0])
  network_interface_id                 = azurerm_virtual_machine.vm.network_interface_ids[0]
  network_security_group_id            = var.nsg_ids

  depends_on = [azurerm_virtual_machine.vm]
}