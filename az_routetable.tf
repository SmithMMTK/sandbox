##############################################################
###                                                        ### 
### Required az_firewall.tf for the following code to work ###
###                                                        ###
##############################################################


resource "azurerm_route_table" "routeTable" {
  name                = "${random_pet.rg_name.id}-rt"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                = "routeToInternet"
    address_prefix      = "0.0.0.0/0"
    next_hop_type       = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address

}
}

resource "azurerm_subnet_route_table_association" "routeTableAssociation" {
  subnet_id      = azurerm_subnet.workload.id
  route_table_id = azurerm_route_table.routeTable.id

}