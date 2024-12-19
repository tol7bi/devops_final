datacenter = "kbtu"
data_dir   = "/var/lib/consul_server/data"
log_level  = "INFO"
node_name  = "node-1"

bootstrap = true
server    = true

bind_addr   = "127.0.0.1"
client_addr = "0.0.0.0"
alt_domain  = "devops.org"

ui_config {
  enabled = true
}