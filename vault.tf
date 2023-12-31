data "azurerm_client_config" "current" {}

# Utilisation d'un coffre de clés existant
data "azurerm_key_vault" "tf_kv" {
  depends_on          = [azurerm_kubernetes_cluster.aks]
  name                = "${var.vault_key_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_key_vault_access_policy" "aks_access_to_kv" {
  depends_on       = [azurerm_kubernetes_cluster.aks]
  key_vault_id     = data.azurerm_key_vault.tf_kv.id
  tenant_id        = data.azurerm_client_config.current.tenant_id
  object_id        = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id

  certificate_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

resource "helm_release" "akv2k8" {
  depends_on       = [helm_release.nginx_ingress]
  name             = "ingress-akv2k8"
  repository       = "https://charts.spvapi.no"
  chart            = "akv2k8s"
  namespace        = "akv2k8s"
  create_namespace = true
}

resource "kubectl_manifest" "create_namespace" {
  depends_on = [helm_release.akv2k8] 
  yaml_body  = "${file("${path.module}/vault/namespace.yaml")}"
}

resource "kubectl_manifest" "secret_url_mongo" {
  depends_on = [helm_release.akv2k8] 
  yaml_body  = "${templatefile("${path.module}/vault/secret-url-mongo-db.yaml", {
		dns = var.environment,
    vault_name = var.vault_key_name
	})}"
}