#!/bin/bash
##Define variables
HN_PRIV_IP="10.3.0.100"
WNO1_PRIV_IP="10.3.0.1"
WN02_PRIV_IP="10.3.0.2"
HN_CIDR="24"
MY_HOSTNAME=$(hostname -s)
WAN_INT="enX0"
LAN_INT="enX1"
WN_LAN_INT="enX1"
NODES=2
MyUsername="opticompute"

#configure hosts file 
# Use sudo to execute commands as superuser
        
cat > /etc/hosts <<-EOF
127.0.0.1 localhost localhost.localdomain
::1 localhost

${HN_PRIV_IP}       hn storage storage scratch login
${WNO1_PRIV_IP}     wn01 node01  
${WN02_PRIV_IP}     wn02 node02
EOF
echo "Hosts file successfuly Modified"
	
sed -i "s|^SELINUX=.*|SELINUX=disabled|g" /etc/selinux/config
setenforce 0

if [ "$MY_HOSTNAME" == "hn" ]; then

	sed -i "s|^address1.*|address1=${HN_PRIV_IP}/${HN_CIDR}|g" \
	 /etc/NetworkManager/system-connections/${LAN_INT}.nmconnection

	# The following line reads: test if a specific file exists
	[ -e ~/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519

	cd ~/.ssh

	cat id_ed25519.pub >> authorized_keys
	chmod 600 authorized_keys

	# Let's try and copy root's existing SSH key to the nodes
	err_code=0
	for i in $(seq 1 $NODES); do
		 ssh-copy-id -i ~/.ssh/id_ed25519 root@wn0${i}
		 err_code=$(( $err_code + $? ))
	done

	if [ $err_code -ne 0 ]; then
	 # So, we copy the authorized_keys file to the remote hosts as a normal user first:
	 MyHome=$(eval echo ~$MyUsername)
	 for i in $(seq 1 $NODES); do
		 ssh-copy-id -i ~/.ssh/id_ed25519 ${MyUsername}@wn0${i}
		 echo "ssh keys copied to wn${i} successfuly"
	 done
	fi

	 # The following for loop is a bit complex, but in essence, for each node:
	 # log in as our regular user, create /root/.ssh and append the content of
	 # the normal user’s authorized_keys file to root’s authorized_keys file:
	 for i in $(seq 1 $NODES); do
		echo "copying user’s authorized_keys file to root’s authorized_keys file for wn${i}" 
		 ssh -n  ${MyUsername}@wn0${i} "sudo -S mkdir /root/.ssh &>/dev/null; \
		 sudo bash -c 'cat ${MyHome}/.ssh/authorized_keys >> \
		 /root/.ssh/authorized_keys'"
	 done

else
	if [ "$MY_HOSTNAME" == "wn01" ]; then

		sed -i "s|^address1.*|address1=${WN01_PRIV_IP}/${HN_CIDR}|g" \
                /etc/NetworkManager/system-connections/${WN_LAN_INT}.nmconnection

		#Restart SSH service
		systemctl restart sshd
	fi

	if [ "$MY_HOSTNAME" == "wn02" ]; then

		sed -i "s|^address1.*|address1=${WN01_PRIV_IP}/${HN_CIDR}|g" \
                /etc/NetworkManager/system-connections/${WN_LAN_INT}.nmconnection
                
		#Restart SSH service
                systemctl restart sshd
       fi
fi

sed -i \
        -e "s|^#PermitRootLogin.*|PermitRootLogin prohibit-password|g"\
        -e "s|^#UseDNS.*|UseDNS no|g" /etc/ssh/sshd_config

#set the Nertwork config

