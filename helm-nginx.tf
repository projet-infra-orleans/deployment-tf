resource "helm_release" "ingress" {
  # depends_on       = [azurerm_key_vault_access_policy.aks_access_to_kv]
  name             = "${local.prefix}-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"
  namespace        = "ingress-ns"
  create_namespace = true
}

resource "helm_release" "akv2k8" {
  depends_on       = [helm_release.ingress]
  name             = "${local.prefix}-akv2k8"
  repository       = "https://charts.spvapi.no"
  chart            = "akv2k8s"
  namespace        = "akv2k8s"
  create_namespace = true
}
