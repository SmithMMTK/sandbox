resource "azurerm_log_analytics_workspace" "log" {
    name                = var.log_analytics_workspace_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = "PerGB2018"
  
}

output "azurerm_log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log.name
  
}