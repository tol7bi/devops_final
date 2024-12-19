job "authorization-api" {
  datacenters = ["kbtu"]
  type        = "service"

  group "api-group" {
    count = 3

    network {
      port "http" {
        static = 8000
      }
    }

    task "fastapi-task" {
      driver = "docker"

      config {
        image = "${DOCKER_REGISTRY}:${IMAGE_TAG}"
        ports = ["http"]
      }

      env {
        DB_HOST = "127.0.0.1"
        DB_PORT = "5432"
        DB_NAME = "auth_db"
        DB_USER = "auth_user"
        DB_PASS = "auth_password"
        KAFKA_BOOTSTRAP_SERVERS = "localhost:9092"
        KAFKA_USERNAME = "admin"
        KAFKA_PASSWORD = "admin-secret"
      }

      resources {
        cpu    = 500
        memory = 256
      }

      service {
        name = "authorization-api"
        port = "http"

        check {
          type     = "http"
          path     = "/docs"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
