
 resource "azurerm_network_interface" "nic" {
  name                = "${role}-nic"
  location            = azurerm_resource_group.krg.location
  resource_group_name = azurerm_resource_group.krg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.${var.role}.id
    private_ip_address_allocation = "Dynamic"
  }
}

 resource "azurerm_availability_set" "avset" {
   name                         = "as-${var.role}"
   location                     = azurerm_resource_group.krg.location
   resource_group_name          = azurerm_resource_group.krg.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }

 resource "azurerm_virtual_machine" "test" {
   count                 = var.VM_Count
   name                  = "vm-${var.role}-${count.index}"
   location              = azurerm_resource_group.krg.location
   availability_set_id   = azurerm_availability_set.avset.id
   resource_group_name   = azurerm_resource_group.krg.name
   network_interface_id = [azurerm_network_interface.nic.id]
   vm_size               = var.VM_size

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   # delete_os_disk_on_termination = true

   # Uncomment this line to delete the data disks automatically when deleting the VM
   # delete_data_disks_on_termination = true

   storage_image_reference {
     publisher = var.publisher
     offer     = var.offer
     sku       = var.os_sku
     version   = "latest"
   }

   storage_os_disk {
     name              = "myosdisk${count.index}"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   storage_data_disk {
     count             = var.disk_count 
     name              = "datadisk_new_${count.index}"
     managed_disk_type = "Standard_LRS"
     create_option     = "Empty"
     lun               = 0
     disk_size_gb      = "1023"
   }


   os_profile {
     computer_name  = "vm-${var.role}-${count.index}"
     admin_username = "testadmin"
     admin_password = var.password
   }

   os_profile_linux_config {
     count = var.publisher == "microsoft-ads" ? 0 : 1
     disable_password_authentication = false
   }

 }