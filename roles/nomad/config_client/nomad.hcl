client {
  enabled = true
  servers = ["127.0.0.1:4647"]
  # GRAFANA CONFIG PLACEHOLDER
}

ui {
  enabled = false
}

datacenter = "kbtu"
data_dir   = "/var/lib/nomad_client/data"
bind_addr  = "0.0.0.0"
log_level  = "INFO"

ports {
  http = 4649
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

plugin "docker" {
  config {
    allow_privileged = true
    volumes {
      enabled = true
    }
  }
}

# VAULT CONFIG PLACEHOLDER