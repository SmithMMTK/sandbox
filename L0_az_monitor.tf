
resource "azurerm_log_analytics_workspace" "log" {
    name                = "law-${random_pet.rg_name.id}"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = "PerGB2018"
  
}

resource "azurerm_application_insights" "appInsight" {
  name = "appInsight-${random_pet.rg_name.id}"
  location = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id = azurerm_log_analytics_workspace.log.id
  application_type = "Node.JS"

}

output "LOG_ANALYTICS_WORKSPACE_NAME" {
  value = azurerm_log_analytics_workspace.log.name
  
}