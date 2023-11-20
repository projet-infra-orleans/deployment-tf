resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.cluster_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  #dns_prefix          = "${var.dns_prefix}"

  default_node_pool = {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
}
