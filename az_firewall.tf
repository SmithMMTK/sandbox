
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

resource "azurerm_firewall_policy_rule_collection_group" "net_policy_rule_collection_group" {
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 200

}

resource "azurerm_firewall_policy_rule_collection_group" "app_policy_rule_collection_group" {
  name               = "DefaulApplicationtRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 300

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

output "AZUREFIREWALLPUBLICIP" {
  value = azurerm_public_ip.pip_azfw.ip_address
  
}