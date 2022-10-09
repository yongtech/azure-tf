resource "azurerm_resource_group" "my_rg1" {
  name = "dbrown-west2-app1-rg"
  location = "westus2"
}

resource "azurerm_resource_group" "my_rg2" {
  name = "dbrown-west2-app2-rg"
  location = "westus2"
}

resource "azurerm_network_security_group" "my_nsg1" {
  name                = "dbrown-app1-nsg"
  location            = azurerm_resource_group.my_rg1.location
  resource_group_name = azurerm_resource_group.my_rg1.name
}

resource "azurerm_network_security_group" "my_nsg2" {
  name                = "dbrown-app2-nsg"
  location            = azurerm_resource_group.my_rg2.location
  resource_group_name = azurerm_resource_group.my_rg2.name
}

resource "azurerm_virtual_network" "my_app1_vnet" {
  address_space           = ["10.1.0.0/21"]
  dns_servers             = ["8.8.8.8","8.8.4.4"]
  location                = azurerm_resource_group.my_rg1.location
  name                    = "dbrown-west2-app1-vnet"
  resource_group_name     = azurerm_resource_group.my_rg1.name
  tags = local.common_tags
}
resource "azurerm_subnet" "my_app1_sub" {
  address_prefixes = ["10.1.1.0/24"]
  name           = "app1"
  resource_group_name = azurerm_resource_group.my_rg1.name
  virtual_network_name = azurerm_virtual_network.my_app1_vnet.name
}

resource "azurerm_virtual_network" "my_app2_vnet" {
  address_space           = ["10.2.0.0/21"]
  dns_servers             = ["8.8.8.8","8.8.4.4"]
  location                = azurerm_resource_group.my_rg2.location
  name                    = "dbrown-west2-app2-vnet"
  resource_group_name     = azurerm_resource_group.my_rg2.name
  tags = local.common_tags
}

resource "azurerm_subnet" "my_app2_sub" {
  address_prefixes = ["10.2.1.0/24"]
  name           = "app2"
  resource_group_name = azurerm_resource_group.my_rg2.name
  virtual_network_name = azurerm_virtual_network.my_app2_vnet.name
}

resource "azurerm_subnet_network_security_group_association" "my_nsg_as1" {
  subnet_id                 = azurerm_subnet.my_app1_sub.id
  network_security_group_id = azurerm_network_security_group.my_nsg1.id
}

resource "azurerm_subnet_network_security_group_association" "my_nsg_as2" {
  subnet_id                 = azurerm_subnet.my_app2_sub.id
  network_security_group_id = azurerm_network_security_group.my_nsg2.id
}