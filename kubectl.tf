/*
* App
*/

resource "kubectl_manifest" "app_deployment" {
    yaml_body = "${file("${path.module}/app/deploy.yml")}"
}

resource "kubectl_manifest" "app_service" {
    yaml_body = "${file("${path.module}/app/service.yml")}"
}

resource "kubectl_manifest" "app_ingress" {    
    yaml_body = "${file("${path.module}/app/domain-ingress.yml")}"
}


/*
* Api
*/

resource "kubectl_manifest" "api_deployment" {
    depends_on = [kubectl_manifest.api_pvc]

    yaml_body = "${file("${path.module}/api/deploy.yml")}"
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
    yaml_body = "${file("${path.module}/api/domain-ingress.yml")}"
}