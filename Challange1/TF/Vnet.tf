
resource "azurerm_network_security_group" "web" {
  name                = "web-nsg"
  location            = azurerm_resource_group.krg.location
  resource_group_name = azurerm_resource_group.krg.name
}

resource "azurerm_network_security_group" "app" {
  name                = "app-nsg"
  location            = azurerm_resource_group.krg.location
  resource_group_name = azurerm_resource_group.krg.name
}

resource "azurerm_network_security_group" "db" {
  name                = "db-nsg"
  location            = azurerm_resource_group.krg.location
  resource_group_name = azurerm_resource_group.krg.name
}


resource "azurerm_virtual_network" "KVnet" {
  name                = var.Vnet_name
  location            = azurerm_resource_group.krg.location
  resource_group_name = azurerm_resource_group.krg.name
  address_space       = ["172.168.1.0/24"]

}

resource "azurerm_subnet" "app" {
  name                 = "app"
  resource_group_name  = azurerm_resource_group.krg.name
  virtual_network_name = azurerm_virtual_network.krg.name
  address_prefixes     = ["172.168.1.0/27"]

}

resource "azurerm_subnet" "web" {
  name                 = "web"
  resource_group_name  = azurerm_resource_group.krg.name
  virtual_network_name = azurerm_virtual_network.krg.name
  address_prefixes     = ["172.168.1.32/27"]
}
resource "azurerm_subnet" "db" {
  name                 = "db"
  resource_group_name  = azurerm_resource_group.krg.name
  virtual_network_name = azurerm_virtual_network.krg.name
  address_prefixes     = ["172.168.1.64/27"]
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}