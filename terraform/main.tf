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
}

provider "azurerm" {
  features {}
  skip_provider_registration = true 
}


provider "kubernetes" {
  # Configuration options
}
