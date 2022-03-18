resource "azurerm_public_ip" "avd-net-dc-vm-pip" {
  name                = "avd-net-dc-vm-pip"
  location            = azurerm_resource_group.avd-rg-eastus.location
  resource_group_name = azurerm_resource_group.avd-rg-eastus.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "avd-dc01-nic" {
  name                      = "avd-dc01-nic"
  location                  = azurerm_resource_group.avd-rg-eastus.location
  resource_group_name       = azurerm_resource_group.avd-rg-eastus.name
  network_security_group_id = azurerm_network_security_group.avd-net-nsg.id

  ip_configuration {
    name                          = "avd-net-ip"
    subnet_id                     = azurerm_subnet.avd-net-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.avd-net-dc-vm-pip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_virtual_machine" "avd-dc01" {
    name                  = "avd-dc01"
    location              = azurerm_resource_group.avd-rg-eastus.location
    resource_group_name   = azurerm_resource_group.avd-rg-eastus.name
    network_interface_ids = [azurerm_network_interface.avd-net-ip.id]
    vm_size               = "Standard_DS1_v2"
  
    storage_os_disk {
      name              = "avd-dc01-os"
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
      computer_name  = "avd-dc01"
      admin_username = "rradmin"
      admin_password = var.avd_dc_vm_admin_password
    }
  
    os_profile_windows_config {
      provision_vm_agent = true
    }
  
    boot_diagnostics {
      enabled     = true
      storage_uri = azurerm_storage_account.avd-storage-eastus.primary_blob_endpoint
    }
  
    tags = {
      environment = var.tag_env
    }
  }