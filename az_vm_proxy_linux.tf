##############################################################
###                                                        ### 
### Required az_linux_vm.tf for the following code to work ###
###                                                        ###
##############################################################


# Create public IPs
resource "azurerm_public_ip" "my_proxy_public_ip" {
  name                = "myPublicIP_Proxy"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}



# Create network interface
resource "azurerm_network_interface" "my_proxy_nic" {
  name                = "myNIC_Proxy"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_proxy_configuration"
    subnet_id                     = azurerm_subnet.proxysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_proxy_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "proxySecurityGroup" {
  network_interface_id      = azurerm_network_interface.my_proxy_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}


# Generate random text for a unique storage account name
resource "random_id" "random_id3" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "proxy_storage_account" {
  name                     = "diag${random_id.random_id3.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_proxy_vm" {
  name                  = "proxy"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_proxy_nic.id]
  size                  = "Standard_D8ads_v5"

  os_disk {
    name                 = "proxyOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "proxy"
  admin_username = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.proxy_storage_account.primary_blob_endpoint
    
  }
}

  resource "azurerm_virtual_machine_extension" "proxy_custom_script" {
    name                = "proxy_custom_script"
    virtual_machine_id  = azurerm_linux_virtual_machine.my_proxy_vm.id
    publisher           = "Microsoft.Azure.Extensions"
    type                = "CustomScript"
    type_handler_version = "2.1"

    settings = jsonencode({
      "fileUris": ["https://raw.githubusercontent.com/SmithMMTK/terraform/refs/heads/main/scripts/proxy_scripts.sh"],
      "commandToExecute": "sh proxy_scripts.sh"
    })
 
}

# Output the IP address of the VM
output "PUBLIC_IP_ADDRESS_PROXY" {
  //value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
    value = azurerm_linux_virtual_machine.my_proxy_vm.public_ip_address
}

output "PROXY_VM_VNET_IP" {
  value = azurerm_network_interface.my_proxy_nic.private_ip_address
}