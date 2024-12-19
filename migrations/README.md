# gitlab-ci.yml Flyway migrations on a containerzed PostgreSQL database on Nomad

This repository contains the Terraform configuration to deploy a PostgreSQL database on Nomad, and run the fylway migrations using the .gitlab-ci.yml. 
## Contents
- [Criteria for the task](#criteria-for-the-task)
- [Pre-requisites](#pre-requisites)
- [Usage](#usage)
  - [Local Usage](#local-usage)
  - [Gitlab CI/CD Usage](#gitlab-cicd-usage)
- [CI/CD Explanation](#cicd-explanation)
  - [Prepare stage](#prepare-stage)
  - [Migrate stage](#migrate-stage)
  - [Validate stage](#validate-stage)
  - [Expected behavior](#expected-behavior)
      

## Criteria for the task

- /migrations directory is created in the mono-repository.
- PostgreSQL database is provisioned on Nomad as a containerized service
- Key connection details (host, port, username) are exported as Terraform outputs
- Flyway is configured to connect to PostgreSQL using securely managed credentials retrieved from Vault
- Rollback mechanism is implemented and verified
- Rollback safely reverts applied changes
- CI/CD pipeline automates Flyway commands (validate, migrate, rollback)
- (Current version doesn't support) Pipeline correctly handles pre-existing databases without overwriting tables or schemas. Scripts are idempotent and safe for databases with existing data or structure

## Pre-requisites

- Terraform installed on your local machine
- A HashiCorp Nomad cluster up and available on your network by following this [Documentation](roles/nomad/README.md)
- A Vault insance up and available on your network by following this [Documentation](roles/vault/README.md)
- A local runner in your working project, configured to work with `flyway` tag, set up using this [Documentation](gitlab-runners\README.md)

## Usage

This section contains step-by-step guide how to use this repository to deploy a PostgreSQL database on Nomad, and run the fylway migration

### Local Usage

To setup this project successfully there is a ready Makefile with the following commands:

- `start`: Runs `create_secrets` `setup_db`
- `create_secrets`: Puts necessary secrets into Vault
- `setup_db`: Runs the nomad job using terraform to create a PostgreSQL container on 172.17.0.1:5432

After running `make start` you can see the job at `localhost:4646`. You can view the code used to setup the db in `db_setup` folder, specifically the `main.tf`

### Gitlab CI/CD Usage

To use the `.gitlab-ci.yml` you need to have a runner that executes jobs with `flyway` tag, and from the previous stage run `make start`  (or `make setup_db` if you have the vault secrets). To run the pipeline make any change to any file in migrations, and commit and push it.

## CI/CD explanation

There are the following stages: 
1. `prepare`: load secrets from Vault to environmet
2. `migrate`: apply flyway migrations
3. `validate`: validate that migrations were correct
4. `rollback`: manual, reverse the migrations

### Prepare stage
This stage installs Vault to enable the runner to run Vault commands. Then it exports the `VAULT_TOKEN`, which is stored inside CI/CD variables (`VAULT_ROOT_TOKEN`) and `VAULT_ADDR`. Then it gets the sercrets from Vault and puts them in a `key=value` style into migrations/vault.env, which is empty by default. This syntax allows to apply this file as environmental variables to all the following jobs:

```yml
artifacts:
    reports:
      dotenv: migrations/vault.env
```

### Migrate stage
In migrate I built a custom-flyway:latest, because i faced a problem of passing `migrations/sql` to the basic flyway image, so i passed it in Dockerfile. Then i run `flyway migrate` with all necessary arguments and it migrates the `*.sql` files from `migrations/sql`.

### Validate stage
In validate i do all the same as in migrate, but run `flyway validate`, and i don't build the image, because it is accessible from the previous stage.

### Rollback stage
There is a `flyway undo` command, but it is accessible only in paid versions of flyway, so the only option left is to run sql commands to undo the applied migrations. I wrote the `.sql` files in `migrations/rollback` to undo the migrations from `migrations/sql`. In rollback stage i install the `postgresql-client`. Then i run each script from `rollback` using `psql`. Then i run `DELETE FROM flyway_schema_history;` to reset versioning for flyway. If i don't do that, it will remember that the latest version of migrations was `V5` and will not recieve updates from anything with lower versions.

### Expected behavior
After executing the pipeline, it should apply the migrations, validate them without issue and you can manually trigger rollback to reset the migrations, so that you could rerun the pipeline with the same migrations.