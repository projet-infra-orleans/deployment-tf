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
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }

  }

  backend "azurerm" {
  }

}

provider "azurerm" {
  features {}
  skip_provider_registration = true 
}

data "azurerm_resource_group" "rg" {
  name = "${var.resource_group_name}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.cluster_name}-${var.environment}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  dns_prefix          = "${var.dns_prefix}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"

    enable_auto_scaling = true
    min_count           = 1
    max_count           = 5

    zones = ["2"]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "${var.environment}"
  }

  sku_tier = "Free"
  
  kubernetes_version = "1.27.7"
}

provider "kubectl" {
  /* config_path = "~/.kube/config" */
  load_config_file       = false
  host                   = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
}

provider "helm" {
  kubernetes {
    /* config_path = "~/.kube/config" */
    host                   = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
  }
}

provider "kubernetes" {
  # Configuration options
  host                   = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
}
