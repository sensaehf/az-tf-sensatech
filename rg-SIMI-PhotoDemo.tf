resource "azurerm_resource_group" "rg-SIMI-PhotoDemo" {
  name     = "rg-SIMI-PhotoDemo"
  location = "North Europe"
}

resource "azurerm_logic_app_workflow" "PhotoDemo" {
  name                = "PhotoDemo"
  location            = azurerm_resource_group.rg-SIMI-PhotoDemo.location
  resource_group_name = azurerm_resource_group.rg-SIMI-PhotoDemo.name
}