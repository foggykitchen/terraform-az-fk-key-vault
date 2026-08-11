variable "key_vault_name" {
  type        = string
  description = "The globally unique name of the Azure Key Vault."

  validation {
    condition = (
      length(var.key_vault_name) >= 3 &&
      length(var.key_vault_name) <= 24 &&
      can(regex("^[A-Za-z][A-Za-z0-9-]*[A-Za-z0-9]$", var.key_vault_name)) &&
      length(regexall("--", var.key_vault_name)) == 0
    )
    error_message = "The Key Vault name must be 3-24 characters, start with a letter, end with a letter or number, contain only letters, numbers, and hyphens, and not contain consecutive hyphens."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the Key Vault will be created."
}

variable "location" {
  type        = string
  description = "Azure region where the Key Vault will be created."
}

variable "tenant_id" {
  type        = string
  description = "The Microsoft Entra tenant ID used by the Key Vault. Defaults to the tenant of the active AzureRM provider credentials."
  default     = null
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the Key Vault."
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either standard or premium."
  }
}

variable "rbac_authorization_enabled" {
  type        = bool
  description = "Whether the Key Vault uses Azure RBAC for data-plane authorization."
  default     = true
}

variable "access_policies" {
  type = list(object({
    tenant_id               = optional(string)
    object_id               = string
    application_id          = optional(string)
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  description = "Inline Key Vault access policies. Use only when rbac_authorization_enabled is false."
  default     = []
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault."
  default     = false
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether purge protection is enabled for this Key Vault. Azure does not allow disabling purge protection after it has been enabled."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for this Key Vault."
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained after soft deletion."
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  description = "Optional network ACL configuration for the Key Vault."
  default     = null

  validation {
    condition = var.network_acls == null ? true : (
      contains(["AzureServices", "None"], var.network_acls.bypass) &&
      contains(["Allow", "Deny"], var.network_acls.default_action)
    )
    error_message = "network_acls.bypass must be AzureServices or None, and network_acls.default_action must be Allow or Deny."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Key Vault."
  default     = {}
}
