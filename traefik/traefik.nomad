job "traefik" {
  datacenters = ["kbtu"]
  type        = "system"

  group "traefik" {
    network {
      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }

      port "traefik" {
        static = 8080
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:v2.10.7"
        volumes = [
          "local/traefik.yml:/etc/traefik/traefik.yml",
          "local/traefik-dynamic.yml:/etc/traefik/traefik-dynamic.yml",
          "/var/run/docker.sock:/var/run/docker.sock"
        ]
        ports = ["http", "https", "traefik"]
      }

      # Main Traefik configuration
      template {
        destination = "local/traefik.yml"
        data        = <<EOF
global:
  checkNewVersion: true
  sendAnonymousUsage: false

log:
  level: INFO

api:
  dashboard: true
  insecure: true

providers:
  docker:
    exposedByDefault: false
  file:
    filename: /etc/traefik/traefik-dynamic.yml

entryPoints:
  http:
    address: ":80"
  https:
    address: ":443"
  traefik:
    address: ":8080"
EOF
      }

      # Dynamic configuration for routing
      template {
        destination = "local/traefik-dynamic.yml"
        data        = <<EOF
http:
  routers:
    # Traefik dashboard router
    traefik-dashboard:
      rule: "PathPrefix(`/dashboard`) || PathPrefix(`/api`)"
      service: "api@internal"
      entrypoints: 
        - "traefik"

  services:
    # Default catch-all service
    default:
      loadBalancer:
        servers:
          - url: "http://localhost:8080"
EOF
      }

      resources {
        cpu    = 500 # 0.5 CPU
        memory = 256 # 256MB RAM
      }

      # Multiple service checks for different ports
      service {
        name = "traefik"
        tags = ["traefik", "proxy"]
        port = "http"

        check {
          name     = "Traefik Dashboard Health Check"
          type     = "http"
          path     = "/dashboard/"
          port     = "traefik"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
