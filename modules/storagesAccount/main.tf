resource "azurerm_storage_account" "stg" {
  location = var.location
  access_tier = var.access_tier
  resource_group_name = var.resource_group_name
  name = var.name
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  tags = {
    TerraformStatus = "Managed"
  }
}