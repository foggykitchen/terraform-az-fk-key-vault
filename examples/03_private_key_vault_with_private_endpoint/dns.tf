locals {
  key_vault_private_dns_zone_name = "privatelink.vaultcore.azure.net"
}

module "private_dns" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-private-dns.git?ref=main"

  resource_group_name    = azurerm_resource_group.this.name
  private_dns_zone_names = [local.key_vault_private_dns_zone_name]

  vnet_links = {
    key_vault = {
      vnet_id              = module.vnet.vnet_id
      registration_enabled = false
    }
  }

  tags = {
    environment = "dev"
    example     = "03_private_key_vault_with_private_endpoint"
  }
}
