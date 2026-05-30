resource_groups = {
  "rg-micro-prd-cin" = {
    location = "Central India"
    tags = {
      environment = "prd"
      project     = "microservices"
    }
  }
}

container_registries = {
  "acrmicroprd001" = {
    resource_group_name = "rg-micro-prd-cin"
    location            = "Central India"
    sku                 = "Premium"
    admin_enabled       = false
    georeplications = [
      { location = "South India" }
    ]
    network_rule_set = {
      default_action = "Deny"
      ip_rules = [
        { action = "Allow", ip_range = "10.0.0.0/8" }
      ]
    }
  }
}

key_vaults = {
  "kv-micro-prd-cin" = {
    resource_group_name = "rg-micro-prd-cin"
    location            = "Central India"
  }
}

mysql_servers = {
  "mysql-micro-prd-cin" = {
    resource_group_name = "rg-micro-prd-cin"
    location            = "Central India"
    administrator_login = "mysqladmin"
    key_vault_id        = "/subscriptions/e184cbb2-94b7-4837-9a26-366e3fafcd17/resourceGroups/rg-micro-prd-cin/providers/Microsoft.KeyVault/vaults/kv-micro-prd-cin"
    secret_name         = "mysql-admin-password"
    databases = {
      "prod_db" = {}
    }
  }
}

kubernetes_clusters = {
  "aks-prd-001" = {
    resource_group_name = "rg-micro-prd-cin"
    location            = "Central India"
    dns_prefix          = "aksprod"
    sku_tier            = "Paid"

    default_node_pool = {
      name                = "systempool"
      node_count          = 3
      vm_size             = "Standard_DS3_v2"
      enable_auto_scaling = true
      min_count           = 3
      max_count           = 10
    }

    extra_node_pools = {
      "workerpool" = {
        vm_size    = "Standard_DS4_v2"
        node_count = 5
      }
    }
  }
}
