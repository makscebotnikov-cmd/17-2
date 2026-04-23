### Cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

### SSH vars

variable "vms_ssh_public_root_key" {
  type        = string
  description = "Public SSH key: ssh-keygen -t ed25519"
}


# Task 6
### VM Resources Map

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  description = "VM resources configuration"
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

### VM Metadata Map

variable "vms_metadata" {
  type = map(string)
  description = "Common metadata for all VMs"
  default = {
    serial-port-enable = "1"
    ssh-keys           = ""
  }
}

### VM settings

variable "vm_web_preemptible" {
  type        = bool
  description = "Preemptible WEB VM"
  default     = true
}

variable "vm_web_nat" {
  type        = bool
  description = "Enable NAT for WEB VM"
  default     = true
}

variable "vm_db_preemptible" {
  type        = bool
  description = "Preemptible DB VM"
  default     = true
}

variable "vm_db_nat" {
  type        = bool
  description = "Enable NAT for DB VM"
  default     = true
}
