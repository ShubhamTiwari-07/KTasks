data "azurerm_client_config" "current" {}

resource "random_password" "secret" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
resource "azurerm_resource_group" krg {
	name = var.Rg_Name
	location = var.Rg_Location
}



resource "azurerm_key_vault" "kcKV" {
  name                        = "KDevKV"
  location                    = azurerm_resource_group.krg.location
  resource_group_name         = azurerm_resource_group.krg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "Get"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "pwd" {
  name         = "password"
  value        = random_password.secret.result
  key_vault_id = azurerm_key_vault.kcKV.id
}