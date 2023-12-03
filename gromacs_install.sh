#!/bin/bash
#
#Variables
install_version=2023.3

#
cd /installs
mkdir gromacs
cd gromacs/
#
#run wget to get the tar file 
wget "https://ftp.gromacs.org/gromacs/gromacs-2023.3.tar.gz"
#
#go to tmp
cd /tmp
mkdir gromacs
cd gromacs
#extract the file
tar xfz /soft/installs/gromacs/gromacs-2023.3.tar.gz
#
#create a build dir and run cmake 
cd gromacs-${install_version}
mkdir build_gromacs
cd build_gromacs
#
#Run Cmake and set the flags

