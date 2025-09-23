#!/usr/bin/env bash
set -euo pipefail

: "${HCP_ORG:?defina no Variable Set}"
: "${HCP_TF_TOKEN:?defina no Variable Set}"
: "${TFC_WORKSPACE_NAME:?fornecida pelo run}"

NOTIFY_NAME="${NOTIFY_NAME:-Webhook server test}"
NOTIFY_DESTINATION_TYPE="${NOTIFY_DESTINATION_TYPE:-generic}"
NOTIFY_URL="${NOTIFY_URL:-https://httpstat.us/200}"
NOTIFY_ENABLED="${NOTIFY_ENABLED:-true}"
NOTIFY_TRIGGERS="${NOTIFY_TRIGGERS:-run:created,run:completed,run:errored}"

export HCP_ORG HCP_TF_TOKEN TFC_WORKSPACE_NAME \
       NOTIFY_NAME NOTIFY_DESTINATION_TYPE NOTIFY_URL NOTIFY_ENABLED NOTIFY_TRIGGERS

ansible-playbook -i /home/tfc-agent/.tfc-agent/hooks/scripts/hosts.ini \
  /home/tfc-agent/.tfc-agent/hooks/scripts/notify.yml -v