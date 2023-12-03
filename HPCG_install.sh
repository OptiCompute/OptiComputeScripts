#!/bin/bash
#
#Variables

#
cd /soft/installs
mkdir hpcg
cd hpcg 
#
git clone https://github.com/hpcg-benchmark/hpcg
cd hpcg
#
mkdir build
cd build/
#
cmake -DCMAKE_CXX_COMPILER=icpc -DCMAKE_C_COMPILER=icc -DHPCG_ENABLE_MPI
