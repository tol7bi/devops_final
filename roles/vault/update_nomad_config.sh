#!/bin/bash

if [ ! -f /data/vaulttoken.txt ]; then
  echo "Error: /data/vaulttoken.txt not found!"
  exit 1
fi

SERVER_PATH="/data/nomad_server/nomad"
CLIENT_PATH="/data/nomad_client/nomad"

VAULT_TOKEN=$(cat /data/vaulttoken.txt)

# Step 2: Replace the token in the placeholder configuration
TEMP_CONFIG=$(mktemp)
sudo sed "s/token = VAULT_TOKEN/token = \"$VAULT_TOKEN\"/" ./vault_server_placeholder.hcl > "$TEMP_CONFIG"

# Step 3: Update the Nomad server configuration
sudo sed -i "/# VAULT CONFIG PLACEHOLDER/{r $TEMP_CONFIG
d}" $SERVER_PATH

# Clean up the temporary file
rm -f "$TEMP_CONFIG"

CLIENT_CONFIG=$(cat ./vault_client_placeholder.hcl)

# Add the Vault client config to /data/nomad_client/data
sudo sed -i "/# VAULT CONFIG PLACEHOLDER/{r /dev/stdin
d}" $CLIENT_PATH <<< "$CLIENT_CONFIG"

sudo systemctl restart nomad-server.service
sudo systemctl restart nomad-client.service

# Final message
echo "Nomad config updated for Vault"
