
GITLAB_SOURCE = https://gitlab.com
GITLAB_TF_STATE_PROJECT = 65232891
GITLAB_TF_STATE_NAME = terraform-gitlab-runner-nomad-state
GITLAB_ADMIN_NAME =
GITLAB_ADMIN_TOKEN =

tf_init:
	terraform init -migrate-state -upgrade \
	-backend-config="address=${GITLAB_SOURCE}/api/v4/projects/${GITLAB_TF_STATE_PROJECT}/terraform/state/${GITLAB_TF_STATE_NAME}" \
	-backend-config='lock_address=${GITLAB_SOURCE}/api/v4/projects/${GITLAB_TF_STATE_PROJECT}/terraform/state/${GITLAB_TF_STATE_NAME}/lock' \
	-backend-config='unlock_address=${GITLAB_SOURCE}/api/v4/projects/${GITLAB_TF_STATE_PROJECT}/terraform/state/${GITLAB_TF_STATE_NAME}/lock' \
	-backend-config='username=${GITLAB_ADMIN_NAME}' \
	-backend-config='password=${GITLAB_ADMIN_TOKEN}'

tf_plan:
	terraform plan -var-file=default.tfvars

tf_apply:
	terraform apply -var-file=default.tfvars

tf_destroy:
	terraform destroy -var-file=default.tfvars