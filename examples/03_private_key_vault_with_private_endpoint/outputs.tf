output "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "The URI of the Azure Key Vault."
  value       = module.key_vault.key_vault_uri
}

output "vnet_id" {
  description = "The ID of the VNet linked to the Key Vault Private DNS zone."
  value       = module.vnet.vnet_id
}

output "private_dns_zone_id" {
  description = "The ID of the Key Vault Private DNS zone."
  value       = module.private_dns.private_dns_zone_ids[local.key_vault_private_dns_zone_name]
}

output "private_endpoint_id" {
  description = "The ID of the Key Vault Private Endpoint."
  value       = module.key_vault_private_endpoint.private_endpoint_id
}

output "private_endpoint_ip_addresses" {
  description = "Private IP addresses assigned to the Key Vault Private Endpoint."
  value       = module.key_vault_private_endpoint.private_ip_addresses
}
