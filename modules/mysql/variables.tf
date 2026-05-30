variable "mysql_servers" {
  description = "Map of MySQL Flexible Servers to create"
  type = map(object({
    resource_group_name = string
    location            = string
    administrator_login = string
    key_vault_id        = string
    secret_name         = string
    sku_name            = optional(string, "GP_Standard_D2ds_v4")
    mysql_version       = optional(string, "8.0.21")
    storage_size_gb     = optional(number, 32)
    storage_iops        = optional(number, 360)
    backup_retention_days = optional(number, 7)
    geo_redundant_backup_enabled = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    tags                = optional(map(string), {})

    databases = optional(map(object({
      charset   = optional(string, "utf8mb3")
      collation = optional(string, "utf8mb3_general_ci")
    })), {})
  }))
}
