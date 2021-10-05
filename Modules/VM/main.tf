module rg {
  source = "../RG"
}

module storageacct {
  source = "../STORAGEACCT"
}

module vnet {
  source = "../VNET"
}

resource "azurerm_public_ip" "vm-pip" {
  name                = var.vm_pip_name
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "vm-nic" {
  name                      = var.vm_nic_name
  location                  = module.rg.rg_location
  resource_group_name       = module.rg.rg_name

  ip_configuration {
    name                          = "avd-nic-ip-name"
    subnet_id                     = module.vnet.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-pip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_virtual_machine" "vm" {
    name                  = var.vm_name
    location              = module.rg.rg_location
    resource_group_name   = module.rg.rg_name
    network_interface_ids = [azurerm_network_interface.vm-nic.id]
    vm_size               = "Standard_DS1_v2"
  
    storage_os_disk {
      name              = "os-disk"
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
      computer_name  = var.vm_name
      admin_username = "rradmin"
      admin_password = var.avd_dc_vm_admin_password
    }
  
    os_profile_windows_config {
      provision_vm_agent = true
    }
  
    boot_diagnostics {
      enabled     = true
      storage_uri = module.storageacct.blob_endpoint
    }
  
    tags = {
      environment = var.tag_env
    }

    depends_on = [
      azurerm_network_interface.vm-nic,
    ]
  }