output "mysql_server_ids" {
  description = "Map of MySQL server names to IDs"
  value       = { for k, v in azurerm_mysql_flexible_server.mysql : k => v.id }
}

output "mysql_server_fqdns" {
  description = "Map of MySQL server names to FQDNs"
  value       = { for k, v in azurerm_mysql_flexible_server.mysql : k => v.fqdn }
}

output "mysql_database_ids" {
  description = "Map of database keys to IDs"
  value       = { for k, v in azurerm_mysql_flexible_database.db : k => v.id }
}
