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
      version = "1.33.0"  # Specify the provider version
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token  # Hetzner Cloud API token
}

# SSH Key Resource - Ensure this key already exists in Hetzner Cloud
resource "hcloud_ssh_key" "ssh_key" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key
}

# Hetzner Cloud VM resource
resource "hcloud_server" "vm" {
  name        = "github-action-vm"
  server_type = "cx22"  # Choose the server type (e.g., cx11, cx21, etc.)
  image       = "ubuntu-22.04"  # Base OS image
  location    = "nbg1"  # Hetzner data center location (e.g., nbg1, fsn1)

  ssh_keys = [
    hcloud_ssh_key.ssh_key.name  # Assign SSH key to the server
  ]
}

# Data block to retrieve the existing Floating IP by name
data "hcloud_floating_ip" "existing" {
  name = var.floating_ip_name  # Use the name of the existing Floating IP
}

# Assign the existing Floating IP to the server
resource "hcloud_floating_ip_assignment" "vm_floating_ip" {
  floating_ip_id = data.hcloud_floating_ip.existing.id  # Get the ID from the data block
  server_id      = hcloud_server.vm.id                    # Assign the Floating IP to this server
}

# Output the Floating IP Address
output "floating_ip" {
  description = "The floating IP address assigned to the VM"
  value       = hcloud_floating_ip_assignment.vm_floating_ip.floating_ip_id  # Ensure this returns the correct value
}

# Variables
variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "floating_ip_name" {  # Renamed variable to represent the name
  description = "Hetzner Cloud Floating IP name to assign"
  type        = string  # This remains a string
}

variable "ssh_key_name" {
  description = "Name of the existing SSH key in Hetzner Cloud"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key content to use for access"
  type        = string
}
