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

resource "azurerm_resource_group" "rg-terraform-stg" {
  name     = "rg-terraform-stg"
  location = "westeurope"
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

