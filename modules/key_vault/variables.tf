variable "key_vaults" {
  description = "Map of key vaults to create"
  type = map(object({
    resource_group_name             = string
    location                        = string
    sku_name                        = optional(string, "standard")
    enabled_for_deployment          = optional(bool, false)
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    soft_delete_retention_days      = optional(number, 7)
    purge_protection_enabled        = optional(bool, false)
    public_network_access_enabled   = optional(bool, true)
    tags                            = optional(map(string), {})
  }))
}

variable "tenant_id" {
  description = "The Azure Tenant ID"
  type        = string
}
