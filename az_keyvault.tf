data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name               = "kv-${random_pet.rg_name.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
}

output "azurerm_key_vault_name" {
  value = azurerm_key_vault.vault.name
}