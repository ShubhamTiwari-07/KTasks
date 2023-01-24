
 resource "azurerm_network_interface" "nic" {
  name                = "${role}-nic"
  location            = var.location
  resource_group_name = var.Rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.Subnet_Id
    private_ip_address_allocation = "Dynamic"
  }
}

 resource "azurerm_availability_set" "avset" {
   name                         = "as-${var.role}"
   location                     = var.location
   resource_group_name          = var.Rg_name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }

 resource "azurerm_virtual_machine" "test" {
   count                 = var.VM_Count
   name                  = "vm-${var.role}-${count.index}"
   location              = var.location
   availability_set_id   = azurerm_availability_set.avset.id
   resource_group_name   = var.Rg_name
   network_interface_id = [azurerm_network_interface.nic.id]
   vm_size               = var.VM_size

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