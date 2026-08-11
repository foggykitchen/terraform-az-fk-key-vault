module "key_vault_private_endpoint" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-private-endpoint.git?ref=main"

  name                = "pe-fk-kv-${random_string.suffix.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.vnet.subnet_ids["private_endpoints"]

  private_connection_resource_id = module.key_vault.key_vault_id
  subresource_names              = ["vault"]

  private_dns_zone_group_name = "default"
  private_dns_zone_ids        = [module.private_dns.private_dns_zone_ids[local.key_vault_private_dns_zone_name]]

  tags = {
    environment = "dev"
    example     = "03_private_key_vault_with_private_endpoint"
  }
}
