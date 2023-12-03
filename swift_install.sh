#!/bin/bash
##
#variables
Install_Ver=2016.4
Install_Dest=/soft/gromacs/$Install_Ver
##
MPIRUN=mpirun 
#Dependencies
./configure	--enable-parallel-hdf5 \
		--enable-mpi \
		--with-gsl=/home/opticompute/Opticomputescripts/ \
		--with-fftw=/home/opticpmute/Opticomputescripts/FFTW3_install.sh \
		--

		

#SWIFT Built from a clean source rep
./autogen 
./configure
make
