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
    key                  = "dev.terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# Resource Group Module
module "resource_groups" {
  source          = "../../modules/resource_group"
  resource_groups = var.resource_groups
}

# Key Vault Module
module "key_vault" {
  source     = "../../modules/key_vault"
  key_vaults = var.key_vaults
  tenant_id  = var.tenant_id
  depends_on = [module.resource_groups]
}

# MySQL Module
module "mysql" {
  source        = "../../modules/mysql"
  mysql_servers = var.mysql_servers
  depends_on    = [module.resource_groups, module.key_vault]
}

# ACR Module
module "acr" {
  source               = "../../modules/acr"
  container_registries = var.container_registries
  depends_on           = [module.resource_groups]
}

# AKS Module
module "aks" {
  source              = "../../modules/aks"
  kubernetes_clusters = var.kubernetes_clusters
  depends_on          = [module.resource_groups]
}
