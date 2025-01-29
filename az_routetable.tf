resource "azurerm_route_table" "example" {
  name                = "${random_pet.rg_name.id}-rt"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


}