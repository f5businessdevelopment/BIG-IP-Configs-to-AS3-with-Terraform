#!/bin/bash

# Update system packages
sudo yum update -y

# Install Docker
sudo yum install -y docker

# Start Docker service
sudo systemctl start docker

# Create a user named "agent"
sudo useradd -m -s /bin/bash agent

# Pull the latest TFC Agent Docker image
sudo docker pull hashicorp/tfc-agent:latest

# Run TFC Agent container with necessary environment variables
sudo docker run -d --restart always \
    -e TFC_AGENT_TOKEN="${agent_token}" \
    -e TFC_AGENT_NAME="${agent_pool}" \
    hashicorp/tfc-agent
