t Project Guide: k3sHomelab

## 1. Project Overview
This project manages a **k3s homelab** environment using **GitOps** principles. The infrastructure and applications are deployed and managed via **FluxCD**, ensuring that the cluster state always matches the configuration stored in this repository.

### Key Technologies
- **Orchestration:** k3s (Lightweight Kubernetes)
- **GitOps Engine:** FluxCD
- **Configuration Management:** Kustomize
- **Secret Management:** SOPS (Secrets Operations)
- **Applications:** Linkding, Audiobookshelf (and others to be added)

## 2. Getting Started

### Prerequisites
- A running k3s cluster.
- FluxCD installed on the cluster.
- `kubectl` configured to point to your cluster.
- `flux` CLI installed locally.
- `sops` and `age` installed for secret decryption.

### Installation & Setup
1. **Cluster Preparation:** Ensure k3s is running and FluxCD is initialized.
2. **Repository Connection:** Connect this repository to FluxCD as a source.
3. **Secrets:** Ensure your SOPS keys are correctly configured in your local environment to decrypt secrets during the deployment process.

### Basic Usage
- To deploy a new application, add its configuration to `apps/homelab/`.
- To update an existing application, modify the corresponding Kustomize files in `apps/homelab/`.
- FluxCD will automatically detect changes and reconcile the cluster state.

## 3. Project Structure
- `apps/`: Contains Kustomize configurations for all applications.
    - `base/`: Common base configurations shared across environments.
    - `homelab/`: Environment-specific overrides for the homelab cluster (e.g., `linkding`, `audiobookshelf`).
- `clusters/`: Cluster-specific configuration files.
    - `homelab/`: Configuration specifically for the homelab k3s cluster, including Flux Kustomizations (`apps.yaml`, `monitoring.yaml`) and SOPS-encrypted secrets.
- `monitoring/`: Configuration for monitoring tools (e.g., Prometheus, Grafana).
- `scripts/`: Utility scripts for automation and maintenance.

## 4. Development Workflow
- **Coding Standards:** Use Kustomize for all configuration changes. Avoid manual `kubectl apply` commands where possible; always commit changes to the repository.
- **Testing:** Verify configurations by checking FluxCD reconciliation status: `flux get kustomizations`.
- **Deployment:** Changes are deployed automatically by FluxCD upon merging into the main branch (or the branch configured as the source).

## 5. Key Concepts
- **GitOps:** The core philosophy where the Git repository is the "Source of Truth."
- **Kustomize:** Used to manage Kubernetes manifests without using complex templates.
- **SOPS:** Used to encrypt sensitive values (secrets) within the YAML files while keeping them in version control. **No plaintext passwords are allowed in the repository.**
- **Cloudflare Tunnels:** Used to securely expose applications to the public internet without opening firewall ports.

## 6. Common Tasks
### Adding a New Application
1. Create a new directory in `apps/homelab/<app-name>`.
2. Define the `kustomization.yaml` and necessary resource manifests.
3. If secrets are needed, create them using SOPS. **Never store plaintext passwords.**
4. Configure Cloudflare Tunnel for public access if required (e.g., Stage 3 of Audiobookshelf).
5. Ensure the application is referenced in the main `apps.yaml` or relevant Kustomization.

### Updating an Existing Application
1. Modify the YAML files in `apps/homelab/<app-name>`.
2. Commit and push changes.
3. Monitor the sync status using `flux get kustomizations`.

## 7. Troubleshooting
- **Sync Issues:** Check FluxCD logs: `flux logs --all`.
- **Secret Decryption Errors:** Ensure your `sops` environment is correctly configured with the appropriate keys.
- **Kustomize Errors:** Validate your Kustomize files locally using `kubectl kustomize <path>`.

## 8. References
- [FluxCD Documentation](https://fluxcd.io)
- [k3s Documentation](https://k3s.io)
- [SOPS Documentation](https://github.com/getsops/sops)

## 9. Application Details

### Linkding
- **Access:** Public via Cloudflare Tunnel
- **Port:** 9090
- **Storage:** 1 PVC (data)
- **Security:** Non-root (UID 33, www-data)

### Audiobookshelf
- **Access:** Internal only (ClusterIP)
- **Port:** 3005 (configured via ConfigMap)
- **Storage:** 3 PVCs — data (10Gi), metadata (2Gi), config (1Gi)
- **Security:** Non-root (UID/GID 1000, node user), privilege escalation disabled

## 10. Architecture Decisions
- **Public vs Internal:** Not all applications require public access. Use Cloudflare Tunnels only when explicitly needed. Default to ClusterIP (internal only).
- **README:** The README is public-facing. Do not expose internal details such as ports, UIDs, storage sizes, or infrastructure specifics.

