#!/bin/bash
#Variables
hn_priv_ip="10.4.0.100"         #Mofify!!!!
wn01_priv_ip="10.4.0.1"         #Mofify!!!!
wn02_priv_ip="10.4.0.2"         #Mofify!!!!

#Back up Original file
sudo cp /etc/hosts /etc/hosts.backup

# Use sudo to execute commands as superuser
sudo bash -c "cat <<EOF > /etc/hosts
127.0.0.1 localhost localhost.localdomain
::1

${hn_priv_ip}     hn storage storage scratch login
${wn01_priv_ip}     wn01 node01  wn02 node02
${wn02_priv_ip}     wn02 node02
EOF"

echo "Hosts file successfuly Modified"
