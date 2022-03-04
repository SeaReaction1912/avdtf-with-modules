variable "tag_env" {
  description = "The environment tag"
  default     = "RR AVD"
}

variable "sa_name" {
  description = "Boot Diag SA Name"
}

variable "avd_dc_vm_admin_password" {
  type = string
  description = "Local Admin Password for DC VM"
}

variable "vm_pip_name" {
  description = "VM Public IP Name"
  default = "avd-net-dc-vm-pip"
}

variable "vm_nic_name" {
  description = "VM NIC Name"
  default = "avd-dc01-nic"
}

variable "vm_name" {
  description = "VM Name"
  default = "avd-dc01"
}

variable "rg_name" {
  description = "Resource Group Name"
}

variable "rg_location" {
  description = "Resource Group Location"
}

variable "vnet_subnet_id" {
  description = "VNET Subnet ID"
}

variable "blob_endpoint" {
  description = "Blob Endpoint Name"
}

variable "vm_count" {
  description = "Number of VMs"
}