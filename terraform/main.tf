terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true 
}


provider "kubernetes" {
  # Configuration options
}
