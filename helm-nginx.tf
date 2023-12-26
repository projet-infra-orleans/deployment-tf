resource "helm_release" "nginx_ingress" {
  depends_on = [kubectl_manifest.namespace_labels]

  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.1"
  namespace = "ingress-basic"

  values = [
    "${file("${path.module}/nginx/values.yaml")}"
  ]
}

/**
* Désactivation du namespace
*/
resource "kubectl_manifest" "namespace_labels" {
  yaml_body = file("${path.module}/nginx/certbot/namespace.yaml")
}

/*
* TLS
*/
resource "helm_release" "cert_manager" {
  depends_on = [kubectl_manifest.namespace_labels, helm_release.nginx_ingress]

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.8.0"
  namespace = "ingress-basic"

  values = [
    "${file("${path.module}/nginx/certbot/values.yaml")}"
  ]
}

/**
* Issuer du TLS
*/
resource "kubectl_manifest" "cert_issuer_manager_app" {
  depends_on = [helm_release.cert_manager]

  yaml_body = "${file("${path.module}/nginx/certbot/issuer-app.yaml")}"
}

resource "kubectl_manifest" "cert_issuer_manager_api" {
  depends_on = [helm_release.cert_manager]

  yaml_body = "${file("${path.module}/nginx/certbot/issuer-api.yaml")}"
}