terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Resource Group Module
module "resource_groups" {
  source = "../../modules/resource_group"

  resource_groups = {
    "rg-microservices-prod" = {
      location = "East US"
      tags = {
        environment = "prod"
        owner       = "devops"
      }
    }
  }
}

# 2. ACR Module
module "acr" {
  source = "../../modules/acr"

  container_registries = {
    "acrmicroprod001" = {
      resource_group_name = module.resource_groups.resource_group_names[0]
      location            = "East US"
      sku                 = "Premium"
      admin_enabled       = true
      georeplications = [
        { location = "West US" }
      ]
      network_rule_set = {
        default_action = "Deny"
        ip_rules = [
          { action = "Allow", ip_range = "1.2.3.4/32" }
        ]
      }
    }
  }

  depends_on = [module.resource_groups]
}

# 3. AKS Module
module "aks" {
  source = "../../modules/aks"

  kubernetes_clusters = {
    "aks-prod-001" = {
      resource_group_name = module.resource_groups.resource_group_names[0]
      location            = "East US"
      dns_prefix          = "aksprod"
      sku_tier            = "Paid"

      default_node_pool = {
        name                = "systempool"
        node_count          = 3
        vm_size             = "Standard_DS2_v2"
        enable_auto_scaling = true
        min_count           = 3
        max_count           = 5
      }

      network_profile = {
        network_plugin = "azure"
        network_policy = "calico"
      }

      extra_node_pools = {
        "userpool1" = {
          vm_size    = "Standard_DS3_v2"
          node_count = 2
          node_labels = {
            role = "worker"
          }
        }
      }
    }
  }

  depends_on = [module.resource_groups]
}

output "resource_group_ids" {
  value = module.resource_groups.resource_group_ids
}

output "acr_login_servers" {
  value = module.acr.acr_login_servers
}

output "aks_kube_configs" {
  value     = module.aks.aks_kube_configs
  sensitive = true
}
