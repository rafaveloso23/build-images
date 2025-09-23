FROM hashicorp/tfc-agent:latest

USER root

## Install sudo (optional, if needed)
RUN apt-get -y update && apt-get -y install sudo

# Allow tfc-agent to run specific sudo commands
RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent

# Create hooks directory with correct permissions
RUN mkdir -p /home/tfc-agent/.tfc-agent/hooks/scripts

## Add hook scripts with proper ownership
ADD --chown=tfc-agent:tfc-agent hooks/ /home/tfc-agent/.tfc-agent/hooks/

# Make sure all hooks are executable
RUN chmod +x /home/tfc-agent/.tfc-agent/hooks/terraform-pre-plan \
    && chmod +x /home/tfc-agent/.tfc-agent/hooks/scripts/pre-plan.sh

# Set OTLP exporter address as environment variable
ENV TFC_AGENT_OTLP_ADDRESS=9.169.67.56:4317


USER tfc-agent
