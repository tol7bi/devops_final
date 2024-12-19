export VAULT_ADDR=http://127.0.0.1:8200

start: setup_vault run_vault init_vault unseal_vault login_vault enable_secret

setup_vault:
		@echo "Setting up vault and configuring systemd file"
		@ansible-playbook -i inventory vault_playbook.yml --become

run_vault:
		@echo "Running vault..."
		@sudo systemctl start vault.service

status:
		@sudo systemctl status vault.service

stop_vault:
		@echo "Stopping vault..."
		@sudo systemctl stop vault.service

init_vault:
	@echo "Initializing Vault..."
	@vault operator init -key-shares=1 -key-threshold=1 -format=json > /tmp/vault-init-output.json
	@echo "Extracting unseal key and root token..."
	@sudo jq -r '.unseal_keys_b64[0]' /tmp/vault-init-output.json | sudo tee /data/vaultkey.txt
	@sudo jq -r '.root_token' /tmp/vault-init-output.json | sudo tee /data/vaultroot.txt
	@echo "Vault initialized. Keys saved to /data/vaultkey.txt and /data/vaultroot.txt."
	@rm -f /tmp/vault-init-output.json

unseal_vault:
	@echo "Unsealing Vault..."
	@if [ -f /data/vaultkey.txt ]; then \
		unseal_key=$$(cat /data/vaultkey.txt); \
		vault operator unseal $$unseal_key; \
		echo "Vault unsealed successfully."; \
	else \
		echo "Error: /data/vaultkey.txt not found! Ensure the unseal key is available."; \
		exit 1; \
	fi

login_vault:
	@echo "Logging into Vault..."
	@if [ -f /data/vaultroot.txt ]; then \
		root_token=$$(cat /data/vaultroot.txt); \
		vault login $$root_token; \
		echo "Logged into Vault successfully."; \
	else \
		echo "Error: /data/vaultroot.txt not found! Ensure the root token is available."; \
		exit 1; \
	fi

enable_secret:
	@echo "Checking if KV secrets engine is enabled..."
	@if ! vault secrets list | grep -qE '^secret.*kv'; then \
		echo "KV secrets engine is not enabled. Enabling it now..."; \
		vault secrets enable -path=secret kv; \
		echo "KV secrets engine enabled at path 'secret'."; \
	else \
		echo "KV secrets engine is already enabled at path 'secret'."; \
	fi

	@echo "Adding secret for PgBouncer..."
	@vault kv put secret/pgbouncer user="auth_user" password="auth_password"

	@echo "Checking if AppRole auth method is enabled..."
	@if ! vault auth list | grep -qE '^approle.*approle'; then \
		echo "AppRole auth method is not enabled. Enabling it now..."; \
		vault auth enable approle; \
		echo "AppRole auth method enabled successfully."; \
	else \
		echo "AppRole auth method is already enabled."; \
	fi

	@echo "Creating pgbouncer-policy..."
	@echo 'path "secret/data/pgbouncer" { capabilities = ["read"] }' > pgbouncer-policy.hcl
	@vault policy write -tls-skip-verify pgbouncer-policy pgbouncer-policy.hcl

	@echo "Creating nomad-server policy..."
	@vault policy write -tls-skip-verify nomad-server nomad-server-policy.hcl

	@echo "Updating role 'nomad-cluster' to include pgbouncer-policy..."
	@vault write -tls-skip-verify auth/token/roles/nomad-cluster \
	  allowed_policies="nomad-server,pgbouncer-policy" \
	  orphan=true \
	  period="1h" \
	  renewable=true

	@echo "Creating Vault token for Nomad..."
	@vault token create -policy=nomad-server -period=72h -orphan -format=json | sudo tee /tmp/vault-token-output.json 2>&1 >/dev/null
	@if [ -f /tmp/vault-token-output.json ]; then \
		sudo jq -r '.auth.client_token' /tmp/vault-token-output.json | sudo tee /data/vaulttoken.txt; \
		echo "Vault token saved successfully to /data/vaulttoken.txt."; \
		sudo rm -f /tmp/vault-token-output.json; \
	else \
		echo "Error: Failed to create Vault token or save output."; \
		exit 1; \
	fi

	@echo "Updating Nomad configuration..."
	@sudo bash update_nomad_config.sh

	@echo "Vault configuration complete!"
