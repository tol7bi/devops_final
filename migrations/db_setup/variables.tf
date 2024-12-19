variable "NOMAD_HOST" {
  type        = string
  description = "The address of the Nomad host."
  default     = "http://localhost:4646"
}

variable "VAULT_HOST" {
  type        = string
  description = "The address of the Vault host."
  default     = "http://localhost:8200"
}