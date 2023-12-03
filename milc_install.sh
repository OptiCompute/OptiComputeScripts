#!/bin/bash
##
#variables

#
#clone milc repo from git
git clone https://github.com/milc-qcd/milc_qcd.git
#go inside the milc_qcd dir 
cd milc_qcd
#check out the development bruch
git checkout develop
#go to ks_imp_rhmc
cd ks_imp_rhmc
#make copy of the make file and create a backup
cp ../Makefile .
#
#load intel mpi mpicxx
 ml intel/tbb/latest intel/compiler-rt/latest intel/intel_ipp_intel64/latest intel/intel_ippcp_intel64/latest intel/mkl/latest intel/mpi/latest intel/ccl/latest intel/oclfpga/latest intel/compiler/latestexit
 
