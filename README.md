# Helper VM in Hetzner Cloud

This repository automates the creation, configuration, and setup of a virtual machine (VM) in the Hetzner Cloud using GitHub Actions and Terraform. It also sets up a variety of services on the VM via Ansible and Docker.

## Overview

The workflow in this repository leverages GitHub Actions to automatically:
- Create a VM in Hetzner Cloud with a specified IP address using Terraform.
- Install and configure essential tools and services using Ansible and Docker.

## Services and Tools

The VM will be provisioned with the following tools and services:

### Tools installed via Ansible:
- **Users & SSH Keys** (optional: customize as needed)
- **Docker**
- **Docker Compose**
- **Midnight Commander (mc)**
- **Neovim (nvim)**
- **Git**

### Docker Compose Setup:
The following services are installed and managed via Docker Compose:
- **Vaultwarden** (a self-hosted password manager)
- **Nginx** (web server)
- **WireGuard** (VPN service with Web UI)
- **iRedMail** (open-source mail server)
- **Certbot** (for SSL certificates)
- **MySQL/PostgreSQL** (database server)
- **Mailserver** ([mailserver/docker-mailserver](https://github.com/mailserver/docker-mailserver))

## Prerequisites

- A Hetzner Cloud account with API access.
- Terraform installed locally.
- Ansible installed locally (for manual provisioning outside of GitHub Actions).

## To-Do

- [ ] Implement Terraform scripts to create a Hetzner machine with an existing IP address.
- [ ] Further customize Ansible roles for users and SSH key management.

## Getting Started

To get started, clone this repository and configure the necessary environment variables for Hetzner Cloud and GitHub Actions secrets.

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/helper-vm-hetzner.git
    cd helper-vm-hetzner
    ```

2. Configure your Hetzner Cloud API token and other credentials in GitHub Actions secrets.

3. Customize the Ansible playbooks and Docker Compose configuration as needed.

4. Run the GitHub Actions workflow to provision your VM.

## Contributions

Feel free to open issues or submit pull requests to improve this project!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
