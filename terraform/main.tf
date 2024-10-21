terraform {
  backend "remote" {
    organization = "itin"

    workspaces {
      name = "hetznercloud"
    }
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.48.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token  # Hetzner Cloud API token
}

# Data block to retrieve the existing firewall by name
data "hcloud_firewall" "existing" {
  name = var.firewall_name  # Firewall name to attach
}

# Hetzner Cloud VM resource with firewall and cloud-init to create sudo user
resource "hcloud_server" "vm" {
  name        = "github-action-vm"
  server_type = "cx22"
  image       = "ubuntu-22.04"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  firewall_ids = [data.hcloud_firewall.existing.id]

  # Cloud-init script to create a new sudo user and inject SSH public key
  user_data = <<-EOF
    #cloud-config
    users:
      - name: ${var.sudo_user}  # New sudo user
        groups: sudo
        shell: /bin/bash
        sudo: ['ALL=(ALL) NOPASSWD:ALL']
        ssh_authorized_keys:
          - ${var.ssh_public_key}
  EOF
}

# Output the public IPv4 address of the created VM
output "public_ip" {
  description = "The public IPv4 address of the VM"
  value       = hcloud_server.vm.ipv4_address
  sensitive   = true
}

# Variables
variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "firewall_name" {
  description = "Name of the Hetzner firewall to apply"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key for the sudo user"
  type        = string
}

variable "sudo_user" {
  description = "Public SSH key for the sudo user"
  type        = string
}