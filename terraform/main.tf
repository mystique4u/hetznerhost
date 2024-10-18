terraform {
  backend "remote" {
    organization = "itin"  # Replace with your Terraform Cloud organization name

    workspaces {
      name = "hetznercloud"  # Replace with the Terraform Cloud workspace name
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

# Data block to retrieve the existing SSH key
data "hcloud_ssh_key" "existing" {
  name = var.ssh_key_name  # Use the name of the existing SSH key
}

# Hetzner Cloud VM resource
resource "hcloud_server" "vm" {
  name        = "github-action-vm"
  server_type = "cx22"  # Choose the server type (e.g., cx11, cx21, etc.)
  image       = "ubuntu-22.04"  # Base OS image
  location    = "nbg1"  # Hetzner data center location (e.g., nbg1, fsn1)

  public_net {
    ipv4_enabled = true  # Enable IPv4
    ipv6_enabled = false  # Disable IPv6
  }

  ssh_keys = [
    data.hcloud_ssh_key.existing.name  # Use the existing SSH key
  ]
}

# Output the public IPv4 address of the created VM
output "public_ip" {
  description = "The public IPv4 address of the VM"
  value       = hcloud_server.vm.ipv4_address
  sensitive   = true  # Sensitive output, useful for security
}

# Variables
variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "Name of the existing SSH key in Hetzner Cloud"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key content to use for access"
  type        = string
}
