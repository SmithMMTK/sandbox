variable "log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analytics workspace to create for the AKS cluster."
  default     = "loganalytics"
}



resource "azurerm_log_analytics_workspace" "log" {
    name                = var.log_analytics_workspace_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = "PerGB2018"
  
}

output "LOG_ANALYTICS_WORKSPACE_NAME" {
  value = azurerm_log_analytics_workspace.log.name
  
}