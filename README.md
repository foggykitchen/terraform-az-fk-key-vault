# terraform-az-fk-key-vault

This repository contains a reusable Terraform / OpenTofu module and progressive examples for deploying Azure Key Vault as the secrets, keys, and certificate management layer in the FoggyKitchen catalog.

It is part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/) and is designed to compose cleanly with reusable Azure infrastructure modules such as `terraform-az-fk-vnet`, `terraform-az-fk-private-dns`, `terraform-az-fk-private-endpoint`, `terraform-az-fk-managed-identity`, `terraform-az-fk-rbac`, `terraform-az-fk-bastion`, and `terraform-az-fk-compute`.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Purpose

The goal of this module is to provide a clean, composable, and educational reference implementation for Azure Key Vault:

- Focused on Key Vault lifecycle and core security posture
- Azure RBAC authorization enabled by default
- Legacy inline access policy mode available when explicitly selected
- Optional network ACLs for restricted public endpoint access
- Suitable as a base layer for secrets, keys, certificates, private endpoint patterns, and workload identity integrations

This module intentionally stays focused on the Key Vault resource itself. Role assignments, private endpoints, Private DNS zones, managed identities, secrets, keys, and certificates should be composed through dedicated modules or workflow layers.

---

## What the module does

The module creates:

- Azure Key Vault
- Optional inline access policies when RBAC authorization is disabled
- Optional network ACLs
- Soft-delete retention configuration
- Optional purge protection
- Optional deployment, disk encryption, and template deployment flags

The module intentionally does not create:

- Resource groups
- VNets or subnets
- Private endpoints
- Private DNS zones
- RBAC role assignments
- Managed identities
- Key Vault secrets, keys, or certificates
- Diagnostic settings or Log Analytics Workspaces

Each of those concerns belongs in its own dedicated module or workflow layer.

---

## Provider Notes

The module contract follows the current AzureRM provider resource schema for `azurerm_key_vault`.

Key Vault supports two authorization models: Azure RBAC and access policies. This module defaults to Azure RBAC (`rbac_authorization_enabled = true`) and prevents mixing inline access policies with RBAC mode.

Azure Key Vault names are globally unique, must be 3-24 characters, and can contain only letters, numbers, and hyphens. The examples generate a lowercase random suffix to keep names unique during labs.

---

## Repository Structure

```bash
terraform-az-fk-key-vault/
├── examples/
│   ├── 01_basic_key_vault/
│   ├── 02_key_vault_with_network_acls/
│   ├── 03_private_key_vault_with_private_endpoint/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── SUPPORT.md
├── LICENSE
└── README.md
```

All examples demonstrate incremental Azure Key Vault patterns, starting from a basic RBAC-backed vault and progressing toward network ACLs and fully private access through Private Endpoint and Private DNS.

---

## Example Usage

### Basic RBAC-backed Key Vault

```hcl
module "key_vault" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-key-vault.git?ref=v0.1.0"

  key_vault_name      = "fkkvexample001"
  resource_group_name = "fk-key-vault-rg"
  location            = "westeurope"

  tags = {
    project = "foggykitchen"
    env     = "dev"
  }
}
```

### Legacy access policy mode

```hcl
module "key_vault" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-key-vault.git?ref=v0.1.0"

  key_vault_name            = "fkkvpolicy001"
  resource_group_name       = "fk-key-vault-rg"
  location                  = "westeurope"
  rbac_authorization_enabled = false

  access_policies = [{
    object_id          = "00000000-0000-0000-0000-000000000000"
    key_permissions    = ["Get", "List"]
    secret_permissions = ["Get", "List", "Set"]
  }]
}
```

### Key Vault with network ACLs

```hcl
module "key_vault" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-key-vault.git?ref=v0.1.0"

  key_vault_name      = "fkkvnet001"
  resource_group_name = "fk-key-vault-rg"
  location            = "westeurope"

  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["203.0.113.10/32"]
  }
}
```

### Private Key Vault with Private Endpoint

```hcl
module "private_dns" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-private-dns.git?ref=main"

  resource_group_name    = "fk-key-vault-rg"
  private_dns_zone_names = ["privatelink.vaultcore.azure.net"]

  vnet_links = {
    workloads = {
      vnet_id              = module.vnet.vnet_id
      registration_enabled = false
    }
  }
}

module "key_vault" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-key-vault.git?ref=v0.1.0"

  key_vault_name                = "fkkvprivate001"
  resource_group_name           = "fk-key-vault-rg"
  location                      = "westeurope"
  public_network_access_enabled = false
}

module "key_vault_private_endpoint" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-private-endpoint.git?ref=main"

  name                = "pe-fk-kv"
  location            = "westeurope"
  resource_group_name = "fk-key-vault-rg"
  subnet_id           = module.vnet.subnet_ids["private_endpoints"]

  private_connection_resource_id = module.key_vault.key_vault_id
  subresource_names              = ["vault"]

  private_dns_zone_group_name = "default"
  private_dns_zone_ids        = [module.private_dns.private_dns_zone_ids["privatelink.vaultcore.azure.net"]]
}
```

---

## Module Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `key_vault_name` | `string` | yes | Globally unique Key Vault name |
| `resource_group_name` | `string` | yes | Resource group name |
| `location` | `string` | yes | Azure region |
| `tenant_id` | `string` | no | Microsoft Entra tenant ID; defaults to the active AzureRM provider tenant |
| `sku_name` | `string` | no | Key Vault SKU, either `standard` or `premium` |
| `rbac_authorization_enabled` | `bool` | no | Whether the vault uses Azure RBAC for data-plane authorization |
| `access_policies` | `list(object)` | no | Inline access policies, only for access policy mode |
| `enabled_for_deployment` | `bool` | no | Whether Azure VMs can retrieve certificates stored as secrets |
| `enabled_for_disk_encryption` | `bool` | no | Whether Azure Disk Encryption can retrieve secrets and unwrap keys |
| `enabled_for_template_deployment` | `bool` | no | Whether ARM templates can retrieve secrets |
| `purge_protection_enabled` | `bool` | no | Whether purge protection is enabled |
| `public_network_access_enabled` | `bool` | no | Whether public network access is allowed |
| `soft_delete_retention_days` | `number` | no | Soft-delete retention in days, from 7 to 90 |
| `network_acls` | `object` | no | Optional network ACL block |
| `tags` | `map(string)` | no | Common tags |

### `access_policies` object schema

```hcl
access_policies = list(object({
  tenant_id               = optional(string)
  object_id               = string
  application_id           = optional(string)
  certificate_permissions  = optional(list(string), [])
  key_permissions          = optional(list(string), [])
  secret_permissions       = optional(list(string), [])
  storage_permissions      = optional(list(string), [])
}))
```

### `network_acls` object schema

```hcl
network_acls = object({
  bypass                     = string
  default_action             = string
  ip_rules                   = optional(list(string), [])
  virtual_network_subnet_ids = optional(list(string), [])
})
```

---

## Module Outputs

| Name | Description |
|------|-------------|
| key_vault_id | The ID of the Azure Key Vault. |
| key_vault_name | The name of the Azure Key Vault. |
| key_vault_uri | The URI of the Azure Key Vault. |
| key_vault_tenant_id | The tenant ID configured on the Azure Key Vault. |

---

## Examples

See [examples/README.md](examples/README.md) for the progressive lab sequence.

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
