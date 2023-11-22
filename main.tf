terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
    
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    kubernetes = {
        source  = "hashicorp/kubernetes"
        version = ">= 2.0.1"
      }
  }
 
  backend "azurerm" {
  }

}

# Utilisation d'une ressource de groupe existante
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Utilisation d'un compte de stockage existant
data "azurerm_storage_account" "stockage" {
  name                = "${var.stockage_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Utilisation d'un cluster AKS existant
data "azurerm_kubernetes_cluster" "aks" {
  name                =  "${var.cluster_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}


provider "azurerm" {
  features {}
  skip_provider_registration = true 
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  load_config_file       = false
}

provider "helm" {
  debug   = true
  kubernetes {
    /* config_path = "~/.kube/config" */
  host = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

data "azurerm_client_config" "current" {}

# Utilisation d'un coffre de clés existant
data "azurerm_key_vault" "tf_kv" {
  depends_on          = [data.azurerm_kubernetes_cluster.aks]
  name                = "${var.vault_key_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

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

resource "helm_release" "ingress" {
  depends_on       = [azurerm_key_vault_access_policy.aks_access_to_kv]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"
  version          = "4.7.1"
  namespace        = "ingress-ns"
}

resource "helm_release" "akv2k8" {
  depends_on       = [helm_release.ingress]
  name             = "ingress-akv2k8"
  repository       = "https://charts.spvapi.no"
  chart            = "akv2k8s"
  namespace        = "akv2k8s"
}

resource "kubectl_manifest" "create_namespace" {
  depends_on = [helm_release.akv2k8] 
  yaml_body  = file("./manifests/createNamespace.yaml")
}

resource "kubectl_manifest" "sync_cert_service" {
  depends_on = [kubectl_manifest.create_namespace] 
  yaml_body  = file("./manifests/syncCert.yaml")
}

resource "kubectl_manifest" "use_cert_service" {
  depends_on = [kubectl_manifest.sync_cert_service] 
  yaml_body  = file("./manifests/useCert.yaml")
}

