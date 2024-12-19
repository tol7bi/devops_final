terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.11.0"
    }
  }
}

provider "nomad" {
  address = var.NOMAD_HOST
}

provider "vault" {
  address = var.VAULT_HOST
  token   = trimspace(file("/data/vaultroot.txt"))
}

data "vault_generic_secret" "postgres_db" {
  path = "secret/postgres_db"
}

locals {
  db_name     = data.vault_generic_secret.postgres_db.data["database_name"]
  db_user     = data.vault_generic_secret.postgres_db.data["user"]
  db_password = data.vault_generic_secret.postgres_db.data["password"]
}

resource "nomad_job" "postgresql" {
  jobspec = <<EOT
job "postgres_db" {
  datacenters = ["kbtu"]
  type        = "service"

  group "postgres" {
    count = 1
    task "postgres" {
      driver = "docker"

      config {
        image       = "postgres"
        network_mode = "host"
        port_map {
          db = 5432
        }
      }

      env {
        POSTGRES_USER     = "${local.db_user}"
        POSTGRES_PASSWORD = "${local.db_password}"
        POSTGRES_DB       = "${local.db_name}"
      }

      logs {
        max_files     = 5
        max_file_size = 15
      }

      resources {
        cpu = 1000
        memory = 1024
        network {
          mbits = 10
          port  "db"  {
            static = 5432
          }
        }
      }
    }
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }    
  }
}

EOT
}


output "postgres_host" {
  value = "172.17.0.1"
}

output "postgres_port" {
  value = 5432
}

output "postgres_user" {
  value = local.db_user
  sensitive = true
}
