import {
  id = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DefaultResourceGroup-EUS"
  to = azurerm_resource_group.DefaultResourceGroup-EUS
}

resource "azurerm_resource_group" "DefaultResourceGroup-EUS" {
  name = "DefaultResourceGroup-EUS"
  location = "East US"
}

import {
  id = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourcegroups/defaultresourcegroup-eus/providers/microsoft.operationalinsights/workspaces/defaultworkspace-3846f4f0-152c-49d5-9779-9998df4a2c0c-eus"
  to = azurerm_log_analytics_workspace.DefaultWorkspace-3846f4f0-152c-49d5-9779-9998df4a2c0c-EUS
}
resource "azurerm_log_analytics_workspace" "DefaultWorkspace-3846f4f0-152c-49d5-9779-9998df4a2c0c-EUS" {
    location = azurerm_resource_group.DefaultResourceGroup-EUS.location
    resource_group_name = azurerm_resource_group.DefaultResourceGroup-EUS.name
    name = "DefaultWorkspace-3846f4f0-152c-49d5-9779-9998df4a2c0c-EUS"
}