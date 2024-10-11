provider "hcloud" {
  token = var.hcloud_token  # Use API token from GitHub Secrets
}

resource "hcloud_server" "vm" {
  name        = "front-vm"
  server_type = "cx22"       # Change based on your needs
  image       = "ubuntu-22.04"  # OS Image
  location    = "nbg1"       # Change the location to suit your needs

  ssh_keys = [
    var.ssh_key_name
  ]

  # Optional: Add firewall, backups, or volumes
}

output "server_ip" {
  value = hcloud_server.vm.ipv4_address
}

# SSH Key Input Variable
variable "ssh_key_name" {
  description = "Name of the SSH Key in Hetzner Cloud"
  type        = string
}

variable "hcloud_token" {
  description = "Hetzner API Token"
  type        = string
  sensitive   = true
}
