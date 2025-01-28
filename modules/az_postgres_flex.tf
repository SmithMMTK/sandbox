resource "azurerm_postgresql_flexible_server" "psflexserver" {
  name = "pg-${var.resource_group_name_prefix}-${random_pet.rg_name.id}"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    administrator_login = "psqladmin"
    administrator_password = random_password.pqPwd.result
    version = "12"

    sku_name = "B_Standard_B1ms"
}

output "psql_admin_password" {
  value     = random_password.pqPwd.result
  sensitive = true
}