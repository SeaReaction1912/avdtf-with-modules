variable "tag_env" {
  description = "The environment tag"
  default     = "RR AVD"
}

variable "sa_name" {
  description = "The Storage Account Name"
  default     = "avdstoreastus"
}

variable "sa_fs_name" {
  description = "The Storage Account File Share Name"
  default     = "avd-fs-eastus"
}

variable "fs_quota" {
  description = "The size of the file share in GB"
  default     = "512"
}

variable "rg_name" {
  description = "Resource Group Name"
}

variable "rg_location" {
  description = "Resource Group Location"
}