variable "resource_groups" {
  type = map(object({
    location = string
    tags     = optional(map(string), {})
  }))
}

variable "container_registries" {
  type = map(object({
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Standard")
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string), {})
    georeplications = optional(list(object({
      location                  = string
      regional_endpoint_enabled = optional(bool, true)
      zone_redundancy_enabled   = optional(bool, false)
      tags                      = optional(map(string), {})
    })), [])
    network_rule_set = optional(object({
      default_action = optional(string, "Allow")
      ip_rules = optional(list(object({
        action   = string
        ip_range = string
      })), [])
      virtual_network = optional(list(object({
        action    = string
        subnet_id = string
      })), [])
    }))
  }))
}

variable "key_vaults" {
  type = map(object({
    resource_group_name = string
    location            = string
    tags                = optional(map(string), {})
  }))
}

variable "mysql_servers" {
  type = map(object({
    resource_group_name = string
    location            = string
    administrator_login = string
    key_vault_id        = string
    secret_name         = string
    databases           = optional(map(object({
      charset   = optional(string, "utf8mb3")
      collation = optional(string, "utf8mb3_general_ci")
    })), {})
  }))
}

variable "kubernetes_clusters" {
  type = map(object({
    resource_group_name             = string
    location                        = string
    dns_prefix                      = string
    sku_tier                        = optional(string, "Free")
    api_server_authorized_ip_ranges = optional(list(string), [])
    local_account_disabled          = optional(bool, false)
    role_based_access_control_enabled = optional(bool, true)
    default_node_pool = object({
      name                = string
      node_count          = optional(number, 1)
      vm_size             = optional(string, "Standard_DS2_v2")
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number)
      max_count           = optional(number)
    })
    extra_node_pools = optional(map(object({
      vm_size    = string
      node_count = optional(number, 1)
    })), {})
  }))
}
