resource_groups = {
  "rg-micro-prd-eus" = {
    location = "East US"
    tags = {
      environment = "prd"
      project     = "microservices"
    }
  }
}

container_registries = {
  "acrmicroprd001" = {
    resource_group_name = "rg-micro-prd-eus"
    location            = "East US"
    sku                 = "Premium"
    admin_enabled       = false
    georeplications = [
      { location = "West US" }
    ]
    network_rule_set = {
      default_action = "Deny"
      ip_rules = [
        { action = "Allow", ip_range = "10.0.0.0/8" }
      ]
    }
  }
}

kubernetes_clusters = {
  "aks-prd-001" = {
    resource_group_name = "rg-micro-prd-eus"
    location            = "East US"
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
