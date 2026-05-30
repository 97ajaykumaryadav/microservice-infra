resource_groups = {
  "rg-micro-dev-eus" = {
    location = "East US"
    tags = {
      environment = "dev"
      project     = "microservices"
    }
  }
}

container_registries = {
  "acrmicrodev001" = {
    resource_group_name = "rg-micro-dev-eus"
    location            = "East US"
    sku                 = "Standard"
    admin_enabled       = true
  }
}

kubernetes_clusters = {
  "aks-dev-001" = {
    resource_group_name = "rg-micro-dev-eus"
    location            = "East US"
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
