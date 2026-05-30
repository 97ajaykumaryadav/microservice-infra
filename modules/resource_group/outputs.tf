output "resource_group_names" {
  description = "List of resource group names"
  value       = [for rg in azurerm_resource_group.rg : rg.name]
}

output "resource_group_ids" {
  description = "Map of resource group names to IDs"
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}

output "resource_groups" {
  description = "Full resource group objects"
  value       = azurerm_resource_group.rg
}
