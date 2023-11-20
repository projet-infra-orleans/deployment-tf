resource "azurerm_key_vault_access_policy" "aks_access_to_kv" {
  depends_on       = [data.azurerm_kubernetes_cluster.aks]
  key_vault_id     = data.azurerm_key_vault.tf_kv.id
  tenant_id        = data.azurerm_client_config.current.tenant_id
  object_id        = data.azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id

  certificate_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}
