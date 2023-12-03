#!/bin/bash

# Set the destination directory on the worker nodes
DESTINATION_DIR="/etc/munge/"

# Set the MUNGE key file
MUNGE_KEY_FILE="/etc/munge/munge.key"

# Set the list of worker nodes
WORKER_NODES=("wn01" "wn02")

# Check if the MUNGE key file exists on the head node
if [ -f "$MUNGE_KEY_FILE" ]; then
    echo "MUNGE key found on the head node. Starting copy process..."

    # Loop through each worker node and copy the MUNGE key
    for NODE in "${WORKER_NODES[@]}"; do
        echo "Copying MUNGE key to $NODE..."
        
        # Use ssh and tar to preserve permissions during copy
	ssh -n $NODE "[ -e $DESTINATION_DIR ] || mkdir $DESTINATION_DIR"
        scp "$MUNGE_KEY_FILE"  "$NODE:$DESTINATION_DIR"
        ssh -n  $NODE "chown munge: -R $DESTINATION_DIR ; chmod 0400 $MUNGE_KEY_FILE ; systemctl restart munge.service " 
        # Check the exit status of the copy operation
        if [ $? -eq 0 ]; then
            echo "Copy to $NODE successful."
        else
            echo "Error: Copy to $NODE failed."
        fi
    done

else
    echo "Error: MUNGE key not found on the head node. Please generate the key first."
fi
