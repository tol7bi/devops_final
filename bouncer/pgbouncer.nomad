job "pgbouncer" {
  datacenters = ["kbtu"]
  type        = "service"

  group "pgbouncer" {
    count = 1

    network {
      port "pgbouncer" {
        to = 6432
      }
    }

    service {
      name = "zadolbal-devops"
      port = "pgbouncer"
      tags = ["pgbouncer", "db"]

      check {
        name     = "tcp-check"
        type     = "tcp"
        port     = "pgbouncer"
        interval = "10s"
        timeout  = "2s"
      }
    }

    vault {
      policies = ["pgbouncer-policy"]
    }

    task "pgbouncer" {
      driver = "docker"

      config {
        image = "bitnami/pgbouncer:latest"
        ports = ["pgbouncer"]
        volumes = [
          "pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini",
          "userlist.txt:/etc/pgbouncer/userlist.txt"
        ]
      }

      template {
        destination = "secrets/envfile"
        env         = true
        data = <<EOH
POSTGRESQL_USERNAME="{{ with secret "secret/data/pgbouncer" }}{{ .Data.user }}{{ end }}"
POSTGRESQL_PASSWORD="{{ with secret "secret/data/pgbouncer" }}{{ .Data.password }}{{ end }}"
EOH
      }

      env {
        POSTGRESQL_USERNAME     = "${POSTGRESQL_USERNAME}"
        POSTGRESQL_PASSWORD = "${POSTGRESQL_PASSWORD}"
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
