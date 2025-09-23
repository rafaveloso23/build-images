FROM hashicorp/tfc-agent:latest

USER root

### Dependências mínimas p/ Ansible e utilitários úteis
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      python3 python3-pip ca-certificates jq sudo \
 && python3 -m pip install --no-cache-dir ansible-core \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

### (Opcional) permitir alguns comandos via sudo
RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' > /etc/sudoers.d/50-tfc-agent

# Hooks
RUN mkdir -p /home/tfc-agent/.tfc-agent/hooks/scripts
ADD --chown=tfc-agent:tfc-agent hooks/ /home/tfc-agent/.tfc-agent/hooks/
RUN chmod +x /home/tfc-agent/.tfc-agent/hooks/terraform-pre-plan \
    && chmod +x /home/tfc-agent/.tfc-agent/hooks/scripts/pre-plan.sh

# Verificação opcional (falha cedo se faltar algo)
RUN ansible --version && ansible-playbook --version

USER tfc-agent
