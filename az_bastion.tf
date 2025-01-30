# Create Public IP for Azure Bastion
resource "azurerm_public_ip" "bastion_pip" {
    name                = "bastionPublicIP"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
  
}


# Create Azure Bastion
resource "azurerm_bastion_host" "bastion" {
    name                = "myBastion"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                 = "bastionIPConfig"
        subnet_id            = azurerm_subnet.bastionsubnet.id
        public_ip_address_id = azurerm_public_ip.bastion_pip.id
    }
}