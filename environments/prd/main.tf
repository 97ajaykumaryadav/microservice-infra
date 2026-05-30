terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stmicroinfraeusstate" # Change this to your unique storage account name
    container_name       = "tfstate"
    key                  = "prd.terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

module "resource_groups" {
  source          = "../../modules/resource_group"
  resource_groups = var.resource_groups
}

module "acr" {
  source               = "../../modules/acr"
  container_registries = var.container_registries
  depends_on           = [module.resource_groups]
}

module "aks" {
  source              = "../../modules/aks"
  kubernetes_clusters = var.kubernetes_clusters
  depends_on          = [module.resource_groups]
}
