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
      version = "1.33.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "ssh_key" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key
}

resource "hcloud_server" "vm" {
  name        = "github-action-vm"
  server_type = "cx22"
  image       = "ubuntu-22.04"
  location    = "nbg1"

  ssh_keys = [hcloud_ssh_key.ssh_key.id]
}

data "hcloud_floating_ip" "ip" {
  id = var.floating_ip_id
}

resource "hcloud_floating_ip_assignment" "vm_floating_ip" {
  floating_ip_id = data.hcloud_floating_ip.ip.id
  server_id      = hcloud_server.vm.id
}

output "server_ip" {
  description = "The public IP address of the server"
  value       = hcloud_server.vm.ipv4_address
}

output "floating_ip" {
  description = "The floating IP address assigned to the VM"
  value       = data.hcloud_floating_ip.ip.ip_address
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "floating_ip_id" {
  description = "Hetzner Cloud Floating IP ID to assign"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key in Hetzner Cloud"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key content to use for access"
  type        = string
}