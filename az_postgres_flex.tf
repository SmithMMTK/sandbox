resource "random_password" "pqPwd" {
  length           = 16
  special          = true
  override_special = "_%@"
}


resource "azurerm_private_dns_zone" "default" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${random_pet.rg_name.id}-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}


resource "azurerm_postgresql_flexible_server" "psflexserver" {
  name = "${random_pet.rg_name.id}"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    administrator_login = "psqladmin"
    administrator_password = random_password.pqPwd.result
    version = "12"
    sku_name = "GP_Standard_D2s_v3"

    //private_dns_zone_id    = azurerm_private_dns_zone.default.id
    //public_network_access_enabled = false

    //depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}

output "psql_flex_server_name" {
  value = azurerm_postgresql_flexible_server.psflexserver.name
}

output "administrator_login" {
  value = azurerm_postgresql_flexible_server.psflexserver.administrator_login
}

output "psql_admin_password" {
  value     = random_password.pqPwd.result
  sensitive = true
}