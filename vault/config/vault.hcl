storage "raft" {
  path    = "/vault/data"
  node_id = "node1"
}

listener "tcp" {
  address         = "0.0.0.0:8200"
  tls_cert_file   = "/vault/tls/vault.crt"
  tls_key_file    = "/vault/tls/vault.key"
  tls_min_version = "tls12"
}

api_addr          = "https://vault:8200"
cluster_addr      = "https://vault:8201"
ui                = true
disable_mlock     = false
default_lease_ttl = "1h"
max_lease_ttl     = "720h"
