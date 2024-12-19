# Gitlab Runner on HashiCorp Nomad using Terraform

This repository contains the Terraform configuration to deploy a Gitlab Runner on HashiCorp Nomad.

## Contents

- [Pre-requisites](#pre-requisites)
- [Usage](#usage)
    - [Local Usage](#local-usage)
    - [Gitlab CI/CD Usage](#gitlab-cicd-usage)
- [Configuration](#configuration)

## Pre-requisites

- Terraform installed on your local machine
- A HashiCorp Nomad cluster up and available on your network
- An account on Gitlab with needed permissions to create a new runner

## Usage

This section contains step-by-step guide how to use this repository to deploy a Gitlab Runner on HashiCorp Nomad.

### Local Usage

To use this configs locally there is a ready Makefile with the following commands:

- `tf_init`: Initialize Terraform

*Note that for initializing Terraform you need to provide the following environment variables:*

```dotenv
GITLAB_SOURCE = https://gitlab.com  # change that if you have self-hosted Gitlab
GITLAB_TF_STATE_PROJECT =  # Gitlab project where Terraform state will be stored
GITLAB_TF_STATE_NAME =  # Name of the Terraform state file
GITLAB_ADMIN_NAME =  # Gitlab admin username
GITLAB_ADMIN_TOKEN =  # Gitlab admin token with API enabled
```

- `tf_plan`: Plan the Terraform deployment
- `tf_apply`: Apply the Terraform deployment
- `tf_destroy`: Destroy the Terraform deployment

### Gitlab CI/CD Usage

To use this repository in Gitlab CI/CD you need to create a new project in your Gitlab instance and push this repository
to it. Then you need to create the following environment variables in your Gitlab project:

```dotenv
TF_VAR_NOMAD_HOST = http://localhost:4646 # Nomad host
GITLAB_TF_VAR_FILE = deafult.tfvars # Terraform variables file
GITLAB_TF_STATE_NAME = gitlab-runner # Terraform state name
TF_VAR_GITLAB_ADMIN_TOKEN =  # Gitlab admin token
TF_VAR_GITLAB_ADMIN_USERNAME =  # Gitlab admin username
```

In the repository you can find a `.gitlab-ci.yml` file that uses official terraform docker image and provides the following stages:

- `validate`
- `plan`
- `apply`

Also note that in order to run the pipeline you need to create a runner with `terraform` tag.

A good practise to apply initial configuration locally to create a runner with `terraform` tag and then run the
pipeline.

## Configuration

To configure the Gitlab Runners you need to provide a configuration through `.tfvars` file.

The configuration should be in the following format:

```hcl
GITLAB_RUNNERS_CONFIG = {
  runner_name = {
    type         = "group" | "project",
    group_id     = "xxx", # need if type is group
    project_id   = "xxx", # need if type is project
    run_untagged = true | false, # run untagged jobs
    tag_list     = "tag1,tag2", # in case if run_untagged is false
    count        = 1 # number of runners
  }
}
```

Example:

```hcl
GITLAB_RUNNERS_CONFIG = {
  tf-main = {
    type = "group", group_id = "xxx", project_id = "", run_untagged = true, tag_list = "terraform", count = 1
  }
}
```

## Module Input Variables

You can also use the module separately in your Terraform configuration. The module has the following input variables:

- `runner_version` - Version of the Gitlab Runner by danilakhlebokazov to deploy
- `nomad_datacenter` - Name of the Nomad datacenter
- `gitlab_source` - Source of the Gitlab instance
- `admin_token` - Gitlab admin token
- `gitlab_runner_configs` - Configuration of the Gitlab Runners

## Gitlab Runner Docker image

This repo also provides a Dockerfile to build a custom Gitlab Runner image that allows to automate registration and deletion of the runner.

If you want to extend the image or change the behavior you can easily modify it.