locals {
  extra_node_pools = flatten([
    for cluster_key, cluster in var.kubernetes_clusters : [
      for pool_key, pool in cluster.extra_node_pools : {
        cluster_key = cluster_key
        pool_key    = pool_key
        config      = pool
      }
    ]
  ])
}

# tfsec:ignore:azure-container-limit-authorized-ips
# tfsec:ignore:azure-container-logging
resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.kubernetes_clusters

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  dns_prefix          = each.value.dns_prefix
  kubernetes_version              = each.value.kubernetes_version
  sku_tier                        = each.value.sku_tier
  api_server_authorized_ip_ranges = each.value.api_server_authorized_ip_ranges
  local_account_disabled          = each.value.local_account_disabled
  tags                            = each.value.tags

  default_node_pool {
    name                         = each.value.default_node_pool.name
    node_count                   = each.value.default_node_pool.node_count
    vm_size                      = each.value.default_node_pool.vm_size
    os_disk_size_gb              = each.value.default_node_pool.os_disk_size_gb
    vnet_subnet_id               = each.value.default_node_pool.vnet_subnet_id
    enable_auto_scaling          = each.value.default_node_pool.enable_auto_scaling
    min_count                    = each.value.default_node_pool.min_count
    max_count                    = each.value.default_node_pool.max_count
    type                         = each.value.default_node_pool.type
    only_critical_addons_enabled = each.value.default_node_pool.only_critical_addons_enabled
    max_pods                     = each.value.default_node_pool.max_pods
    node_labels                  = each.value.default_node_pool.node_labels
    tags                         = each.value.default_node_pool.tags
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin     = network_profile.value.network_plugin
      network_policy     = network_profile.value.network_policy
      dns_service_ip     = network_profile.value.dns_service_ip
      docker_bridge_cidr = network_profile.value.docker_bridge_cidr
      service_cidr       = network_profile.value.service_cidr
      load_balancer_sku  = network_profile.value.load_balancer_sku
      outbound_type      = network_profile.value.outbound_type
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = each.value.ingress_application_gateway != null ? [each.value.ingress_application_gateway] : []
    content {
      gateway_id   = ingress_application_gateway.value.gateway_id
      gateway_name = ingress_application_gateway.value.gateway_name
      subnet_cidr  = ingress_application_gateway.value.subnet_cidr
      subnet_id    = ingress_application_gateway.value.subnet_id
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = each.value.key_vault_secrets_provider != null ? [each.value.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  dynamic "oms_agent" {
    for_each = each.value.oms_agent != null ? [each.value.oms_agent] : []
    content {
      log_analytics_workspace_id = oms_agent.value.log_analytics_workspace_id
    }
  }

  azure_policy_enabled = each.value.azure_policy_enabled
}

resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  for_each = { for np in local.extra_node_pools : "${np.cluster_key}.${np.pool_key}" => np }

  name                  = each.value.pool_key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks[each.value.cluster_key].id
  vm_size               = each.value.config.vm_size
  node_count            = each.value.config.node_count
  enable_auto_scaling   = each.value.config.enable_auto_scaling
  min_count             = each.value.config.min_count
  max_count             = each.value.config.max_count
  vnet_subnet_id        = each.value.config.vnet_subnet_id
  os_type               = each.value.config.os_type
  max_pods              = each.value.config.max_pods
  node_labels           = each.value.config.node_labels
  tags                  = each.value.config.tags
}
