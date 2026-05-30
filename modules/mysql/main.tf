data "azurerm_key_vault_secret" "mysql_password" {
  for_each     = var.mysql_servers
  name         = each.value.secret_name
  key_vault_id = each.value.key_vault_id
}

resource "azurerm_mysql_flexible_server" "mysql" {
  for_each = var.mysql_servers

  name                   = each.key
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  administrator_login    = each.value.administrator_login
  administrator_password = data.azurerm_key_vault_secret.mysql_password[each.key].value
  sku_name               = each.value.sku_name
  version                = each.value.mysql_version
  
  storage {
    size_gb = each.value.storage_size_gb
    iops    = each.value.storage_iops
  }

  backup_retention_days        = each.value.backup_retention_days
  geo_redundant_backup_enabled = each.value.geo_redundant_backup_enabled
  tags                         = each.value.tags
}

locals {
  mysql_databases = flatten([
    for server_key, server in var.mysql_servers : [
      for db_key, db in server.databases : {
        server_key = server_key
        db_key     = db_key
        config     = db
      }
    ]
  ])
}

resource "azurerm_mysql_flexible_database" "db" {
  for_each = { for db in local.mysql_databases : "${db.server_key}.${db.db_key}" => db }

  name                = each.value.db_key
  resource_group_name = var.mysql_servers[each.value.server_key].resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql[each.value.server_key].name
  charset             = each.value.config.charset
  collation           = each.value.config.collation
}
