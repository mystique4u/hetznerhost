# Repository Flows Documentation

## GIT FLOW

### Terraform

Runs `terraform main.tf` with the following setup:

#### Provider and Backend
- **Provider**: `hetznercloud/hcloud`
- **Backend**: Terraform Cloud for state storage

#### Configuration
- **Name**: `github-action-vm`
- **Server Type**: `cx22`
- **Image**: `ubuntu-22.04`
- **Location**: `nbg1`
- **IPv4 Enabled**: `true`
- **IPv6 Enabled**: `false`

#### Cloud-Init Script
- Set group to `sudo`
- Add `ssh_authorized_keys`:
  - `${var.ssh_public_key}`

#### Outputs
- `public_ip`

#### Variables
- `hcloud_token`
- `firewall_name`
- `ssh_public_key`
- `sudo_user`

---

### Manage Domains

Manage domains with Hetzner API based on a list of domains from Nginx configs:

1. Find all domain config files (`domain.name.conf`) in the domains folder.
2. Extract domain names from the config files:
    - Remove `.conf` extension.
    - Remove everything after the first dot (`.`).
3. Check and create domains using Hetzner API.
4. Check if the A record already exists for the domain.
5. Create the new A record for the domain.

---

### Ansible

Configure VM with Ansible:

1. Install Ansible.
2. Add Private SSH Key for Ansible.
3. Update Ansible Inventory:
    - Add Public IP.
    - Add `sudo` user.
4. Run Ansible Playbook.
5. Pass `COMPOSE_ENV`to compose directory as .env file

---

## ANSIBLE FLOW

### Inventory File Tasks

#### Common Tasks
1. Update all packages.
2. Install required packages:
    - `curl`
    - `wget`
    - `build-essential`
    - `ca-certificates`
    - `gnupg`
    - `lsb-release`
    - `software-properties-common`
    - `mc`
3. Enable IP forwarding for WireGuard VPN.
4. Ensure IP forwarding is persistent.
5. Allow necessary ports through the firewall.
6. Create folder structure for Docker Compose.
7. Copy the entire Compose directory to the server.
8. **TODO**: If not the first run and some files exist, remove specific lines.
9. Create secrets file.

#### DevTools Tasks
1. Install Git.
2. Install Neovim.

#### Docker Tasks
1. Install Docker.
2. Enable and start Docker service.
3. Install Docker Compose.
4. Add `docker` group.
5. Add the current user to the `docker` group.
6. Verify Docker installation.
7. Display Docker version.
8. Verify Docker Compose installation.
9. Display Docker Compose version.
