locals {
    dns = "${var.environment}.${var.dns}"
}

/*
* App
*/

resource "kubectl_manifest" "app_deployment" {
    yaml_body = "${templatefile("${path.module}/app/deploy.yml", {
        dns = local.dns
    })}"
}

resource "kubectl_manifest" "app_service" {
    yaml_body = "${file("${path.module}/app/service.yml")}"
}

resource "kubectl_manifest" "app_ingress" {
    yaml_body = "${templatefile("${path.module}/app/domain-ingress.yml", {
        dns = local.dns
    })}"
}


/*
* Api
*/

resource "kubectl_manifest" "api_deployment" {
    depends_on = [kubectl_manifest.api_pvc, kubectl_manifest.secret_url_mongo]

    yaml_body = "${templatefile("${path.module}/api/deploy.yml", {
        dns = local.dns
    })}"
}

resource "kubectl_manifest" "api_service" {
    yaml_body = "${file("${path.module}/api/service.yml")}"
}

resource "kubectl_manifest" "api_pv" {
    yaml_body = "${file("${path.module}/api/pv-volume.yml")}"
}

resource "kubectl_manifest" "api_pvc" {
    depends_on = [kubectl_manifest.api_pv]
    yaml_body = "${file("${path.module}/api/pv-claim.yml")}"
}

resource "kubectl_manifest" "api_ingress" {
    yaml_body = "${templatefile("${path.module}/api/domain-ingress.yml", {
        dns = local.dns
    })}"
}