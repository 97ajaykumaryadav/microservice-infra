variable "kubernetes_clusters" {
  description = "Map of AKS clusters to create"
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version  = optional(string)
    sku_tier            = optional(string, "Free")
    tags                = optional(map(string), {})

    default_node_pool = object({
      name                         = string
      node_count                   = optional(number, 1)
      vm_size                      = optional(string, "Standard_DS2_v2")
      os_disk_size_gb              = optional(number, 30)
      vnet_subnet_id               = optional(string)
      enable_auto_scaling          = optional(bool, false)
      min_count                    = optional(number)
      max_count                    = optional(number)
      type                         = optional(string, "VirtualMachineScaleSets")
      only_critical_addons_enabled = optional(bool, false)
      max_pods                     = optional(number)
      node_labels                  = optional(map(string), {})
      tags                         = optional(map(string), {})
    })

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }), { type = "SystemAssigned" })

    network_profile = optional(object({
      network_plugin     = optional(string, "azure")
      network_policy     = optional(string)
      dns_service_ip     = optional(string)
      docker_bridge_cidr = optional(string)
      service_cidr       = optional(string)
      load_balancer_sku  = optional(string, "standard")
      outbound_type      = optional(string, "loadBalancer")
    }))

    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_cidr  = optional(string)
      subnet_id    = optional(string)
    }))

    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool, false)
      secret_rotation_interval = optional(string, "2m")
    }))

    oms_agent = optional(object({
      log_analytics_workspace_id = string
    }))

    azure_policy_enabled = optional(bool, false)

    extra_node_pools = optional(map(object({
      vm_size             = string
      node_count          = optional(number, 1)
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number)
      max_count           = optional(number)
      vnet_subnet_id      = optional(string)
      os_type             = optional(string, "Linux")
      max_pods            = optional(number)
      node_labels         = optional(map(string), {})
      tags                = optional(map(string), {})
    })), {})
  }))
}
