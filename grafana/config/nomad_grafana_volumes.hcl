host_volume "grafana" {
  path      = "/var/lib/grafana"
  read_only = false
}
host_volume "grafana-config" {
  path      = "/etc/grafana"
  read_only = false
}