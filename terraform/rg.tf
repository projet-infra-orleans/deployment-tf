resource "azurerm_resource_group" "groupe-1-infra-deploy" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
