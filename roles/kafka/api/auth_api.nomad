job "auth_api" {
  datacenters = ["dc1"]

  group "api_group" {
    count = 3

    network {
      port "http" {
        static = 8080
      }
    }

    task "auth_task" {
      driver = "docker"

      config {
        image = "auth-api:latest"
        ports = ["http"]
      }

      env {
        POSTGRES_DB           = "auth_db"
        POSTGRES_USER         = "auth_user"
        POSTGRES_PASSWORD     = "auth_password"
        POSTGRES_HOST         = "postgres"
        KAFKA_BOOTSTRAP_SERVERS = "kafka:9092"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
