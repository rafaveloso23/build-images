terraform {
  cloud {
    organization = "veloso"

    workspaces {
      name = "wks-teste-rvs-veloso"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "name" {
  name     = "wks-teste-rvs-veloso-rg"
  location = "East US"
}