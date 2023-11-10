/*
* App
*/

resource "kubectl_manifest" "app_deployment" {
    yaml_body = "${file("${path.module}/app/deploy.yaml")}"
}

resource "kubectl_manifest" "app_service" {
    yaml_body = "${file("${path.module}/app/service.yaml")}"
}

resource "kubectl_manifest" "app_ingress" {
    yaml_body = "${file("${path.module}/app/domain-ingress.yaml")}"
}


/*
* Api
*/

resource "kubectl_manifest" "api_deployment" {
    depends_on = [kubectl_manifest.api_pvc]

    yaml_body = "${file("${path.module}/api/deploy.yaml")}"
}

resource "kubectl_manifest" "api_service" {
    yaml_body = "${file("${path.module}/api/service.yaml")}"
}

resource "kubectl_manifest" "api_pv" {
    yaml_body = "${file("${path.module}/api/pv-volume.yaml")}"
}

resource "kubectl_manifest" "api_pvc" {
    depends_on = [kubectl_manifest.api_pv]
    yaml_body = "${file("${path.module}/api/pv-claim.yaml")}"
}

resource "kubectl_manifest" "api_ingress" {
    yaml_body = "${file("${path.module}/api/domain-ingress.yaml")}"
}

