FROM hashicorp/tfc-agent:latest

USER root

RUN apt-get -y install sudo

RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent

# Criação de diretórios com permissões apropriadas
RUN mkdir -p /home/tfc-agent/.tfc-agent/scripts && \
    chown -R tfc-agent:tfc-agent /home/tfc-agent/.tfc-agent && \
    chmod -R 700 /home/tfc-agent/.tfc-agent

# Copia e define permissões e proprietário com segurança usando `install`
RUN install -m 0755 -o tfc-agent -g tfc-agent hooks/terraform-pre-plan /home/tfc-agent/.tfc-agent/hooks/terraform-pre-plan && \
    install -m 0755 -o tfc-agent -g tfc-agent hooks/scripts/pre-plan.sh /home/tfc-agent/.tfc-agent/scripts/pre-plan.sh

USER tfc-agent
