
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel_law" {
  workspace_id        = azurerm_log_analytics_workspace.log.id
}