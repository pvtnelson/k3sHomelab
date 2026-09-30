#!/usr/bin/env bash
# Creates the SOPS-encrypted secret `hermes-honcho` (HONCHO_API_KEY) for Hermes.
# The key is a Honcho JWT scoped to workspace "hermes" (no admin rights), minted
# inside the honcho-api pod. It is never printed. Run from anywhere:
#   bash scripts/shell/create-hermes-honcho-secret.sh
# Optional: HONCHO_JWT_EXPIRES=1y bash scripts/shell/create-hermes-honcho-secret.sh
set -euo pipefail

cd "$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

OUT=apps/homelab/hermes/hermes-honcho-secret.yaml
SOPS_CONFIG=clusters/homelab/.sops.yaml
WORKSPACE=hermes

if [[ -e "$OUT" ]]; then
  echo "ERROR: $OUT already exists. Delete it first to rotate the key." >&2
  exit 1
fi

args=(--workspace "$WORKSPACE" --print-only)
[[ -n "${HONCHO_JWT_EXPIRES:-}" ]] && args+=(--expires "$HONCHO_JWT_EXPIRES")

TOKEN=$(kubectl -n hermes exec deploy/honcho-api -- \
  /app/.venv/bin/python scripts/generate_jwt.py "${args[@]}" | tail -n 1 | tr -d '\r')
[[ "$TOKEN" =~ ^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$ ]] || {
  echo "ERROR: did not get a JWT from honcho-api" >&2
  exit 1
}

umask 077
cat > "$OUT" <<EOF
# SOPS-encrypted. Created by scripts/shell/create-hermes-honcho-secret.sh
# HONCHO_API_KEY: Honcho JWT scoped to workspace "$WORKSPACE" (not admin).
# Rotate: delete this file, re-run the script, commit. (Old tokens stay valid until
# AUTH_JWT_SECRET in honcho-secret.yaml changes.)
apiVersion: v1
kind: Secret
metadata:
  name: hermes-honcho
stringData:
  HONCHO_API_KEY: "$TOKEN"
EOF
unset TOKEN

sops --config "$SOPS_CONFIG" -e -i "$OUT"

if grep -E '^\s+HONCHO_API_KEY: ' "$OUT" | grep -qv 'ENC\[AES256_GCM'; then
  echo "ERROR: $OUT is not encrypted, delete it and retry" >&2
  exit 1
fi
echo "OK: $OUT created and encrypted."
