job "gitlab-runner-${ID}" {
  datacenters = ["${DATACENTER}"]
  type        = "service"
  group "gitlab-runner" {
    count = "${COUNT}"

    task "gitlab-runner" {
      driver = "docker"

      env {
        GITLAB_SOURCE       = "${GITLAB_SOURCE}"
        GROUP_ID            = "${GROUP_ID}"
        PROJECT_ID          = "${PROJECT_ID}"
        RUN_UNTAGGED        = "${RUN_UNTAGGED}"
        TAG_LIST            = "${TAG_LIST}"
        GITLAB_ACCESS_TOKEN = "${GITLAB_ACCESS_TOKEN}"
      }

      config {
        image = "danilakhlebokazov/gitlab-runner:${VERSION}"

        mounts = [
          {
            type   = "bind",
            source = "/var/run/docker.sock",
            target = "/var/run/docker.sock",
          },
        ]

        extra_hosts = [
          "host.docker.internal:host-gateway"
        ]
      }
    }
  }
}
