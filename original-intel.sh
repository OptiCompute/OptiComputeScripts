#!/bin/bash

#required packages on all nodes 
dnf install -y wget
dnf install -y tar
#
for i in $(seq -w i $Nodes);do
	ssh -n wn${i} dnf install -y wget
	ssh -n wn${i} dnf install -y tar
done
#need to run on all nodes
Command="dnf -y install  libnotify xdg-utils libxcb mesa-libgbm gcc-c++ cmake gtk3 nss at-spi2-core"

ssh -n hn $Command
ssh -n wn01 $Command
ssh -n wn02 $Command

#Go to soft
cd /soft/
#Make installs directory
mkdir installs
#Make link for installs
cd /
 ln -s /soft/installs /installs
ssh -n wn01 "ln -s /soft/installs /installs"
ssh -n wn02 "ln -s /soft/installs /installs"
#Ignore Term enviroment ...

#go to installs
mkdir intel
cd intel/
#download intel basekit
wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/20f4e6a1-6b0b-4752-b8c1-e5eacba10e01/l_BaseKit_p_2024.0.0.49564_offline.sh
#intel hpc kit
wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/1b2baedd-a757-4a79-8abb-a5bf15adae9a/l_HPCKit_p_2024.0.0.49589_offline.sh

#check if installation was succesfull for basekit
#SHA384 9b3cf442eb2adbced58e69b6d5045b555901c5e0185f62ff36a017dcb969edeb63513987b34bbfcb138b1d77250490e2
#echo "must give name of file"

#for hpckit
#SHA384 1aa58422669cd6dead38286d9615609617443e7985c064c1530c5dfadf09d212aacc27b7b89ad53b7540849b0963851a
#echo "must give name of file"
 
 sudo sh ./l_BaseKit_p_2024.0.0.49564_offline.sh -a -s --eula accept --action install --install-dir /soft/intel/2024
sudo sh ./l_HPCKit_p_2024.0.0.49589_offline.sh -a -s --eula accept --action install --install-dir /soft/intel/2024


#Setting up modules
cd /soft/intel/2024/
./modulefiles-setup.sh

mkdir /soft/modules
cd ~
mv modulefiles /soft/modules/intel


module load intel/compiler

#if this runs that means the installation was succesful
icpx --version 

