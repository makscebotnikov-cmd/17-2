locals {
  # Prefix for VMs
  vm_common_prefix = "netology-platform"
  
  # VM type suffixes
  vm_web_type = "web"
  vm_db_type  = "db"
  
  # VM names
  vm_web_name = "${local.vm_common_prefix}-${local.vm_web_type}"
  vm_db_name  = "${local.vm_common_prefix}-${local.vm_db_type}"
  
  # Zones for VM
  vm_web_zone = "ru-central1-a"
  vm_db_zone  = "ru-central1-b"
  
  # Platform for VMs
  vm_platform = "standard-v3"
  
  # Image for VMs
  vm_image_family = "ubuntu-2004-lts"
  
  # metadata for VMs
  vms_common_metadata = {
    serial-port-enable = "1"
  }
}
