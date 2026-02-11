variable "resource_group_name" {
  description = "The name of the resource group for Aviator Core"
  type        = string
  default     = "rg-aviator-core-prod"
}

variable "location" {
  description = "The Azure region to deploy the Aviator Core foundation"
  type        = string
  default     = "East US"
}

variable "aks_cluster_name" {
  description = "The name of the Aviator Core AKS cluster"
  type        = string
  default     = "aks-aviator-core"
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
  default     = "vnet-hub-aviator"
}

variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network for workloads"
  type        = string
  default     = "vnet-spoke-aviator"
}