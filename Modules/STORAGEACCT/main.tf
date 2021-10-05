module rg {
  source = "../RG"
}

resource "azurerm_storage_account" "storageacct" {
  name                     = var.sa_name
  location                 = module.rg.rg_location
  resource_group_name      = module.rg.rg_name
  account_replication_type = "LRS"
  account_tier             = "Premium"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_storage_share" "fileshare" {
  name                 = var.sa_fs_name
  storage_account_name = azurerm_storage_account.storageacct.name
  quota                = var.fs_quota
}