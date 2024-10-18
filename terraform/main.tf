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

# Data block to retrieve the existing SSH key
data "hcloud_ssh_key" "existing" {
  name = var.ssh_key_name  # Use the name of the existing SSH key
}

# Data block to retrieve the existing firewall by name
data "hcloud_firewall" "existing" {
  name = var.firewall_name  # Firewall name to attach
}

# Hetzner Cloud VM resource with firewall
resource "hcloud_server" "vm" {
  name        = "github-action-vm"
  server_type = "cx22"
  image       = "ubuntu-22.04"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true  # Enable IPv4
    ipv6_enabled = false  # Disable IPv6
  }

  ssh_keys    = [hcloud_ssh_key.default.id]

  firewall_ids = [data.hcloud_firewall.existing.id]  # Attach the firewall by ID
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

variable "ssh_key_name" {
  description = "Name of the existing SSH key in Hetzner Cloud"
  type        = string
}


variable "ssh_public_key" {
  description = "Public SSH key content to use for access"
  type        = string
}

resource "hcloud_ssh_key" "default" {
  name       = "workook"
  public_key = var.ssh_public_key
}

variable "firewall_name" {
  description = "Name of the Hetzner firewall to apply"
  type        = string
}
