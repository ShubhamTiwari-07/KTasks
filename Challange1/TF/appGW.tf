resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.Krg.name
  virtual_network_name = azurerm_virtual_network.KVnet.name
  address_prefixes     = ["172.168.1.200/28"]
}

resource "azurerm_public_ip" "Kpip" {
  name                = "app-pip"
  resource_group_name = azurerm_resource_group.krg.name
  location            = azurerm_resource_group.krg.location
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "K-beap"
  frontend_port_name             = "K-feport"
  frontend_ip_configuration_name = "K-feip"
  http_setting_name              = "K-be-htst"
  listener_name                  = "K-httplstn"
  request_routing_rule_name      = "K-rqrt"
  redirect_configuration_name    = "K-rdrcfg"
}

resource "azurerm_application_gateway" "AppGW" {
  name                = "KApp-appgateway"
  resource_group_name = azurerm_resource_group.Krg.name
  location            = azurerm_resource_group.Krg.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}