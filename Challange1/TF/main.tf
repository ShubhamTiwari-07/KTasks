module "appVM" {
	source = "./modules/VM"

	location = azurerm_resource_group.krg.location
	Rg_name = azurerm_resource_group.krg.name
	Subnet_Id  = azurerm_subnet.app.id
	role = "role"
	disk_count = "1"
	VM_count = "2"
	VM_size = "Standard_DS1_V2"
	os_publisher = "Microsoft ads"
	offer = "windows2016"
	os_sku = "windows2016"
	password = azurerm_key_vault_secret.pwd.value
}


module "webVM" {
	source = "./modules/VM"

	location = azurerm_resource_group.krg.location
	Rg_name = azurerm_resource_group.krg.name
	Subnet_Id  = azurerm_subnet.web.id
	role = "role"
	disk_count = "1"
	VM_count = "2"
	VM_size = "Standard_DS1_V2"
	os_publisher = "Microsoft ads"
	offer = "windows2016"
	os_sku = "windows2016"
	password = azurerm_key_vault_secret.pwd.value
}

module "dbVM" {
	source = "./modules/VM"

	location = azurerm_resource_group.krg.location
	Rg_name = azurerm_resource_group.krg.name
	Subnet_Id  = azurerm_subnet.db.id
	role = "role"
	disk_count = "2"
	VM_count = "2"
	VM_size = "Standard_DS1_V2"
	os_publisher = "Microsoft ads"
	offer = "windows2016SQL"
	os_sku = "windows2016SQL"
	password = azurerm_key_vault_secret.pwd.value
}

module "appLB"{
	location = azurerm_resource_group.krg.location
	Rg_name = azurerm_resource_group.krg.name
	Subnet_Id  = azurerm_subnet.app.id
	remote_port = 50000
	backend_protocol = smb
	role = app
}

module "dbLB"{
	location = azurerm_resource_group.krg.location
	Rg_name = azurerm_resource_group.krg.name
	Subnet_Id  = azurerm_subnet.app.id
	remote_port = 1433
	backend_protocol = sql
	role = db
}