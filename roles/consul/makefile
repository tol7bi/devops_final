setup_consul: 
		@echo "Setting up consul and configuring systemd file"
		@ansible-playbook consul_playbook.yml --become
		@bash update_nomad_config.sh
		@consul services register vault_service.hcl

run_consul:
		@echo "Running consul..."
		@sudo systemctl start consul-server.service

test_job:
		@consul kv put hello HelloFromConsul
		@echo "You will see HelloFromConsul"
		@nomad job run testjob.nomad

status_server:
		@sudo systemctl status consul-server.service

stop_consul:
		@sudo systemctl stop consul-server.service