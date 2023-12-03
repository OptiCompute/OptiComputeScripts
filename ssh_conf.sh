#!/bin/bash
# The following line reads: test if a specific file exists or else execute: ssh-keygen -t ed25519
[ -e ~/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
cd ~/.ssh
cat id_ed25519.pub >> authorized_keys
chmod 600 authorized_keys

# Let's try and copy root's existing SSH key to the nodes:
nodes=2
err_code=0

for i in $(seq 1 $nodes); do
ssh-copy-id -i ~/.ssh/id_ed25519 root@wn0${i}
err_code=$(( $err_code + $? ))
done

if [ $err_code -ne 0 ]; then
#ONLY IF THE ABOVE FAILED is it necessary to perform the rest of this code-block
MyUsername=opticompute
MyHome=$(eval echo ~$MyUsername)
nodes=2
for i in $(seq 1 $nodes); do
ssh-copy-id -i ~/.ssh/id_ed25519 ${MyUsername}@wn0${i}
done

for i in $(seq 1 $nodes); do
ssh -n ${MyUsername}@wn0${i} "sudo mkdir /root/.ssh &>/dev/null; \
sudo bash -c 'cat $MyHome/.ssh/authorized_keys >> \
/root/.ssh/authorized_keys'"
done

for i in $(seq 1 $nodes); do
ssh -n wn0${i} "hostname;uptime;echo;echo"
done
fi

#from 8 to 9\

# Modify /etc/ssh/sshd_config
sshd_config_path="/etc/ssh/sshd_config"

# Ensure the required lines are present or add them
grep -q "^PubkeyAuthentication" "$sshd_config_path" && sed -i "s/^PubkeyAuthentication.*/PubkeyAuthentication yes/" "$sshd_config_path" || echo "PubkeyAuthentication yes" >> "$sshd_config_path"
grep -q "^PasswordAuthentication" "$sshd_config_path" && sed -i "s/^PasswordAuthentication.*/PasswordAuthentication yes/" "$sshd_config_path" || echo "PasswordAuthentication yes" >> "$sshd_config_path"
grep -q "^PermitRootLogin" "$sshd_config_path" && sed -i "s/^PermitRootLogin.*/PermitRootLogin prohibit-password/" "$sshd_config_path" || echo "PermitRootLogin prohibit-password" >> "$sshd_config_path"
grep -q "^UseDNS" "$sshd_config_path" && sed -i "s/^UseDNS.*/UseDNS no/" "$sshd_config_path" || echo "UseDNS no" >> "$sshd_config_path"

# Restart SSH service
systemctl restart sshd

# Disable SELinux
selinux_config_path="/etc/selinux/config"

# Change SELINUX line
grep -q "^SELINUX=" "$selinux_config_path" && sed -i "s/^SELINUX.*/SELINUX=disabled/" "$selinux_config_path" || echo "SELINUX=disabled" >> "$selinux_config_path"

# Inform the user about the need to reboot
echo "SELINUX has been disabled. Please reboot the system for the changes to take effect."

# Alternatively, if reboot is not possible, execute the following command
echo "If reboot is not possible, you can execute: setenforce 0"

~
``
