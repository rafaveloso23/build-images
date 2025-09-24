#!/usr/bin/env bash
set -euo pipefail
echo "[pre-plan] iniciando configuração simples de notification..."

# ====== PRIORIDADE: ambiente (Workspace/VarSet) -> fallback local ======
# Credenciais / contexto
HCP_ORG="${HCP_ORG:-sua-org}"
HCP_TF_TOKEN="${HCP_TF_TOKEN:-seu-team-ou-org-token}"
TFC_WORKSPACE_NAME="${TFC_WORKSPACE_NAME:-seu-workspace}"

# Parâmetros da notification
NOTIFY_NAME="${NOTIFY_NAME:-Generic webhook}"
NOTIFY_DESTINATION_TYPE="${NOTIFY_DESTINATION_TYPE:-generic}"   # generic | slack | microsoft-teams | email
NOTIFY_URL="${NOTIFY_URL:-https://httpstat.us/200}"             # obrigatório p/ generic/slack/teams
WORKSPACE_NOTIFICATION_ENABLED="${WORKSPACE_NOTIFICATION_ENABLED:-true}"                        # true/false
NOTIFY_TRIGGERS="${NOTIFY_TRIGGERS:-run:created,run:completed,run:errored}"

# (opcional) exigir algumas vars:
# : "${HCP_TF_TOKEN:?defina HCP_TF_TOKEN no Variable Set}"
# : "${NOTIFY_URL:?defina NOTIFY_URL no Variable Set}"

export HCP_ORG HCP_TF_TOKEN TFC_WORKSPACE_NAME \
       NOTIFY_NAME NOTIFY_DESTINATION_TYPE NOTIFY_URL WORKSPACE_NOTIFICATION_ENABLED NOTIFY_TRIGGERS

ansible-playbook -i /home/tfc-agent/.tfc-agent/hooks/scripts/hosts.ini \
  /home/tfc-agent/.tfc-agent/hooks/notify_simples.yaml -v
