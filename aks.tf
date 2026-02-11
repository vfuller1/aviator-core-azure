# aks.tf
resource "azurerm_kubernetes_cluster" "aviator_core" {
  name                = "aks-aviator-core"
  location            = azurerm_resource_group.aviator.location
  resource_group_name = azurerm_resource_group.aviator.name
  dns_prefix          = "aviatorcore"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2as_v6" # Updated to supported East US 2 SKU
    os_disk_type = "Managed"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
    Project     = "Aviator Core"
  }
}