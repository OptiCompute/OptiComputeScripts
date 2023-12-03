#!/bin/bash

NumberOfNodes=2

for i in $(seq 1 $NumberOfNodes); do
    scp /etc/passwd /etc/group /etc/sudoers /etc/hosts root@wn0$i:/etc/
done

# List of nodes
nodes=("hn" "wn01" "wn02")

# Loop through the nodes and update packages
for node in "${nodes[@]}"; do
    echo "Updating packages on $node..."
    ssh "$node" "sudo dnf -y update"
done

echo "Update process completed."
