#!/bin/bash
#
#variables


#install git
dnf install -y git 
#
#Go to soft installs dir
cd /soft/installs
mkdir Lammps
cd Lammps
#
#Clone the lammps from git
git clone -b stable https://github.com/lammps/lammps.git lammps
#
#To install the Intel package
cd lammps/src
make yes-intel
#set up the Intel oneAPI environment variables
source /soft/intel/2024/setvars.sh
#
make intel_cpu_intelmpi -j 4
