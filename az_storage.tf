resource "azurerm_storage_account" "blob" {
    name                    = replace("st${random_pet.rg_name.id}","-","")
    resource_group_name     = azurerm_resource_group.rg.name
    location                = azurerm_resource_group.rg.location
    account_tier            = "Standard"
    account_replication_type = "LRS"
}


resource "azurerm_storage_container" "container" {
    name                  = "mycontainer"
    storage_account_name  = azurerm_storage_account.blob.name
    container_access_type = "private"
}

resource "azurerm_storage_blob" "textfile" {
    name                   = "myfile.txt"
    storage_account_name   = azurerm_storage_account.blob.name
    storage_container_name = azurerm_storage_container.container.name
    type                   = "Block"
    source                 = "textfile.txt"
  
}

output "STORAGE_ACCOUNT_NAME" {
    value = azurerm_storage_account.blob.name
}