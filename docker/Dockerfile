FROM hashicorp/tfc-agent:latest

USER root

## Install packages required for Ansible and Ansible itself (via pip)
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sudo \
        python3 \
        python3-pip \
        openssh-client \
        sshpass \
        build-essential \
        libssl-dev \
        libffi-dev \
        python3-dev \
    && python3 -m pip install --no-cache-dir ansible \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Allow tfc-agent to run specific sudo commands
RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent

# Create hooks directory with correct permissions
RUN mkdir -p /home/tfc-agent/.tfc-agent/hooks/scripts

## Add hook scripts with proper ownership
ADD --chown=tfc-agent:tfc-agent hooks/ /home/tfc-agent/.tfc-agent/hooks/

# Make sure all hooks are executable
RUN chmod +x /home/tfc-agent/.tfc-agent/hooks/terraform-pre-plan \
    && chmod +x /home/tfc-agent/.tfc-agent/hooks/scripts/pre-plan.sh

USER tfc-agent
