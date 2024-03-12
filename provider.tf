provider "azurerm" {
  features {}
}

# Resource Group for Event Hubs resources
resource "azurerm_resource_group" "entra-events" {
  name     = "entra-events-rg"
  location = "westus2" # Choose a suitable location
}
