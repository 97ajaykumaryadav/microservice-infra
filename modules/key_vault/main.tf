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
}

locals {
  # Combine deployer ID and admin IDs, then remove duplicates
  all_admin_ids = distinct(concat([data.azurerm_client_config.current.object_id], var.admin_object_ids))

  all_policies = flatten([
    for kv_key, kv in azurerm_key_vault.kv : [
      for obj_id in local.all_admin_ids : {
        kv_key = kv_key
        kv_id  = kv.id
        obj_id = obj_id
      }
    ]
  ])
}

resource "azurerm_key_vault_access_policy" "admin_access" {
  for_each = { for ap in local.all_policies : "${ap.kv_key}.${ap.obj_id}" => ap }

  key_vault_id = each.value.kv_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.obj_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover",
    "Restore"
  ]
}
