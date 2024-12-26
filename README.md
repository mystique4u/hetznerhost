# Automating Cloud Host Creation and Management

This repository was created to automate routine tasks using Infrastructure as Code (IaC) principles to provision and manage hosts in the cloud. The Hetzner Cloud provider was chosen as the foundation due to its affordability and extensive feature set.

The key idea behind this project is that no manual configuration should be performed on the host. All host installation and application deployment processes are implemented as code to ensure consistency and repeatability.

## Key Features

## Workflow Overview

This repository automates cloud host provisioning and management using GitHub workflows with Terraform, Ansible, and Docker Compose.

### Key Components

1. **Terraform**:
   - Provisions virtual machines (VMs) in Hetzner Cloud with specified configurations.

2. **GitHub Actions**:
   - Automates the provisioning workflow.
   - Creates DNS records using the Hetzner DNS API.
   - Configures Nginx based on predefined DNS names. (This feature requires further improvement.)

3. **Ansible**:
   - Updates the operating system.
   - Installs essential tools such as Docker and Docker Compose.
   - Creates a folder structure for containerized applications.
   - Synchronizes the Compose folder from the repository to the host.
   - Stops, deletes images, and re-runs the Docker Compose file for deployment.

4. **Docker Compose**:
   - Sets up and manages containerized services on the host.

This workflow ensures a fully automated and consistent approach to provisioning and deploying applications in the cloud.


---

## Detailed Flows description

### GIT FLOW

#### Terraform

Runs `terraform main.tf` with the following setup:

##### Provider and Backend
- **Provider**: `hetznercloud/hcloud`
- **Backend**: Terraform Cloud for state storage

##### Configuration
- **Name**: `github-action-vm`
- **Server Type**: `cx22`
- **Image**: `ubuntu-22.04`
- **Location**: `nbg1`
- **IPv4 Enabled**: `true`
- **IPv6 Enabled**: `false`

##### Cloud-Init Script
- Set group to `sudo`
- Add `ssh_authorized_keys`:
  - `${var.ssh_public_key}`

##### Outputs
- `public_ip`

##### Variables
- `hcloud_token`
- `firewall_name`
- `ssh_public_key`
- `sudo_user`

#### Manage Domains

Manage domains with Hetzner API based on Nginx configurations:

1. Find all domain config files (`domain.name.conf`) in the domains folder.
2. Extract domain names from the config files:
    - Remove `.conf` extension.
    - Remove everything after the first dot (`.`).
3. Check and create domains using Hetzner API.
4. Check if the A record already exists for the domain.
5. Create the new A record for the domain.

#### Ansible

1. Install Ansible.
2. Add Private SSH Key for Ansible.
3. Update Ansible Inventory:
    - Add Public IP.
    - Add `sudo` user.
4. Run Ansible Playbook.
5. Pass `COMPOSE_ENV`.

---

### ANSIBLE FLOW

#### Inventory File Tasks

##### Common Tasks
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

##### DevTools Tasks
1. Install Git.
2. Install Neovim.

##### Docker Tasks
1. Install Docker.
2. Enable and start Docker service.
3. Install Docker Compose.
4. Add `docker` group.
5. Add the current user to the `docker` group.
6. Verify Docker installation.
7. Display Docker version.
8. Verify Docker Compose installation.
9. Display Docker Compose version.

##### Main Compose Task
1. Create folder structure for Docker Compose
2. Copy entire compose directory to the server
3. Create secrets .env file for compose
4. Stop Docker Compose services
5. Remove all unused Docker images
6. Bring up Docker Compose services

---

### Services and Tools

#### Tools Installed via Ansible on host
- **Users & SSH Keys**
- **Docker**
- **Docker Compose**
- **Midnight Commander (mc)**
- **Neovim (nvim)**
- **Git**

#### Docker Compose Services
The following services are installed and managed via Docker Compose(plan):

- **Vaultwarden** (self-hosted password manager) - #TODO
- **Nginx-certbot** (web server + letsencrypt)
- **WireGuard** (VPN service with Web UI) - [Tutorial](https://github.com/linuxserver/docker-wireguard) - #TODO
- **iRedMail** (open-source mail server) - #TODO
- **MySQL/PostgreSQL** (database server) - [Tutorial](https://tecadmin.net/using-mysql-with-docker-compose/) - #TODO
- **Mailserver** - [Mailserver/Docker-Mailserver](https://github.com/mailserver/docker-mailserver) - #TODO?
#### TODO
- persistent storage backup with rsync to hetzner cloud storage
- restore from storage (for new setups?)

---

## GitHub Secrets

The following secrets need to be created and set as GitHub Secrets:

- `COMPOSE_ENV` - everything that you want to use on the host as .env file. It will be stored in compose/.env file
- `DNS_API_TOKEN`- your hetzner DNS API token
- `DNS_ZONE`- your hetzner DNS zone id(you can get it from url in admin panel)
- `HCLOUD_TOKEN`- your hetzner cloud API token
- `SSH_KEY_NAME` - your hetzner ssh key name (is it used?)
- `SSH_PRIVATE_KEY` - your SSH private key. You have to create SHH key pair. This key you will use for direct host connection 
- `SSH_PUBLIC_KEY`- your SSH pub key part from created above key pair
- `SUDO_USER`- just your sudo username
- `TFC_TOKEN`- your terrafrom cloud api token app.terraform.io. It used terraform cloud as free terraform state storage

---

## Prerequisites

- A Hetzner Cloud account with API access.
- A terraform cloud provider app.terraform.io account.
- Terraform installed locally(optional for testing).
- Ansible installed locally (optional for manual provisioning).
- SSH keypair created and configured.

---


## TODO Getting Started

1. Clone the repository:
    ```bash
    git clone https://github.com/mystique4u/hetznerhost.git
    cd hetznerhost
    ```

2. Configure your Hetzner Cloud API token and other credentials in GitHub Actions secrets.

3. Customize the Ansible playbooks and Docker Compose configurations as needed.

4. Run the GitHub Actions workflow to provision your VM.

---

## Contributions

Feel free to open issues or submit pull requests to improve this project!

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
