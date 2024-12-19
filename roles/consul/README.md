# HashiCorp Consul

This repository contains ansible playbook for Consul configuration. It will install nomad and make configurations,
systemd unit files for consul server.

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)
- [Confguration](#configuration)

## Pre-requisites

- Ansible installed
- Vault and Nomad clusters up
- Linux based system in order to create systemd unit files

## Usage

This section contains step-by-step guide how to setup consul server using ansible.
To use this configs locally there is a ready Makefile with the following command.

```bash
make setup_consul
```

By default it installs consul on localhost. If you want install consul configuration on remote server you should
add/replace data about remote server in inventory file:

```bash
remote_server_1 ansible_host=<ip_address> ansible_user=<username> ansible_ssh_private_key_file=<path/to/id_rsa>
```

Check that everything is working using these commands:

```bash
make status_server
```

Check logs using these commands:

```bash
journalctl -u consul-server.service
```

Also you need to configure the dns resolver to see Consul

```bash
sudo nano /etc/systemd/resolved.conf
```

```
[Resolve]
DNS=127.0.0.1:8600
Domains=~cosnul
```
```bash
sudo systemctl restart systemd-resolved
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo systemctl status systemd-resolved
```

Now nomad and vault are available with .service.consul:{port}