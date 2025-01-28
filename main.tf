# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_password" "Pwd" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create Virtual Network and Subnet by using prefix from vnet variable and resource_group name from random_pet resource

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}-${random_pet.rg_name.id}"
  location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = var.vnet_address_space

  }

resource "azurerm_subnet" "subnet01" {
    name = "${var.aks_subnet01_name}-${var.resource_group_name_prefix}-${random_pet.rg_name.id}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.subnet01_address_prefix]

}


resource "azurerm_subnet" "subnet02" {
    name = "${var.aks_subnet02_name}-${var.resource_group_name_prefix}-${random_pet.rg_name.id}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.subnet02_address_prefix]

}