#!/usr/bin/env bash
set -euo pipefail
echo "[pre-plan] configurando notifications (dinâmico via NOTIFY_CONFIGS_JSON)..."

# Deriva ORG do SLUG se não vier
if [[ -z "${HCP_ORG:-}" && -n "${TFC_WORKSPACE_SLUG:-}" ]]; then
  export HCP_ORG="${TFC_WORKSPACE_SLUG%%/*}"
  echo "[pre-plan] HCP_ORG=${HCP_ORG} (derivada do slug)"
fi

: "${HCP_ORG:?defina HCP_ORG (ou use TFC_WORKSPACE_SLUG)}"
: "${HCP_TF_TOKEN:?defina HCP_TF_TOKEN (Team/Org token)}"
: "${TFC_WORKSPACE_NAME:?fornecida pelo run}"
: "${NOTIFY_CONFIGS_JSON:?defina NOTIFY_CONFIGS_JSON (JSON em 1 linha) no Variable Set}"

# Toggle global
WORKSPACE_NOTIFICATION_ENABLED="${WORKSPACE_NOTIFICATION_ENABLED:-${workspace_notification_enabled:-false}}"
shopt -s nocasematch
if [[ ! "${WORKSPACE_NOTIFICATION_ENABLED}" =~ ^(1|true|yes|on)$ ]]; then
  echo "[pre-plan] WORKSPACE_NOTIFICATION_ENABLED=false -> pulando."
  exit 0
fi
shopt -u nocasematch

# Validação rápida do JSON (usa python3 disponível na imagem)
python3 - <<'PY' >/dev/null 2>&1 || { echo "[pre-plan] JSON inválido em NOTIFY_CONFIGS_JSON"; exit 1; }
import os, json
json.loads(os.environ["NOTIFY_CONFIGS_JSON"])
PY

export HCP_ORG HCP_TF_TOKEN TFC_WORKSPACE_NAME WORKSPACE_NOTIFICATION_ENABLED NOTIFY_CONFIGS_JSON

ansible-playbook -i /home/tfc-agent/.tfc-agent/hooks/scripts/hosts.ini \
  /home/tfc-agent/.tfc-agent/hooks/scripts/notify.yml -v
