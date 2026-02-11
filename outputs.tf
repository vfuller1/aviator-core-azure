output "resource_group_name" {
  description = "The name of the deployed resource group"
  value       = azurerm_resource_group.aviator.name
}

output "aks_cluster_name" {
  description = "The name of the Aviator Core AKS cluster"
  value       = azurerm_kubernetes_cluster.aviator_core.name
}

output "aks_control_plane_fqdn" {
  description = "The FQDN of the AKS control plane for API access"
  value       = azurerm_kubernetes_cluster.aviator_core.fqdn
}

output "hub_vnet_id" {
  description = "The ID of the Hub VNet for future peering"
  value       = azurerm_virtual_network.hub.id
}