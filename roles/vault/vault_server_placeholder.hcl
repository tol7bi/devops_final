vault {
  enabled = true
  address = "http://127.0.0.1:8200/"  
  task_token_ttl = "1h"
  token = VAULT_TOKEN
  tls_skip_verify = true
  create_from_role = "nomad-cluster"
}
