resource "azurerm_resource_group" "rg-AZFunction-test" {
  name     = "rg-AZFunction-test"
  location = "westeurope"
  tags = {
    TerraformStatus = "Managed"
  }
}


module "azFunctionTesterTommi-stg" {
  source = "./modules/storagesAccount"
  name = "azfntestertommiapptest"
  resource_group_name = azurerm_resource_group.rg-AZFunction-test.name
}


module "azFunctionTesterTommi-app-service" {
  source = "./modules/serviceplan"
  name = "azFunciontTest-serviceplan"
  location = azurerm_resource_group.rg-AZFunction-test.location
  resource_group_name = azurerm_resource_group.rg-AZFunction-test.name
}

resource "azurerm_windows_function_app" "azFunctionTesterTommi" {
  name                = "azFunctionTesterTommi-function-App"
  resource_group_name = azurerm_resource_group.rg-AZFunction-test.name
  location            = azurerm_resource_group.rg-AZFunction-test.location

  storage_account_name       = module.azFunctionTesterTommi-stg.name
  storage_account_access_key = module.azFunctionTesterTommi-stg.primary_access_key
  service_plan_id            = module.azFunctionTesterTommi-app-service.ID

  site_config {}
}