# AKS Cluster (Compute & Platform)
resource "azurerm_kubernetes_cluster" "aviator_core" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.aviator.location
  resource_group_name = azurerm_resource_group.aviator.name
  dns_prefix          = "aviatorcore"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  # Managed Identity for secret-less authentication
  identity {
    type = "SystemAssigned" 
  }

  tags = {
    Environment = "Production"
    Project     = "Aviator Core"
  }
}