terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
   backend "azurerm" {
      resource_group_name  = "${var.resource_group_name}"
      storage_account_name = "${var.storage_name}"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
   }

}

provider "azurerm" {
  features {}
  skip_provider_registration = true 
}


provider "kubernetes" {
    config_path = "~/.kube/config"
}
