##############################################################
###                                                        ### 
### Required az_linux_vm.tf for the following code to work ###
###                                                        ###
##############################################################


resource "random_password" "sqlPwd" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create public IP address
resource "azurerm_public_ip" "my_sql_public_ip" {
  name                = "myPublicIP_SQL"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "my_sql_nic" {
  name                = "myNIC_SQL"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_sql_configuration"
    subnet_id                     = azurerm_subnet.workload.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_sql_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sqlSecurityGroup" {
  network_interface_id      = azurerm_network_interface.my_sql_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "sql_vm_random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "sql_storage_account" {
  name                     = "diag${random_id.sql_vm_random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "my_sql_vm" {
  name                  = "sqlVM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_sql_nic.id]
  size                  = "Standard_D8ads_v5"

  os_disk {
    name                 = "sqlOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2019-WS2019"
    sku       = "SQLDEV"
    version   = "latest"
  }

  admin_username = "azureuser"
  admin_password = random_password.sqlPwd.result
}

# Output the admin username and password
output "admin_username" {
  value = azurerm_windows_virtual_machine.my_sql_vm.admin_username
}

output "admin_password" {
  value = azurerm_windows_virtual_machine.my_sql_vm.admin_password
  sensitive = true
}

output "SQLVM_PUBLIC_IP" {
  value = azurerm_public_ip.my_sql_public_ip.ip_address
  
}