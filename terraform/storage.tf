resource "azurerm_storage_account" "gr1infradeploystock" {
  name                     = lower("${var.stockage_name}")
  resource_group_name      = azurerm_resource_group.groupe-1-infra-deploy.name
  location                 = azurerm_resource_group.groupe-1-infra-deploy.location
  account_tier             = "Standard"
  account_replication_type = "RA-GRS"

  tags = {
    environment = "staging"
  }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
 
