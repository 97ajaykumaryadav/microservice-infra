output "aks_ids" {
  description = "Map of AKS names to IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.id }
}

output "aks_names" {
  description = "Map of AKS names to names (useful for consistency)"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.name }
}

output "aks_kube_configs" {
  description = "Map of AKS names to kube_configs"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.kube_config_raw }
  sensitive   = true
}

output "aks_identities" {
  description = "Map of AKS names to identity blocks"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.identity }
}

output "node_pool_ids" {
  description = "Map of extra node pool keys to IDs"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.extra : k => v.id }
}
