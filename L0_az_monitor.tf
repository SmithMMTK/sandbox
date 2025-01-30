
resource "azurerm_log_analytics_workspace" "log" {
    name                = "law-${random_pet.rg_name.id}"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = "PerGB2018"
  
}

output "LOG_ANALYTICS_WORKSPACE_NAME" {
  value = azurerm_log_analytics_workspace.log.name
  
}