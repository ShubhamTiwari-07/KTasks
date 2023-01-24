resource "azurerm_lb" "azlb" {
  location            = var.location
  name                = ${var.role}-lb
  resource_group_name = var.Rg_name
  sku                 = var.lb_sku


  frontend_ip_configuration {
    name                          = var.frontend_name
    private_ip_address            = var.frontend_private_ip_address
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
  frontend_ip_configuration_name = var.frontend_name
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = "VM-${count.index}"
  protocol                       = "Tcp"
  resource_group_name            = data.azurerm_resource_group.azlb.name
  frontend_port                  = "5000${count.index + 1}"
}

resource "azurerm_lb_probe" "azlb" {
  count = length(var.lb_probe)

  loadbalancer_id     = azurerm_lb.azlb.id
  name                = element(keys(var.lb_probe), count.index)
  port                = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 1)
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
  protocol            = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 0)
  request_path        = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 2)
}

resource "azurerm_lb_rule" "azlb" {
  count = length(var.lb_port)

  backend_port                   = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
  frontend_ip_configuration_name = var.frontend_name
  frontend_port                  = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = element(keys(var.lb_port), count.index)
  protocol                       = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.azlb.id]
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 5
  probe_id                       = element(azurerm_lb_probe.azlb[*].id, count.index)
}