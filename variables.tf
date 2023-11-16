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

variable "vm_node_cores" {
  type        = number
  description = "k8s node Virtual Machine Cores"
}

variable "vm_controller_cores" {
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

variable "vm_controller_memory" {
  type        = string
  description = "k8s controller Virtual Machine Memory"
}

variable "vm_controller_disk_size" {
  type        = string
  description = "k8s controller Virtual Machine Disk Size"
}

variable "vm_node_count" {
  type        = number
  description = "k8s node Virtual Machine Count"
}

variable "vm_node_memory" {
  type        = string
  description = "k8s node Virtual Machine Memory"
}

variable "vm_node_disk_size" {
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

variable "ssh_privatekey" {
  type        = string
  description = "SSH User"
}

variable "ssh_publickey" {
  type        = string
  description = "SSH User"
}

variable "metallb_ip_range" {
  type        = string
  description = "MetalLB IP Range"
}

variable "gitlab_external_url" {
  type        = string
  description = "Gitlab External URL"
}