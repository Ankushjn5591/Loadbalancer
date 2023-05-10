provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg1" {
   name = "ankushrg"
}

data "azurerm_public_ip" "pip" {
    name = "pip1"
    resource_group_name = data.azurerm_resource_group.rg1.name
}

data "azurerm_resource_group" "rg2" {
   name = "chhavirg"
}


data "azurerm_public_ip" "pip2" {
    name = "pip2"
    resource_group_name = data.azurerm_resource_group.rg2.name
}

resource "azurerm_traffic_manager_profile" "trm" {
  name                = "myfirsttm"
  resource_group_name = data.azurerm_resource_group.rg1.name
  traffic_routing_method = "Performance"

monitor_config {
    protocol = "http"
    port = 80
    path = "/"
    interval = "10"
    timeout = "5"
    tolerated_failures = "3"
  }
  dns_config {
    relative_name = "mytrmprofile"
    ttl = 60
  }
}
  



terraform {
  backend "azurerm" {
    resource_group_name  = "Storagerg"
    storage_account_name = "storageaccount5591"
    container_name       = "tfstate"
    key                  = "load.terraform.tfstate"
    access_key = "9DcT8nW/iKr0v2t8bfFIfM24sfJRGva1oD4macMbw6UkSwUXYHJr0ErQzgv15oErzQebT6lpi4zl+ASt2Lfeeg=="
  }
}