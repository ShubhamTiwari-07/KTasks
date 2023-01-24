

variable "location"{
	type = string
}
variable "Rg_name"{
	type = string
}
variable "Subnet_Id"{
	type = string
}
variable "remote_port"{
	type = string
}

variable "backend_protocol"{
	type = string
}
variable "role"{
	type = string
	description = "nature of VMs"
}

variable "disk_count"{
	type = string
	description = "number of Data Disks"
}

variable "VM_count"{
	type = string
	description = "number of VMs"
}

variable "VM_size"{
	type = string
	description = "Size of VMs"
}

variable "os_publisher"{
	type = string
}

variable "offer"{
	type = string
}

variable "os_sku"{
	type = string
}

variable "password"{
	type = string
}



