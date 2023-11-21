variable "pm_vm_name_prefix" {
  type        = string
  description = "Proxmox VM Name"
}

variable "pm_token_id" {
  type        = string
  description = "Proxmox Token ID"
}

variable "pm_bridge" {
  type        = string
  description = "Proxmox network bridge"
}

variable "node_cores" {
  type        = number
  description = "k8s node Virtual Machine Cores"
}

variable "controller_cores" {
  type        = number
  description = "k8s controller Virtual Machine Cores"
}

variable "pm_token_secret" {
  type        = string
  description = "Proxmox Token secret"
}

variable "pm_node" {
  type        = string
  description = "Proxmox Node used to deploy VM"
}

variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "pm_template_name" {
  type        = string
  description = "Proxmox Template Name"
}

variable "pm_storage" {
  type        = string
  description = "Proxmox Storage"
}

variable "controller_memory" {
  type        = string
  description = "k8s controller Virtual Machine Memory"
}

variable "controller_disk_size" {
  type        = string
  description = "k8s controller Virtual Machine Disk Size"
}

variable "node_count" {
  type        = number
  description = "k8s node Virtual Machine Count"
}

variable "node_memory" {
  type        = string
  description = "k8s node Virtual Machine Memory"
}

variable "node_disk_size" {
  type        = string
  description = "k8s node Virtual Machine Disk Size"
}

variable "vm_user" {
  type        = string
  description = "Virtual Machine User"
}

variable "vm_password" {
  type        = string
  description = "Virtual Machine Password"
}

variable "metallb_ip_range" {
  type        = string
  description = "MetalLB IP Range"
}

variable "storage_memory" {
  type        = string
  description = "k8s storage Virtual Machine Memory"
}

variable "storage_disk_size" {
  type        = string
  description = "k8s storage Virtual Machine Disk Size"
}
variable "storage_disk_size_session" {
  type        = string
  description = "k8s storage Virtual Machine Disk Size for session iTop"
}

variable "storage_cores" {
  type        = number
  description = "k8s storage Virtual Machine Cores"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH Private Key"
}

variable "database_count" {
  type        = number
  description = "k8s database Virtual Machine Count"
}

variable "database_memory" {
  type        = string
  description = "k8s database Virtual Machine Memory"
}

variable "database_cores" {
  type        = number
  description = "k8s database Virtual Machine Cores"
}

variable "database_disk_size" {
  type        = string
  description = "k8s database Virtual Machine Disk Size"
}

variable "database_user" {
  type        = string
  description = "k8s database user"
}

variable "database_password" {
  type        = string
  description = "k8s database password"
}