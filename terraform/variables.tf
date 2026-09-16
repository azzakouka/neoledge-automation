variable "vm_prefix" {
  type        = string
  description = "Préfixe du nom des VMs"
  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.vm_prefix))
    error_message = "Minuscules, chiffres et tirets uniquement."
  }
}

variable "vm_count" {
  type    = number
  default = 1
  validation {
    condition     = var.vm_count >= 0 && var.vm_count <= 10
    error_message = "Entre 0 et 10 VMs."
  }
}

variable "vm_size" {
  type    = string
  default = "u1.small"
  validation {
    condition     = contains(["u1.small", "u1.medium", "u1.large", "u1.xlarge"], var.vm_size)
    error_message = "Taille non autorisée."
  }
}

variable "vm_os" {
  type    = string
  default = "centos-stream9"
  validation {
    condition     = contains(["centos-stream9", "centos-stream10", "fedora", "rhel9", "rhel10"], var.vm_os)
    error_message = "Système non disponible."
  }
}

variable "vm_disk" {
  type    = string
  default = "30Gi"
}

variable "ssh_pub_key" {
  type = string
}
