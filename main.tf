terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.11.0"
    }
    
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
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


provider "helm" {
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
