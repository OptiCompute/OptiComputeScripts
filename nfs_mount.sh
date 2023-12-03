#!/bin/bash

#Installing the NFS utilities is required to be able to mount an NFS volume
dnf -y install nfs-utils

mkdir /scratch /soft
mount scratch:/data/scratch /scratch
mount storage:/data/soft /soft
mount storage:/home /home

#Modify /etc/fstab file
cat >> /etc/fstab <<-EOF
scratch:/data/scratch          /scratch      nfs        rw,tcp,noatime   0 0
storage:/data/soft             /soft         nfs        rw,tcp,noatime   0 0
storage:/home                  /home         nfs        rw,tcp,noatime   0 0
EOF
