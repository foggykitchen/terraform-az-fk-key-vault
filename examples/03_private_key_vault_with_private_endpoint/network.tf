module "vnet" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-vnet.git?ref=main"

  name                = "vnet-fk-kv-private-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.vnet_address_space

  subnets = {
    private_endpoints = {
      address_prefixes                  = var.private_endpoint_subnet_address_prefixes
      private_endpoint_network_policies = "Disabled"
      service_endpoints                 = []
      delegations                       = []
    }
  }

  tags = {
    environment = "dev"
    example     = "03_private_key_vault_with_private_endpoint"
  }
}
