variables {
  grafana_gitlab_client_id     = ""
  grafana_gitlab_client_secret = ""
  grafana_github_client_id     = ""
  grafana_github_client_secret = ""
  grafana_google_client_id     = ""
  grafana_google_client_secret = ""
  grafana_admin_user           = "admin"
  grafana_admin_password       = "admin"
  grafana_root_url             = "http://grafana.service.devops.org:3000"
}

job "grafana" {
  datacenters = ["kbtu"]
  type        = "service"

  group "grafana" {
    count = 1

    task "grafana" {
      driver = "docker"

      volume_mount {
        volume      = "grafana-data"
        destination = "/var/lib/grafana"
        read_only   = false
      }

      volume_mount {
        volume      = "grafana-config"
        destination = "/etc/grafana"
        read_only   = true
      }

      config {
        image = "grafana/grafana-enterprise:latest"
        ports = ["http"]
      }

      env {
        GF_AUTH_GITLAB_CLIENT_ID     = var.grafana_gitlab_client_id
        GF_AUTH_GITLAB_CLIENT_SECRET = var.grafana_gitlab_client_secret
        GF_AUTH_GITHUB_CLIENT_ID     = var.grafana_github_client_id
        GF_AUTH_GITHUB_CLIENT_SECRET = var.grafana_github_client_secret
        GF_AUTH_GOOGLE_CLIENT_ID     = var.grafana_google_client_id
        GF_AUTH_GOOGLE_CLIENT_SECRET = var.grafana_google_client_secret
        GF_SECURITY_ADMIN_USER       = var.grafana_admin_user
        GF_SECURITY_ADMIN_PASSWORD   = var.grafana_admin_password
        GF_SERVER_ROOT_URL           = var.grafana_root_url
      }

      resources {
        cpu    = 600
        memory = 256
      }

      service {
        name = "grafana"
        port = "http"

        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    network {
      port "http" {
        static = 3000
      }
    }

    volume "grafana-data" {
      type      = "host"
      read_only = false
      source    = "grafana"
    }
    volume "grafana-config" {
      type      = "host"
      read_only = true
      source    = "grafana-config"
    }
  }
}