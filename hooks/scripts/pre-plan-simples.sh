#!/usr/bin/env bash
set -euo pipefail
echo "[pre-plan] iniciando configuração simples de notification..."

# ===== Defaults (Workspace/VarSet pode sobrescrever) =====
HCP_ORG="${HCP_ORG:-sua-org}"
HCP_TF_TOKEN="${HCP_TF_TOKEN:-seu-team-ou-org-token}"
TFC_WORKSPACE_NAME="${TFC_WORKSPACE_NAME:-seu-workspace}"

NOTIFY_NAME="${NOTIFY_NAME:-Webhook server test}"
NOTIFY_DESTINATION_TYPE="${NOTIFY_DESTINATION_TYPE:-generic}"   # generic | slack | microsoft-teams | email
NOTIFY_URL="${NOTIFY_URL:-https://httpstat.us/200}"
NOTIFY_TRIGGERS="${NOTIFY_TRIGGERS:-run:created,run:errored,run:needs_attention,run:planning}"

# Flag de execução (gate) — se não for true, pula tudo
WORKSPACE_NOTIFICATION_ENABLED="${WORKSPACE_NOTIFICATION_ENABLED:-false}"

# Atributo enabled do payload (independente da flag acima) — default false
NOTIFY_ENABLED="${NOTIFY_ENABLED:-false}"

# ===== Gate: só executa se WORKSPACE_NOTIFICATION_ENABLED for truthy =====
shopt -s nocasematch
if [[ ! "$WORKSPACE_NOTIFICATION_ENABLED" =~ ^(1|true|yes|on)$ ]]; then
  echo "[pre-plan] WORKSPACE_NOTIFICATION_ENABLED=$WORKSPACE_NOTIFICATION_ENABLED → pulando criação."
  exit 0
fi
shopt -u nocasematch

# ===== Validações básicas =====
[[ -z "$HCP_ORG" ]] && { echo "Defina HCP_ORG"; exit 1; }
[[ -z "$HCP_TF_TOKEN" ]] && { echo "Defina HCP_TF_TOKEN"; exit 1; }
[[ -z "$TFC_WORKSPACE_NAME" ]] && { echo "Defina TFC_WORKSPACE_NAME"; exit 1; }
if [[ "$NOTIFY_DESTINATION_TYPE" != "email" && -z "$NOTIFY_URL" ]]; then
  echo "NOTIFY_URL é obrigatório para destination-type $NOTIFY_DESTINATION_TYPE"; exit 1
fi

# ===== Exporta para o playbook =====
export HCP_ORG HCP_TF_TOKEN TFC_WORKSPACE_NAME
export NOTIFY_NAME NOTIFY_DESTINATION_TYPE NOTIFY_URL NOTIFY_TRIGGERS
export NOTIFY_ENABLED

# ignora falha do notify_simples e continua
ansible-playbook -i /home/tfc-agent/.tfc-agent/hooks/scripts/hosts.ini \
  /home/tfc-agent/.tfc-agent/hooks/scripts/notify_simples.yaml -v || true

ansible-playbook -i /home/tfc-agent/.tfc-agent/hooks/scripts/hosts.ini \
  /home/tfc-agent/.tfc-agent/hooks/scripts/policy_set.yaml -v
