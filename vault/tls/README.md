# TLS-Zertifikate

Vault benötigt drei Dateien in diesem Verzeichnis:

| Datei       | Inhalt                          |
|-------------|---------------------------------|
| `ca.crt`    | CA-Zertifikat (PEM)             |
| `vault.crt` | Server-Zertifikat (PEM)         |
| `vault.key` | Privater Schlüssel (PEM, 0600)  |

---

## Option A — selbstsigniert (Lab / Test)

```bash
cd tls/

# CA erzeugen
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -out ca.crt -subj "/CN=Vault Lab CA"

# Server-Schlüssel + CSR
openssl genrsa -out vault.key 4096
openssl req -new -key vault.key \
  -out vault.csr -subj "/CN=vault"

# SAN-Erweiterung
cat > vault.ext <<EOF
[v3_req]
subjectAltName = DNS:vault, DNS:localhost, IP:127.0.0.1
EOF

# Vault-Zertifikat durch CA signieren
openssl x509 -req -in vault.csr -CA ca.crt -CAkey ca.key \
  -CAcreateserial -out vault.crt -days 825 -sha256 \
  -extfile vault.ext -extensions v3_req

chmod 600 vault.key ca.key
rm vault.csr vault.ext
```

## Option B — Produktion (EJBCA / Let's Encrypt / intern)

- CN und mindestens ein SAN müssen dem Hostnamen entsprechen, unter dem Vault
  erreichbar ist (z. B. `vault.intern`, `secrets.example.com`).
- Das `ca.crt` auf allen Clients hinterlegen, die mit Vault kommunizieren,
  oder in den System-Truststore importieren.
