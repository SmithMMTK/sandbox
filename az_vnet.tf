
variable "vnet_name" {
  type        = string
  default     = "vnet"
  description = "The name of the Virtual Network."
  
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  
}

variable "workload_subnet" {
  type        = string
  default     = "workload"
  description = "The name of the Subnet."
  
}

variable "workload_address_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The address prefix to use for the subnet."
}

variable "jumphost_subnet" {
  type        = string
  default     = "jumphost"
  description = "The name of the Subnet."
  
}

variable "jumphost_address_prefix" {
  type        = string
  default     = "10.0.2.0/24"
  description = "The address prefix to use for the subnet."
}


variable "firewall_subnet" {
  type        = string
  default     = "AzureFirewallSubnet"
  description = "The name of the Subnet."
  
}
variable "firewall_subnet_address_prefix" {
  type        = string
  default     = "10.0.100.0/24"
    description = "The address prefix to use for the subnet."
  
}

# Create Virtual Network and Subnet by using prefix from vnet variable and resource_group name from random_pet resource

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}-${random_pet.rg_name.id}"
  location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = var.vnet_address_space

  }

resource "azurerm_subnet" "workload" {
    name = "${var.workload_subnet}-${var.resource_group_name_prefix}-${random_pet.rg_name.id}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.workload_address_prefix]

}


resource "azurerm_subnet" "jumphost" {
    name = "${var.jumphost_subnet}-${var.resource_group_name_prefix}-${random_pet.rg_name.id}"
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

