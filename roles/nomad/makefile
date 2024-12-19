JOB_NAME ?= ""

setup_nomad:
		@echo "Setting up nomad server and client and configuring systemd files"
		@ansible-playbook -i inventory nomad_playbook.yml --become

run_job:
		@if [ -z "$(JOB_NAME)" ]; then \
		    echo "Error: JOB_NAME must be provided."; \
		    exit 1; \
		fi
		@echo "Running Nomad job: $(JOB_NAME)"
		@nomad job validate ./$(JOB_NAME)
		@nomad job run ./$(JOB_NAME)

run_nomad:
	  @sudo systemctl start nomad-server.service
	  @sudo systemctl start nomad-client.service

statuses:
	  @sudo systemctl status nomad-server.service
	  @sudo systemctl status nomad-client.service

stop_nomad:
	  @sudo systemctl stop nomad-server.service
	  @sudo systemctl stop nomad-client.service