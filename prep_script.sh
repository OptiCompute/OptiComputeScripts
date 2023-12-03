#!/bin/bash
#local varibales 
nodes=2
MyUsername=opticompute
nodes_priva_ip_wn=("10.3.0.1" "10.3.0.2")
#install EPEl 
sudo dnf install epel-release
dnf repo -y list

#install python 
sudo dnf -y install python3 

#check where python is installed
which python3 &&

#install git 
sudo dnf -y install git 

#check where git is installed 
which git &&

#installing Ansible
sudo dnf install python3-pip
python3 -m pip install --user ansible
ansible --version

#update 
sudo dnf -y update 

#create a key for ansible
[ -e ~/.ssh/ansible ] || ssh-keygen -t ed25519 -N '' -f ~/.ssh/ansible -C "ansible_key"
#copy key to Authoried keys 
cd ~/.ssh
cat ansible.pub > authorized_keys
chmod 600 authorized_keys

#Copy the ansible key to all nodes

for i in "${nodes_priva_ip_wn[@]}"; do
    ssh-copy-id -i ~/.ssh/ansible.pub "$MyUsername@$i"
done
