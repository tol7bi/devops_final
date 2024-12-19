# HashiCorp Nomad

This repository contains ansible playbook for Nomad configuration. It will install nomad and make configurations,
systemd unit files for nomad server and nomad client

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)
- [Confguration](#configuration)

## Pre-requisites

- Ansible installed
- Linux based system in order to create systemd unit files

## Usage

This section contains step-by-step guide how to setup nomad server and nomad client using ansible.
To use this configs locally there is a ready Makefile with the following command.

```bash
make setup_nomad
```

By default it installs nomad on localhost. If you want install nomad configuration on remote server you should
add/replace data about remote server in inventory file:

```bash
remote_server_1 ansible_host=<ip_address> ansible_user=<username> ansible_ssh_private_key_file=<path/to/id_rsa>
```

Check that everything is working using these commands:

```bash
systemctl status nomad-server.service
systemctl status nomad-client.service
```

Check logs using these commands:

```bash
journalctl -u nomad-server.service
journalctl -u nomad-client.service
```

Check that you can run jobs. Use make command:

```dotenv
make run_job JOB_NAME=test_job.nomad
```

## Configuration

Configuration files located in, add yourself to nomad group to be able to modify them or use root privileges.

```dotenv
/data/nomad_server/nomad # configuration of server nomad
/data/nomad_client/nomad # configuration of client nomad
/var/lib/nomad_server/data/ # data of server node nomad
/var/lib/nomad_client/data/ # data of client node nomad
```
