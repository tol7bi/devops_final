# Nexus

This repository contains ansible playbook for Nexus configuration. It will install nexus and make
configurations, systemd unit files for Nexus

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)

## Pre-requisites

- Ansible installed
- Linux based system in order to create systemd unit files
- SSH key on 

## Usage

This section contains step-by-step guide how to setup Nexus on a server using ansible.
To use this configs run command:

```bash
cd path/to/nexus_playbook.yml
ansible-playbook -i inventory nexus_playbook.yml --ask-pass #enter the password of server: "KBTU123K"
```

Check the repositories(docker-hosted, docker-proxy and docker-group) there:

```bash
http://167.99.244.46:8081/#browse/browse
```

Check that everything is working using these commands:

```bash
ssh 'root@167.99.244.46' #connection to server
systemctl status nexus
```

You can login with default credentials `username: admin` and to get password run these commands

```bash
ssh 'root@167.99.244.46' #connection to server
cat /opt/sonatype-work/nexus3/admin.password
```

Check logs using these commands:

```bash
journalctl -u nexus
```