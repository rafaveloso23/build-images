FROM hashicorp/tfc-agent:latest

USER root

RUN apt-get -y install sudo

RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent

# Criação de diretórios e permissões
RUN mkdir -p /home/tfc-agent/.tfc-agent/scripts && \
    chmod -R 700 /home/tfc-agent/.tfc-agent

# Copia os arquivos de hook e script
ADD --chown=tfc-agent hooks/terraform-pre-plan /home/tfc-agent/.tfc-agent/hooks/terraform-pre-plan
ADD --chown=tfc-agent hooks/scripts/pre-plan.sh /home/tfc-agent/.tfc-agent/scripts/pre-plan.sh

# Permissões de execução
RUN chmod +x /home/tfc-agent/.tfc-agent/hooks/terraform-pre-plan
RUN chmod +x /home/tfc-agent/.tfc-agent/scripts/pre-plan.sh

USER tfc-agent
