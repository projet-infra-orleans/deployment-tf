resource "azurerm_storage_account" "gr1infradeploystock" {
  name                     = lower("${var.stockage}")
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "RA-GRS"

  tags = {
    environment = "staging"
  }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
 
