#!/usr/bin/env bash
set -euo pipefail
echo "[pre-plan] iniciando configuração simples de notification..."

# ====== EDITE AQUI ======
# Credenciais / contexto
HCP_ORG="sua-org"
HCP_TF_TOKEN="seu-team-ou-org-token"
TFC_WORKSPACE_NAME="seu-workspace"

# Parâmetros da notification
NOTIFY_NAME="Generic webhook"
NOTIFY_DESTINATION_TYPE="generic"   # 'generic' | 'slack' | 'microsoft-teams' | 'email'
NOTIFY_URL="https://httpstat.us/200" # obrigatório p/ generic/slack/teams
NOTIFY_ENABLED="true"                # true/false
NOTIFY_TRIGGERS="run:created,run:completed,run:errored"
# ====== FIM DA EDIÇÃO ======

# Validações básicas
[[ -z "$HCP_ORG" ]] && { echo "Defina HCP_ORG"; exit 1; }
[[ -z "$HCP_TF_TOKEN" ]] && { echo "Defina HCP_TF_TOKEN"; exit 1; }
[[ -z "$TFC_WORKSPACE_NAME" ]] && { echo "Defina TFC_WORKSPACE_NAME"; exit 1; }

# Exporta para o playbook
export HCP_ORG HCP_TF_TOKEN TFC_WORKSPACE_NAME
export NOTIFY_NAME NOTIFY_DESTINATION_TYPE NOTIFY_URL NOTIFY_ENABLED NOTIFY_TRIGGERS

# Executa o playbook simples
ansible-playbook -i /home/tfc-agent/.tfc-agent/hooks/scripts/hosts.ini \
  /home/tfc-agent/.tfc-agent/hooks/scripts/notify_simples.yaml -v
