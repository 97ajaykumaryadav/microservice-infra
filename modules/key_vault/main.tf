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
  tags                        = each.value.tags

  lifecycle {
    ignore_changes = [
      enable_rbac_authorization,
    ]
  }
}

resource "azurerm_key_vault_access_policy" "client" {
  for_each = var.key_vaults

  key_vault_id = azurerm_key_vault.kv[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
}

resource "azurerm_key_vault_access_policy" "admins" {
  for_each = {
    for pair in setproduct(keys(var.key_vaults), var.admin_object_ids) : "${pair[0]}-${pair[1]}" => {
      kv_key    = pair[0]
      object_id = pair[1]
    }
  }

  key_vault_id = azurerm_key_vault.kv[each.value.kv_key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Purge"]
}
