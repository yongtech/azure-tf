resource "azurerm_resource_group" "my_rg3" {
  name = "dbrown-west2-tr1-rg"
  location = "westus2"
}

resource "azurerm_network_security_group" "my_nsg3" {
  name                = "dbrown-tr1mgmt-nsg"
  location            = azurerm_resource_group.my_rg3.location
  resource_group_name = azurerm_resource_group.my_rg3.name
  security_rule {
    name                       = "AllowInternet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["22","443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowMgmt"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.3.1.0/24"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowOnPrem"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_security_group" "my_nsg4" {
  name                = "dbrown-tr1pub-nsg"
  location            = azurerm_resource_group.my_rg3.location
  resource_group_name = azurerm_resource_group.my_rg3.name
}
resource "azurerm_network_security_group" "my_nsg5" {
  name                = "dbrown-tr1priv-nsg"
  location            = azurerm_resource_group.my_rg3.location
  resource_group_name = azurerm_resource_group.my_rg3.name
}

resource "azurerm_virtual_network" "my_tr1_vnet" {
  address_space           = ["10.3.0.0/21"]
  dns_servers             = ["8.8.8.8","8.8.4.4"]
  location                = azurerm_resource_group.my_rg3.location
  name                    = "dbrown-west2-tr1-vnet"
  resource_group_name     = azurerm_resource_group.my_rg3.name
  tags = local.common_tags
}

resource "azurerm_subnet" "my_mgmt_sub" {
  address_prefixes = ["10.3.1.0/24"]
  name           = "mgmt"
  resource_group_name = azurerm_resource_group.my_rg3.name
  virtual_network_name = azurerm_virtual_network.my_tr1_vnet.name
}

resource "azurerm_subnet" "my_pub_sub" {
  address_prefixes = ["10.3.2.0/24"]
  name           = "public"
  resource_group_name = azurerm_resource_group.my_rg3.name
  virtual_network_name = azurerm_virtual_network.my_tr1_vnet.name
}

resource "azurerm_subnet" "my_priv_sub" {
  address_prefixes = ["10.3.3.0/24"]
  name           = "private"
  resource_group_name = azurerm_resource_group.my_rg3.name
  virtual_network_name = azurerm_virtual_network.my_tr1_vnet.name
}

resource "azurerm_subnet_network_security_group_association" "my_nsg_as3" {
  subnet_id                 = azurerm_subnet.my_mgmt_sub.id
  network_security_group_id = azurerm_network_security_group.my_nsg3.id
}

resource "azurerm_subnet_network_security_group_association" "my_nsg_as4" {
  subnet_id                 = azurerm_subnet.my_pub_sub.id
  network_security_group_id = azurerm_network_security_group.my_nsg4.id
}

resource "azurerm_subnet_network_security_group_association" "my_nsg_as5" {
  subnet_id                 = azurerm_subnet.my_priv_sub.id
  network_security_group_id = azurerm_network_security_group.my_nsg5.id
}
