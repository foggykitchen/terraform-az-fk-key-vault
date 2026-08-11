module "key_vault" {
  source = "../.."

  key_vault_name                = "fkkvpriv${random_string.suffix.result}"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  public_network_access_enabled = false
  purge_protection_enabled      = var.purge_protection_enabled

  tags = {
    environment = "dev"
    example     = "03_private_key_vault_with_private_endpoint"
  }
}
