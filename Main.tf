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

resource "azurerm_lb_backend_address_pool" "lbpool" {
  name                = "lbbackend"
  resource_group_name = data.azurerm_resource_group.rg1.name
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association"  "nic" {
  network_interface_id = data.azurerm_network_interface_nic.name
  ip_configuration_name = data.azurerm_public_ip.pip.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbpool.id
}

resource "azurerm_network_interface_backend_address_pool_association"  "nic" {
  network_interface_id = data.azurerm_network_interface_nic2.name
  ip_configuration_name = data.azurerm_public_ip.pip2.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbpool.id
}

resource "azurerm_lb_probe" "lbprobe" {
  name                = "lbprobe"
  resource_group_name = data.azurerm_resource_group.rg1.name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
  interval            = 15
  number_of_probes    = 2
  request_path        = "/"
  unhealthy_threshold = 2
  timeout_seconds     = 10
}

 load_balancing_rule {
    name                   = "lbrule"
    frontend_ip_configuration_name = azurerm_lb.frontend_ip_configuration.lb.name
    backend_address_pool_id         = azurerm_lb_backend_address_pool.lbpool.id
    protocol                         = "Tcp"
    frontend_port                    = 80
    backend_port                     = 80
    enable_floating_ip               = false
    idle_timeout_in_minutes          = 5
    probe_id                          = azurerm_lb_probe.lbprobe.id
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