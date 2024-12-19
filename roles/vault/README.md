# HashiCorp Vault

This repository contains ansible playbook for Vault configuration. It will install vault and make configurations,
systemd unit file.

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)
- [Details](#details)

## Pre-requisites

- Ansible installed
- Linux based system in order to create systemd unit files
- HashiCorp Nomad installed and running

## Usage

This section contains step-by-step guide how to setup vault server using ansible.
You can run makefile, before it export vault address and unlock sudo in terminal.
To use this configs locally there is a ready Makefile with the following command. Remember that you should have nomad
installed and running already.

```bash
sudo make start
```

By default it installs nomad on localhost. If you want install nomad configuration on remote server you should
add/replace data about remote server in inventory file:

```bash
remote_server_1 ansible_host=<ip_address> ansible_user=<username> ansible_ssh_private_key_file=<path/to/id_rsa>
```

Check that everything is working using these commands:

```bash
make status
```

Test that nomad can retrieve secrets, start job:

```bash
nomad job run testjob.nomad
```

You should see your hidden secret in output of the job.

## Details

In this section explained how it works more deeply. If you want improve undestanding of vault read it.

Check logs using these commands:

```bash
journalctl -u vault.service
```

Initialize vault using this command and save unseal, root keys. Unseal vault after that and login using root key.

```bash
export VAULT_ADDR=http://127.0.0.1:8200
vault operator init
vault operator unseal
vault login
```

We can use root key actually for nomad integration but it is bad practice , so let`s create special token for nomad.
In order to integrate vault with nomad we need to enable approle and add nomad-cluster role.

```bash
vault secrets enable -path=secret kv
vault kv put secret/mysecrets hello=HelloWorld!
```

Now we need to create role in vault for nomad

```bash
vault auth enable approle
vault policy write -tls-skip-verify nomad-server nomad-server-policy.hcl 
vault write -tls-skip-verify auth/token/roles/nomad-cluster \
  allowed_policies="nomad-server" \
  orphan=true \
  period="1h" \
  renewable=true
```

Create token and add these to nomad server in order he can use vault secrets

```bash
vault token create -policy nomad-server -period 72h -orphan -format json
```

In nomad server:

```hcl
vault {
  enabled          = true
  address          = "http://127.0.0.1:8200/"
  task_token_ttl   = "1h"
  token            = "paste token"
  tls_skip_verify  = true
  create_from_role = "nomad-cluster"
}
```

In nomad client:

```hcl
vault {
  enabled = true
  address = "http://127.0.0.1:8200/"
}
```

Restart nomad:

```bash
sudo systemctl restart nomad-server.service
sudo systemctl restart nomad-client.service
```
