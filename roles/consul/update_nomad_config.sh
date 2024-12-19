#! /bin/bashs

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Exit on error
set -e

# Check if the file exists
if [ ! -f /data/nomad_server/nomad ]; then
  echo "Nomad config file not found"
  exit 1
fi

# Check if the file contains the placeholder
if ! grep -q "# CONSUL CONFIG PLACEHOLDER" /data/nomad_server/nomad; then
  echo "Nomad config file does not contain the placeholder"
  exit 0
fi

# Replace the placeholder with the actual config
sed -i "/# CONSUL CONFIG PLACEHOLDER/{r ./consul_server_placeholder.hcl
d}" /data/nomad_server/nomad
echo "Nomad config updated for Consul"

# restart service
systemctl restart nomad-server.service

systemctl status nomad-server.service
