#!/usr/bin/env bash
set -euo pipefail

echo "[pre-plan] iniciando configuração de notifications..."

# Deriva a ORG do SLUG se não vier do Variable Set
if [[ -z "${HCP_ORG:-}" ]]; then
  if [[ -n "${TFC_WORKSPACE_SLUG:-}" ]]; then
    export HCP_ORG="${TFC_WORKSPACE_SLUG%%/*}"
    echo "[pre-plan] HCP_ORG derivada do SLUG: ${HCP_ORG}"
  else
    echo "[pre-plan] HCP_ORG não definida e sem TFC_WORKSPACE_SLUG; pulando."
    exit 0
  fi
fi

: "${HCP_TF_TOKEN:?defina HCP_TF_TOKEN no Variable Set (Team/Org token)}"
: "${TFC_WORKSPACE_NAME:?fornecida pelo run}"

# Toggle (aceita maiúscula/minúscula e var em snake/lowercase)
WORKSPACE_NOTIFICATION_ENABLED="${WORKSPACE_NOTIFICATION_ENABLED:-${workspace_notification_enabled:-false}}"
shopt -s nocasematch
if [[ ! "${WORKSPACE_NOTIFICATION_ENABLED}" =~ ^(1|true|yes|on)$ ]]; then
  echo "[pre-plan] WORKSPACE_NOTIFICATION_ENABLED=false -> pulando configuração de notifications."
  exit 0
fi
shopt -u nocasematch

# Parâmetros para o destino generic
# (URL obrigatória — deixe sem default para forçar via Variable Set)
: "${NOTIFY_URL:?defina NOTIFY_URL no Variable Set}"
NOTIFY_NAME="${NOTIFY_NAME:-Generic webhook}"
NOTIFY_TRIGGERS="${NOTIFY_TRIGGERS:-run:created,run:completed,run:errored}"

# Exporta o que o playbook usa
export HCP_ORG HCP_TF_TOKEN TFC_WORKSPACE_NAME \
       WORKSPACE_NOTIFICATION_ENABLED \
       NOTIFY_NAME NOTIFY_URL NOTIFY_TRIGGERS

# Chama o playbook
ansible-playbook -i /home/tfc-agent/.tfc-agent/hooks/scripts/hosts.ini \
  /home/tfc-agent/.tfc-agent/hooks/scripts/notify.yml -v
