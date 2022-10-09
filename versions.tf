terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.26.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

# dbrown-west2-rg / dbrown-west2-rg-vnet
/* 
cidr 10.1.1.0/20
app1 - subnet 10.1.1.0/24
app2 - subnet 10.1.2.0/24

  

*/
# terraform import azurerm_resource_group.my_r /subscriptions/fed18709-1c27-4721-96da-03c439526b6a/resourceGroups/dbrown-west2-rg

# resource "azurerm_virtual_network" "mine" {}

# terraform import azurerm_virtual_network.mine /subscriptions/fed18709-1c27-4721-96da-03c439526b6a/resourceGroups/dbrown-west2-rg/providers/Microsoft.Network/virtualNetworks/dbrown-west2-rg-vnet


