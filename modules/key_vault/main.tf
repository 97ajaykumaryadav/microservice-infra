data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                        = each.key
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  enabled_for_deployment      = each.value.enabled_for_deployment
  enabled_for_disk_encryption = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = each.value.sku_name
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  purge_protection_enabled     = each.value.purge_protection_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  enable_rbac_authorization   = true # Enable modern RBAC model
  tags                        = each.value.tags
}

# No longer need azurerm_key_vault_access_policy when using enable_rbac_authorization = true
