resource_groups = {
  "rg-micro-dev-cin" = {
    location = "Central India"
    tags = {
      environment = "dev"
      project     = "microservices"
    }
  }
}

container_registries = {
  "acrmicrodev001" = {
    resource_group_name = "rg-micro-dev-cin"
    location            = "Central India"
    sku                 = "Standard"
    admin_enabled       = true
  }
}

key_vaults = {
  "kv-micro-dev-cin" = {
    resource_group_name = "rg-micro-dev-cin"
    location            = "Central India"
  }
}

# Add your Object ID here to manage secrets via Portal
admin_object_ids = ["2e2b2910-5e74-4c98-9bba-ddf4e64d7209"] 

mysql_servers = {
  "mysql-micro-dev-wus2" = { # Moved to West US 2 as East US also has capacity/access limits for this sub
    resource_group_name = "rg-micro-dev-cin"
    location            = "West US 2" 
    sku_name            = "B_Standard_B1ms"
    administrator_login = "mysqladmin"
    key_vault_id        = "/subscriptions/e184cbb2-94b7-4837-9a26-366e3fafcd17/resourceGroups/rg-micro-dev-cin/providers/Microsoft.KeyVault/vaults/kv-micro-dev-cin"
    secret_name         = "mysql-admin-password"
    databases = {
      "app_db" = {}
    }
  }
}

kubernetes_clusters = {
  "aks-dev-001" = {
    resource_group_name = "rg-micro-dev-cin"
    location            = "Central India"
    dns_prefix          = "aksdev"
    sku_tier            = "Free"

    default_node_pool = {
      name                = "devpool"
      node_count          = 1
      vm_size             = "Standard_DC2as_v5"
      enable_auto_scaling = false
    }
  }
}
