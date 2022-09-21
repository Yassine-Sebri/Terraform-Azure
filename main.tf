# Terraform Block
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.23.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

# Provider Block
provider "azurerm" {
  # Configuration options
  features {}
}