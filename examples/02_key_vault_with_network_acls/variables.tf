variable "location" {
  type        = string
  description = "Azure region where the example resources will be created."
  default     = "westeurope"
}

variable "allowed_ip_rules" {
  type        = list(string)
  description = "Public IPv4 addresses or CIDR blocks allowed to reach the Key Vault."
  default     = []
}
