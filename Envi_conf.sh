#!/bin/bash
#
##VAriables
hpc_file_path="hpc"
curr_dir=$(pwd)
Nodes=2
no_nodes=("hn" "wn01" "wn02" )
#
#Install the environment-module package:
dnf -y install environment-modules
for i in $(seq -w 1 $Nodes); do
	ssh -n wn0${i} dnf -y install environment-modules        
done
# Set MODULEPATH for Bash
cat > /etc/profile.d/zhpc.sh <<EOF
export MODULEPATH="\$MODULEPATH:/soft/modules"
EOF

# Set MODULEPATH for C-Shell
cat > /etc/profile.d/zhpc.csh <<EOF
setenv MODULEPATH "\$MODULEPATH:/soft/modules"
EOF

#Make the scripts executable
chmod 0755 /etc/profile.d/zhpc.{sh,csh}
#
#
#Copy file to hn
cp hpc /usr/share/Modules/modulefiles/
for i in $(seq -w 1 $Nodes); do
	[ -e /usr/share/Modules/modulefiles/ ] || sudo mkdir -p /usr/share/Modules/modulefiles/
	scp "$curr_dir/hpc" "wn0${i}:/usr/share/Modules/modulefiles/"
done
#
#Create the zmodules_hpc.sh file 
cat > /etc/profile.d/zmodules_hpc.sh <<EOF
module load hpc
EOF
#
#
for i in $(seq 1 2); do
 scp /etc/profile.d/zmodules_hpc.{sh,csh} wn0$i:/etc/profile.d/
 scp /etc/profile.d/zhpc.sh wn0$i:/etc/profile.d/
 scp /usr/share/Modules/modulefiles/hpc wn0$i:/usr/share/Modules/modulefiles/
done
#
#
echo "Environment-modules package installed successfully."
echo "MODULEPATH set for Bash in /etc/profile.d/zhpc.sh."
