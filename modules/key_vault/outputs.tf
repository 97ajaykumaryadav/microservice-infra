output "key_vault_ids" {
  description = "Map of Key Vault names to IDs"
  value       = { for k, v in azurerm_key_vault.kv : k => v.id }
}

output "key_vault_uris" {
  description = "Map of Key Vault names to URIs"
  value       = { for k, v in azurerm_key_vault.kv : k => v.vault_uri }
}
