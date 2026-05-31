data "azurerm_client_config" "current" {}

locals {
  # Combine client ID and admin IDs, then remove duplicates
  all_admin_ids = distinct(concat([data.azurerm_client_config.current.object_id], var.admin_object_ids))
}

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
  tags                        = each.value.tags

  # Using inline access_policy blocks to manage all policies together
  # This avoids "already exists" errors by managing the entire policy set
  dynamic "access_policy" {
    for_each = local.all_admin_ids
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value

      key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
      secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
      certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
    }
  }

  lifecycle {
    ignore_changes = [
      enable_rbac_authorization,
    ]
  }
}
