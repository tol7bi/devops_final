# Sonarqube

This repository contains ansible playbook for Sonarqube configuration. It will install sonarqube and make
configurations, systemd unit files for Sonarqube

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)

## Pre-requisites

- Ansible installed
- Linux based system in order to create systemd unit files

## Usage

This section contains step-by-step guide how to setup Sonarqube using ansible.
To use this configs locally run command

```bash
ansible-playbook -i inventory sonarqube_playbook.yml -K
```

By default it installs Sonarqube on localhost. If you want install Sonarqube configuration on remote server you should
add/replace data about remote server in inventory file:

```bash
remote_server_1 ansible_host=<ip_address> ansible_user=<username> 
```

Check that everything is working using these commands:

```bash
systemctl status sonarqube
```

Check logs using these commands:

```bash
journalctl -u sonarqube
```