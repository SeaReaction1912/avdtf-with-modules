output "sa_name" {
  value = var.sa_name
  description = "The Storage Account Name"
}

output "blob_endpoint" {
  value = azurerm_storage_account.storageacct.primary_blob_endpoint
  description = "The Storage Account Primary Blob Endpoint"
}