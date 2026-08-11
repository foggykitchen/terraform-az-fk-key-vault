variable "location" {
  type        = string
  description = "Azure region where the example resources will be created."
  default     = "westeurope"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "CIDR blocks for the example VNet."
  default     = ["10.30.0.0/16"]
}

variable "private_endpoint_subnet_address_prefixes" {
  type        = list(string)
  description = "CIDR blocks for the subnet that hosts the Key Vault Private Endpoint."
  default     = ["10.30.1.0/24"]
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether purge protection is enabled for the private Key Vault."
  default     = false
}
