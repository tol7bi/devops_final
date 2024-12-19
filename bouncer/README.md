# Deploying PgBouncer on HashiCorp Nomad with Consul Integration

This guide explains how to deploy PgBouncer as a connection pooler for PostgreSQL on HashiCorp Nomad. It includes integration with Consul for service discovery and registration, as well as automation using GitLab CI/CD.

## Prerequisites

1. HashiCorp Nomad - Installed and configured.
2. HashiCorp Consul - Installed and configured for service discovery.
3. HashiCorp Vault - Installed and configured for storing sensitive credentials.
4. PostgreSQL - Database instance ready and accessible.

### Setting Up PostgreSQL Temporary Database

sudo -u postgres psql

Inside the PostgreSQL shell:

CREATE DATABASE auth_db;
CREATE USER auth_user WITH PASSWORD 'auth_password';
GRANT ALL PRIVILEGES ON DATABASE auth_db TO auth_user;

INSERT INTO secrets (username, secret) VALUES ('admin', 'admin-secret'), ('alice', 'alice-secret');

GRANT ALL PRIVILEGES ON TABLE secrets TO auth_user;
ALTER TABLE secrets OWNER TO auth_user;
GRANT USAGE ON SCHEMA public TO auth_user;

## Deployment Instructions

1. Verify Nomad, Vault and Consul Setup
   Ensure Nomad, Vault and Consul are running and accessible.

 ```bash  
   sudo systemctl status nomad-server.service
   sudo systemctl status consul-server.service
   sudo systemctl status vault.service
```

2. Check if Pgbouncer policy and secrets were created in Vault

```bash
   vault read auth/token/roles/nomad-cluster
   vault kv get secret/pgbouncer
   vault kv get secret/data/pgbouncer
```

3. Deploy PgBouncer
   Run the Nomad job:

```bash
   nomad run /bouncer/pgbouncer.nomad
```
   

4. Validate Service Registration
   Check if the service is registered in Consul:

```bash
   consul catalog services
```
   

## Cleanup

To stop the PgBouncer service, run:

```bash
nomad stop pgbouncer