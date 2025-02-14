# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appsvcplan" {
  name                = "appserviceplan-${random_integer.ri.result}"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

## Create the Linux Web App
resource "azurerm_linux_web_app" "linuxwebapp" {
  name                = "linuxwebapp-${random_integer.ri.result}"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_app_service_plan.appsvcplan.id

  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "20-lts"
      
    }

}

}
#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.linuxwebapp.id
  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch             = "main"
  use_manual_integration = true
  use_mercurial      = false

  ## Post deployment required for Node.js apps
  ## Enable SCM Basic Authentication in Site Configuration from "OFF" to "ON"
  ## And "Sync" the deployment in Deployment Center
  ## This is a one-time manual step to be done after the deployment
  ## Check progress in Log Stream

}

resource "azurerm_monitor_diagnostic_setting" "appsvclinux_diagnostic" {
  name               = "appsvclinux_diagnostic_setting_name"
  target_resource_id = azurerm_linux_web_app.linuxwebapp.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
      category = "AppServiceHTTPLogs"
    }

  enabled_log {
      category = "AppServiceConsoleLogs"
  }
  
  enabled_log {
      category = "AppServiceAppLogs"
  }

  enabled_log {
      category = "AppServiceAuditLogs"
  }

  enabled_log {
      category = "AppServicePlatformLogs"
  }

  enabled_log {
    category = "AppServiceIPSecAuditLogs" 
  }

  enabled_log {
      category = "AppServiceAuthenticationLogs"    
  }

}
output "WEBAPPURL" {
  value = "https://${azurerm_linux_web_app.linuxwebapp.name}.azurewebsites.net"
}