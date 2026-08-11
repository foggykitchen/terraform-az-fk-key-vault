module "key_vault" {
  source = "../.."

  key_vault_name      = "fkkv${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  tags = {
    environment = "dev"
    example     = "01_basic_key_vault"
  }
}
