resource "nomad_job" "gitlab-runner-module-config" {
  for_each = var.gitlab_runner_configs

  jobspec = templatefile("${path.module}/gitlab-runner.nomad", {
    ID                  = each.key
    DATACENTER          = var.nomad_datacenter
    VERSION             = var.runner_version
    COUNT               = each.value.count
    GITLAB_SOURCE       = var.gitlab_source
    GROUP_ID            = each.value.group_id
    PROJECT_ID          = each.value.project_id
    RUN_UNTAGGED        = tostring(each.value.run_untagged)
    TAG_LIST            = each.value.tag_list
    GITLAB_ACCESS_TOKEN = var.admin_token
  })
}
