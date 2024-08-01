terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  # Update this block with the location of your terraform state file
  backend "azurerm" {
    resource_group_name  = "rg-terraform-stg"
    storage_account_name = "tfstgtommitest"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

// Tenant Data for Key vault
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "terraformsecrets" {
  name                = "tfsecretssensatech"
  resource_group_name = azurerm_resource_group.rg-terraform-stg.name
}

/*
  All resources for: rg-terraform-stg
*/
resource "azurerm_resource_group" "rg-terraform-stg" {
  name     = "rg-terraform-stg"
  location = "westeurope"
  tags = {
    TerraformStatus = "Managed"
  }
}


module "mod_stg_tfstgtommitest" {
  source                   = "./modules/storagesAccount"
  location                 = "westeurope"
  access_tier              = "Hot"
  resource_group_name      = azurerm_resource_group.rg-terraform-stg.name
  name                     = "tfstgtommitest"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

//KV for secrets to be used in Terraform
resource "azurerm_key_vault" "TerraformSecrets" {
  location            = azurerm_resource_group.rg-terraform-stg.location
  resource_group_name = azurerm_resource_group.rg-terraform-stg.name
  name                = "tfsecretssensatech"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  access_policy {
    
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}


resource "azurerm_key_vault_access_policy" "thomasAccessPolicy" {
  key_vault_id = azurerm_key_vault.TerraformSecrets.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = "6cbed2b9-f502-4efe-8774-21e8412c0e3e" #thomas@kerfisveita.is
  secret_permissions = [ "Get", ]

}
