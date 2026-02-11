terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # This block keeps your local environment in sync with Azure and GitHub
  backend "azurerm" {
    resource_group_name  = "rg-aviator-terraform-state"
    storage_account_name = "staviatorstate1770773419"
    container_name       = "tfstate"
    key                  = "aviator-core.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    # New flag: Allows Terraform to delete the old Resource Group even if it contains DNS zones or other resources
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}