output "name" {
  value = azurerm_storage_account.stg.name
  description = "name of the Name"
}

output "id" {
  value = azurerm_storage_account.stg.id
  description = "ID of the storageaccount"
}


output "primary_access_key" {
  value = azurerm_storage_account.stg.primary_access_key
  description = "Prime Access KEy of the stg"
}