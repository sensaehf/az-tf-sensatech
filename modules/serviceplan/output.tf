output "name" {
  value = azurerm_service_plan.App-service-plan.name
  description = "name of the Service Plan"
}

output "ID" {
  value = azurerm_service_plan.App-service-plan.id
  description = "App service ID"
}