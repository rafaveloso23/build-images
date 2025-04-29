FROM hashicorp/tfc-agent:latest

# Switch the to root user in order to perform privileged actions such as
# installing software.
USER root

# Install sudo. The container runs as a non-root user, but people may rely on
# the ability to apt-get install things.
RUN apt-get -y install sudo

# Permit tfc-agent to use sudo apt-get commands.
RUN echo 'tfc-agent ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt' >> /etc/sudoers.d/50-tfc-agent

# Switch back to the tfc-agent user as needed by Terraform agents.
USER tfc-agent
#