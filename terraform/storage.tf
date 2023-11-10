resource "random_id" "storage" {
    byte_length = 8
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
resource "azurerm_storage_account" "example" {
  name                     = lower("${var.prefix}${random_id.storage.id}")
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
