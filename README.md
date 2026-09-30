# k3sHomelab
Running my k3s homelab maintained via GitOps

## Setup
- k3s cluster (3 nodes)
- FluxCD
- Kustomize (base/overlay pattern)
- SOPS with age encryption

## Applications
- [Homepage](https://gethomepage.dev) — Dashboard 
- [Linkding](https://github.com/sissbruecker/linkding) — Bookmark manager
- [Audiobookshelf](https://www.audiobookshelf.org) — Audiobook library
- Website — Personal site at `vandesteeg.dev`
- [Hermes Agent](https://hermes-agent.nousresearch.com) — AI agent 
- [Multica](https://github.com/multica-ai/multica) — Agent task board
- [Honcho](https://github.com/plastic-labs/honcho) — Long-term memory service for Hermes


## Infrastructure
- cert-manager — TLS certificates via Let's Encrypt (DNS-01 / Cloudflare)
- Cloudflare Tunnel — Shared tunnel for public-facing services
- Traefik — Ingress controller (k3s default)
- Shared Postgres (pgvector) for Honcho + Multica, with nightly backups to the NAS

## Monitoring
- Prometheus
- Grafana at `grafana.vandesteeg.dev`

