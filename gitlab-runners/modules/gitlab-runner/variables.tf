variable "runner_version" {
  description = "The version of the gitlab runner to use."
  type        = string
  default     = "docker-v2.0.0"
}

variable "nomad_datacenter" {
  description = "The datacenter to deploy the gitlab runner to."
  type        = string
  default     = "kbtu-devops-final"
  sensitive   = true
}

variable "gitlab_source" {
  description = "The source of the gitlab instance."
  type        = string
  default     = "https://gitlab.com"
}

variable "admin_token" {
  description = "Owner/Maintainer PAT token with the api scope applied."
  type        = string
  sensitive   = true
}

variable "gitlab_runner_configs" {
  description = "The configuration for the gitlab runners."
  type = map(object({
    type         = string
    group_id     = string
    project_id   = string
    run_untagged = bool
    tag_list     = string
    count        = number
  }))
  default = {
    default = {
      type         = "group"
      group_id     = ""
      project_id   = ""
      run_untagged = true
      tag_list     = ""
      count        = 1
    }
  }
}

