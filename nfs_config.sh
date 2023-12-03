#!/bin/bash
## local Variables
nodes=2
hn_priv_ip="10.3.0.100"
hn_cird="24"
Domain_name=opticompute.local
curr_dir=$(pwd)

#Correctlt set up hostnames for all  nodes
sudo hostnamectl set-hostname hn.${Domain_name}
for i in $(seq 1 $nodes); do 
	echo "setting up hostname for wn${i}"
	ssh -n wn0$i "sudo hostnamectl set-hostname wn0${i}.${Domain_name}"
done

#This will only run on the head node or storage node and we assume data is already mounted during OS install  !!
cd /data

#Create the scratch and soft directories
mkdir scratch soft
ln -s /data/soft /
ln -s /data/scratch /

#Install the NFS utilities, which are required later
dnf -y update
dnf -y install nfs-utils

for i in $(seq 1 $nodes); do
       #c Udate  all node
      ssh -n wn0${i} "dnf -y update"
done

#Add firewall rules to allow NFS traffic from WNs:
firewall-cmd --permanent --zone=internal --add-service=nfs
firewall-cmd --permanent --zone=internal --add-service=mountd
firewall-cmd --permanent --zone=internal --add-service=rpc-bind

#Activate the rules
firewall-cmd --reload


#Modifyin the  /etc/exports file
echo "Modifying /etc/exports "
cat >  /etc/exports <<-EOF
/home                ${hn_priv_ip}/${hn_cird}(async,rw,no_root_squash,no_subtree_check)
/data/soft           ${hn_priv_ip}/${hn_cird}(async,rw,no_root_squash,no_subtree_check)
/data/scratch        ${hn_priv_ip}/${hn_cird}(async,rw,no_root_squash,no_subtree_check)
EOF

#Restart service
systemctl restart rpcbind
systemctl restart nfs-server
systemctl enable rpcbind
systemctl enable nfs-server

#MOunt NFS on all nodes 
#Installing the NFS utilities is required to be able to mount an NFS volume
for i in $(seq 1 $nodes); do
       #copy hostnames files to all node
        scp ${curr_dir}/hostnames.sh wn0${i}:
        ssh -n wn0${i} "hostname; sh hostnames.sh "

	echo "copying mount file to wn${i}"
# 	scp ${curr_dir}/nfs_mount.sh wn0${i}:
#	echo "running mount script"

#	ssh -n wn0${i} "hostname; sh  nfs_mount.sh "
#	echo "Mount Done on wn${i}"
	#sudo ./nfs_mount.sh

done
