#!/bin/bash

Dir="$HOME/.ssh"
Type=ed25519
authorized_keys="$Dir/authorized_keys"

# Ensure ~/.ssh directory exists
mkdir -p "$Dir"

# Check if the private key already exists
if [ ! -e "$Dir/id_${Type}" ]; then
    # Generate SSH key pair
    ssh-keygen -t "$Type" -N '' -f "$Dir/id_${Type}"

    # Check if public key file exists
    if [ -e "$Dir/id_${Type}.pub" ]; then
        # Append public key to authorized_keys
        cat "$Dir/id_${Type}.pub" >> "$authorized_keys"
        chmod 600 "$authorized_keys"
        echo "SSH key pair generated and added to $authorized_keys"
    else
        echo "Error: Public key file not generated."
        exit 1
    fi
else
    echo "SSH key pair already exists. Skipping generation."
fi

touch  Sentinel_files/SSH_keysMembers
