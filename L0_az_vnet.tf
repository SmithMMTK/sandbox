
variable "vnet_name" {
  type        = string
  default     = "vnet"
  description = "The name of the Virtual Network."
  
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  
}


variable "workload_address_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The address prefix to use for the subnet."
}



variable "jumphost_address_prefix" {
  type        = string
  default     = "10.0.2.0/24"
  description = "The address prefix to use for the subnet."
}




variable "firewall_subnet_address_prefix" {
  type        = string
  default     = "10.0.100.0/24"
    description = "The address prefix to use for the subnet."
  
}



variable "aks_address_prefix" {
  type        = string
  default     = "10.0.10.0/24"
  description = "The address prefix to use for the subnet."
  
}



variable "privateendpoint_address_prefix" {
  type        = string
  default     = "10.0.3.0/24"
  description = "The address prefix to use for the subnet."
  
}

variable "bastion_address_prefix" {
  type        = string
  default     = "10.0.4.0/24"
  
}

# Create Virtual Network and Subnet by using prefix from vnet variable and resource_group name from random_pet resource

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}-${random_pet.rg_name.id}"
  location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = var.vnet_address_space

  }

resource "azurerm_subnet" "workload" {
    name = "workload_subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.workload_address_prefix]

}


resource "azurerm_subnet" "jumphost" {
    name = "jumphost_subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.jumphost_address_prefix]

}

resource "azurerm_subnet" "AzureFirewallSubnet" {
    name = "AzureFirewallSubnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.firewall_subnet_address_prefix]
}

resource "azurerm_subnet" "AKSSubnet" {
    name = "aks_subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.aks_address_prefix]
}

resource "azurerm_subnet" "privateendpoint" {
    name = "private_endpoint_subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.privateendpoint_address_prefix]
}

resource "azurerm_subnet" "bastionsubnet" {
    name = "AzureBastionSubnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.bastion_address_prefix]
  
}