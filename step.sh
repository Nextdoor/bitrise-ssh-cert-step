#!/bin/bash
set -e

# Fetch binary
if [ "$(uname)" == "Darwin" ]; then
    client_type="mac"     
else
    client_type="linux" 
fi

wget -q --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 3 -P /tmp "https://s3-us-west-2.amazonaws.com/ssh-ca-binary-corp-nextdoor-com/0.0.13/ca_client.${client_type}/ssh-ca-client"
chmod +x /tmp/ssh-ca-client
mkdir -p "${HOME}/.ssh"
SSH_AUTH_SOCK="${HOME}/.ssh/S.ssh-agent.ssh"

# Start ssh-agent
ssh-agent -a "${SSH_AUTH_SOCK}"

# Request certificate
AWS_ACCESS_KEY_ID="${aws_access_key_id}" AWS_SECRET_ACCESS_KEY="${aws_secret_access_key}" /tmp/ssh-ca-client --ca-url "${ssh_ca_url}" --handler-public-key "${ssh_ca_handler_public_key}" machine-user --username "${ssh_ca_machine_user}" --role "${ssh_ca_role}"

# Output the auth sock filename
envman add --key SSH_AUTH_SOCK --value "${SSH_AUTH_SOCK}"
