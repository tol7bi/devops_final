server {
  enabled          = true
  bootstrap_expect = 1
}
datacenter = "kbtu"

data_dir = "/var/lib/nomad_server/data"
advertise {
  http = "{{ GetPrivateIP }}:4646"
  rpc  = "{{ GetPrivateIP }}:4647"
  serf = "{{ GetPrivateIP }}:4648"
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

log_level = "INFO"

# VAULT CONFIG PLACEHOLDER

# CONSUL CONFIG PLACEHOLDER