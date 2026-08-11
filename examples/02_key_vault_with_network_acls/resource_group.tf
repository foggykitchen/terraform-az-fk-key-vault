resource "azurerm_resource_group" "this" {
  name     = "rg-fk-kv-net-${random_string.suffix.result}"
  location = var.location
}
