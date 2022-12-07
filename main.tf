# Terraform Block
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.23.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

# Provider Block
provider "azurerm" {
  # Configuration options
  features {}
}

# Azure Resource Group
resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.resource_group_location
}

# Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name = var.vnet_name
    address_space = var.vnet_address_space
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}