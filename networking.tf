# Resource Group
resource "azurerm_resource_group" "aviator" {
  name     = var.resource_group_name
  location = var.location
}

# Hub VNet (Networking & Edge Security)
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-aviator"
  location            = azurerm_resource_group.aviator.location
  resource_group_name = azurerm_resource_group.aviator.name
  address_space       = ["10.0.0.0/16"]
}

# Spoke VNet (Aviator Core Workloads)
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-aviator"
  location            = azurerm_resource_group.aviator.location
  resource_group_name = azurerm_resource_group.aviator.name
  address_space       = ["10.1.0.0/16"]
}

# VNet Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = azurerm_resource_group.aviator.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}