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

# Data block to retrieve the existing SSH key with the name "workook"
data "hcloud_ssh_key" "existing" {
  name = "workook"  # Name of the existing SSH key
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

  ssh_keys = [data.hcloud_ssh_key.existing.id]  # Use the existing SSH key named "workook"

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

variable "firewall_name" {
  description = "Name of the Hetzner firewall to apply"
  type        = string
}
