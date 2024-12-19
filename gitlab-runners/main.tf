terraform {
  required_version = ">= 1.0.0"

  required_providers {
    nomad = {
      source = "hashicorp/nomad"
    }
  }
  backend "http" {
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}

provider "nomad" {
  address = var.NOMAD_HOST
}

variable "NOMAD_HOST" {
  type        = string
  description = "The address of the nomad host."
  default     = "http://localhost:4646"
}

variable "NOMAD_DATACENTER" {
  type        = string
  description = "The datacenter of the nomad host."
  default     = "kbtu"
}

variable "GITLAB_RUNNER_VERSION" {
  type    = string
  default = "docker-v2.0.0"
}

variable "GITLAB_RUNNERS_CONFIG" {
  description = "The configuration for the gitlab runners."
  type = map(object({
    type         = string
    group_id     = string
    project_id   = string
    run_untagged = bool
    tag_list     = string
    count        = number
  }))
  default = {}
}

variable "GITLAB_SOURCE" {
  type        = string
  description = "The source of the gitlab instance."
  default     = "https://gitlab.com"
}

variable "GITLAB_ADMIN_TOKEN" {
  type        = string
  description = "Owner/Maintainer PAT token with the api scope applied."
  sensitive   = true
}

module "gitlab-runner" {
  source                = "./modules/gitlab-runner"
  runner_version        = var.GITLAB_RUNNER_VERSION
  gitlab_runner_configs = var.GITLAB_RUNNERS_CONFIG
  admin_token           = var.GITLAB_ADMIN_TOKEN
  gitlab_source         = var.GITLAB_SOURCE
  nomad_datacenter      = var.NOMAD_DATACENTER
}