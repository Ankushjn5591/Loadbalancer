provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg1" {
   name = "ankushrg"
}

data "azurerm_network_interface" "nic" {
    name = "nic1"
    resource_group_name = data.azurerm_resource_group.rg1.name
}

data "azurerm_public_ip" "pip" {
    name = "pip1"
    resource_group_name = data.azurerm_resource_group.rg1.name
}

data "azurerm_resource_group" "rg2" {
   name = "chhavirg"
}

data "azurerm_network_interface" "nic2" {
    name = "nic2"
    resource_group_name = data.azurerm_resource_group.rg2.name
}

data "azurerm_public_ip" "pip2" {
    name = "pip2"
    resource_group_name = data.azurerm_resource_group.rg2.name
}

resource "azurerm_public_ip" "lbip" {
  name                = "lbpip"
  location            = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "myloadlb"
  location            = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  frontend_ip_configuration {
    name                          = "lbfrontendip"
    public_ip_address_id          = azurerm_public_ip.lbip.id
    private_ip_address_allocation = "Dynamic"
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