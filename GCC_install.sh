#!/bin/bash 
#
#Variables
Install_Version=11.4.0
Install_Destination=/soft/gcc/$Install_Version
group=OptiComputeMembers
#
cd /tmp
#
wget "https://mirror.ufs.ac.za/gnu/gcc/gcc-${Install_Version}/gcc-${Install_Version}.tar.gz" -O gcc-${Install_Version}.tar.gz
#
tar -xvf gcc-${Install_Version}.tar.gz
#
cd gcc-${Install_Version}
#
#Install dependencies
dnf install libgmp-dev libmpfr-dev libmpc-dev
#./configure \
--prefix=$Install_Destination \
	 --enable-threads \
	 --enable-languages="c,c++,fortran,objc,obj-c++ " \
	 --disable-multilib
         --with-mpc

#
#installing dependencies 
sudo dnf install gmp-devel mpfr-devel libmpc-devel
#
make -j 4 && sudo make install
#
mkdir -p /soft/modules/gcc
cd /soft/modules/gcc
#
#GCC modules 
#
#
sudo cat > $Install_Version <<EOF
#%Module1.0
## gcc modulefile
##
proc ModulesHelp { } {
 puts stderr "\tAdds GCC C/C++ compilers ($Install_Version) to your 
environment."

module-whatis "Sets the environment for using GCC C/C++ compilers 
($Install_Version)"
set GCC_VERSION $Install_Version
set GCC_DIR $Install_Destination
prepend-path PATH \$GCC_DIR/include
prepend-path PATH \$GCC_DIR/bin
prepend-path MANPATH \$GCC_DIR/man
prepend-path LD_LIBRARY_PATH \$GCC_DIR/lib
prepend-path LD_LIBRARY_PATH \$GCC_DIR/lib64
setenv GCC_VER \$GCC_VERSION
setenv CC \$GCC_DIR/bin/gcc
setenv GCC \$GCC_DIR/bin/gcc
setenv FC \$GCC_DIR/bin/gfortran
setenv F77 \$GCC_DIR/bin/gfortran
setenv F90 \$GCC_DIR/bin/gfortran
#For CFLAGS, see: https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html
setenv CFLAGS "-march=broadwell -m64"
EOF
#
#
chown -R :${group} $Install_Destination /soft/modules
