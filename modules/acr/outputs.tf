output "acr_ids" {
  description = "Map of ACR names to IDs"
  value       = { for k, v in azurerm_container_registry.acr : k => v.id }
}

output "acr_login_servers" {
  description = "Map of ACR names to login servers"
  value       = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}

output "acr_admin_usernames" {
  description = "Map of ACR names to admin usernames"
  value       = { for k, v in azurerm_container_registry.acr : k => v.admin_username }
}

output "acr_admin_passwords" {
  description = "Map of ACR names to admin passwords"
  value       = { for k, v in azurerm_container_registry.acr : k => v.admin_password }
  sensitive   = true
}
