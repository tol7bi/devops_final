# this sets up all the requirements for running the .gitlab-ci.yml
start: create_secrets setup_db

# Run this to put secrets into vault, single use command
create_secrets:
	@export VAULT_ADDR="http://localhost:8200"\
	export VAULT_TOKEN=$(cat /data/vaultroot.txt)\
	vault kv put secret/postgres_db user="postgres" password="pass" database_name="postgres"

# Run this to have a postgresql container running on nomad and accessible on 172.17.0.1:5432 \
also you can use it to apply new configurations, if you changed the main.tf
setup_db:
	@echo "Running terraform to setup a postgres container on nomad"
	@cd db_setup && \
	terraform init && \
	terraform apply -auto-approve