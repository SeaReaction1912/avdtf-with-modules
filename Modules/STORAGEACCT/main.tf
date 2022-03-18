
resource "azurerm_storage_account" "storageacct" {
  name                     = var.sa_name
  location                 = var.rg_location
  resource_group_name      = var.rg_name
  account_kind             = "FileStorage"
  account_replication_type = "LRS"
  account_tier             = "Premium"
  
  azure_files_authentication {
    directory_type = "AADDS"
  }
  
  tags = var.tag_env

  depends_on = [var.aadds]

}

resource "azurerm_storage_share" "fileshare" {
  name                 = var.sa_fs_name
  storage_account_name = azurerm_storage_account.storageacct.name
  quota                = var.fs_quota
}