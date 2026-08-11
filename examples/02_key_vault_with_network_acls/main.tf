module "key_vault" {
  source = "../.."

  key_vault_name                = "fkkvnet${random_string.suffix.result}"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  public_network_access_enabled = true

  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.allowed_ip_rules
  }

  tags = {
    environment = "dev"
    example     = "02_key_vault_with_network_acls"
  }
}
