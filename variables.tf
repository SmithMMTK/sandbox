variable "resource_group_location" {
  type        = string
  default     = "southeastasia"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "vnet_name" {
  type        = string
  default     = "vnet"
  description = "The name of the Virtual Network."
  
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  
}

variable "aks_subnet01_name" {
  type        = string
  default     = "subnet-01"
  description = "The name of the Subnet."
  
}

variable "subnet01_address_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The address prefix to use for the subnet."
}

variable "aks_subnet02_name" {
  type        = string
  default     = "subnet-02"
  description = "The name of the Subnet."
  
}

variable "subnet02_address_prefix" {
  type        = string
  default     = "10.0.2.0/24"
  description = "The address prefix to use for the subnet."
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analytics workspace to create for the AKS cluster."
  default     = "loganalytics"
}

