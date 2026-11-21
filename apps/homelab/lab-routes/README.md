# Lab routes

Internal names for services outside the cluster: `<service>.lab.vandesteeg.dev`.
They resolve only in the local DNS; the wildcard certificate comes from
`infrastructure/configs/homelab/lab-tls`.

Add a service on a machine outside the cluster:

1. If the machine has no Service here yet, add an ExternalName Service pointing
   at its local name (`<machine>.home.arpa`).
2. Add an Ingress with host `<service>.lab.vandesteeg.dev` under `rules` and `tls.hosts`.

No DNS record or certificate step is needed: the wildcard covers every name.
