

resource "azurerm_lb" "azlb" {
  location            = var.location
  name                = ${var.role}-lb
  resource_group_name = var.Rg_name
  sku                 = var.lb_sku


  frontend_ip_configuration {
    name                          = var.role
    private_ip_address_allocation = Dynamic
    subnet_id                     = var.frontend_subnet_id
  }
}

resource "azurerm_lb_backend_address_pool" "azlb" {
  loadbalancer_id = azurerm_lb.azlb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "azlb" {
  count = length(var.remote_port)

  backend_port                   = element(var.remote_port[element(keys(var.remote_port), count.index)], 1)
  frontend_ip_configuration_name = "frontend-${var.role}"
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = "vm-${var.role}-${count.index}"
  protocol                       = "Tcp"
  resource_group_name            = var.Rg_name
  frontend_port                  = "5000${count.index + 1}"
}

resource "azurerm_lb_probe" "azlb" {

  loadbalancer_id     = azurerm_lb.azlb.id
  name                = "lb-probe-${var.role}"
  port                = var.remote_port
  interval_in_seconds = 30
  number_of_probes    = 5
  protocol            = var.backend_protocol
}

resource "azurerm_lb_rule" "azlb" {
  count = length(var.lb_port)

  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "frontend-${var.role}"
  frontend_port                  = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = var.role
  protocol                       = var.backend_protocol
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.azlb.id]
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 5
  probe_id                       = element(azurerm_lb_probe.azlb[*].id, count.index)
}