variable "container_registries" {
  description = "Map of container registries to create"
  type = map(object({
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Standard")
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    quarantine_policy_enabled     = optional(bool, false)
    zone_redundancy_enabled       = optional(bool, false)
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

    retention_policy = optional(object({
      days    = optional(number, 7)
      enabled = optional(bool, false)
    }))

    trust_policy = optional(object({
      enabled = optional(bool, false)
    }))
  }))
}
