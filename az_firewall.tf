
resource "azurerm_public_ip" "pip_azfw" {
  name                = "pip-azfw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "azfw_policy" {
  name                     = "azfw-policy"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  threat_intelligence_mode = "Alert"
}

resource "azurerm_ip_group" "workload_ip_group" {
  name                = "workload-ip-group"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cidrs               = ["10.0.1.0/24"]
}

resource "azurerm_firewall_policy_rule_collection_group" "net_policy_rule_collection_group" {
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 200

    network_rule_collection {
    name     = "DefaultNetworkRuleCollection"
    action   = "Allow"
    priority = 200
    rule {
      name                  = "time-windows"
      protocols             = ["UDP"]
      source_ip_groups      = [azurerm_ip_group.workload_ip_group.id]
      destination_ports     = ["123"]
      destination_addresses = ["132.86.101.172"]
    }
  }

}

resource "azurerm_firewall_policy_rule_collection_group" "app_policy_rule_collection_group" {
  name               = "DefaulApplicationtRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 300

    application_rule_collection {
    name     = "DefaultApplicationRuleCollection"
    action   = "Allow"
    priority = 500

    rule {
      name        = "Global Rule"
      description = "Allow access to target destination"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      destination_fqdns = ["*.google.com","ifconfig.me"]
      terminate_tls     = false
      source_ip_groups  = [azurerm_ip_group.workload_ip_group.id]
    }
  }

}

resource "azurerm_firewall" "fw" {
  name                = "azfw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  ip_configuration {
    name                 = "azfw-ipconfig"
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.pip_azfw.id
  }
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
}



resource "azurerm_monitor_diagnostic_setting" "azfw_diagnostic" {
  name = "azfw-diagnostic"
  target_resource_id = azurerm_firewall.fw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
  category = "AzureFirewallApplicationRule"
}

enabled_log {
  category = "AzureFirewallNetworkRule"
}

enabled_log {
  category = "AzureFirewallDnsProxy"
}

enabled_log {
  category = "AZFWNetworkRule"
}

enabled_log {
  category = "AZFWApplicationRule"
}

enabled_log {
  category = "AZFWNatRule"
}

enabled_log {
  category = "AZFWThreatIntel"
}

enabled_log {
  category = "AZFWIdpsSignature"
}

enabled_log {
  category = "AZFWDnsQuery"
}

enabled_log {
  category = "AZFWFqdnResolveFailure"
}

enabled_log {
  category = "AZFWFatFlow"
}

enabled_log {
  category = "AZFWFlowTrace"
}

enabled_log {
  category = "AZFWApplicationRuleAggregation"
}

enabled_log {
  category = "AZFWNetworkRuleAggregation"
}

enabled_log {
  category = "AZFWNatRuleAggregation"
}

}

output "AZUREFIREWALLPUBLICIP" {
  value = azurerm_public_ip.pip_azfw.ip_address
  
}