# k3sHomelab
Running my k3s homelab maintained via GitOps

## Setup
- k3s cluster (3 nodes)
- FluxCD
- Kustomize (base/overlay pattern)
- SOPS with age encryption

## Applications
- [Homepage](https://gethomepage.dev) — Dashboard at `home.vandesteeg.dev`
- [Linkding](https://github.com/sissbruecker/linkding) — Bookmark manager at `linkding.vandesteeg.dev`
- [Audiobookshelf](https://www.audiobookshelf.org) — Audiobook library at `audiobookshelf.vandesteeg.dev`

## Infrastructure
- cert-manager — TLS certificates via Let's Encrypt (DNS-01 / Cloudflare)
- Cloudflare Tunnel — Shared tunnel for public-facing services
- Traefik — Ingress controller (k3s default)

## Monitoring
- Prometheus
- Grafana at `grafana.vandesteeg.dev`

