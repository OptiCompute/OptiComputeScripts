#!/bin/bash
#
#variables
APP_NAME=fftw
APP_VER=3.3.7
APP_DEST=/soft/$APP_NAME/$APP_VER
APP_MODULE=/soft/modules/$APP_NAME/$APP_VER
#
#
module load gcc
module load openmpi
#
#set up enviromental variables
export MPICC=$(which mpicc)
export LDFLAGS="-L$MPI_LIB"
export CPPFLAGS="-I$MPI_INCLUDE"
export MPILIBS="-lmpi"
#
#install in the tmp dir
cd /tmp
#
wget http://www.fftw.org/fftw-3.3.7.tar.gz
#
tar -xf $APP_SRC
#
cd /tmp/$APP_NAME-$APP_VER
#
#Run make clean 
make clean
#
CONFIG_OPTIONS=" \
	 --prefix=$APP_DEST \
	 --enable-shared \
       	 --enable-openmp \
	 --enable-mpi \
	 --enable-fma \
	 --enable-sse2 \
	 --enable-avx \
	 --enable-avx2 \
	 --enable-avx-128-fma"
#
#Configure and compile Double precision version
./configure \
	 $CONFIG_OPTIONS
#
make -j 4 && make install
#
#Configure and compile the single-precision version
make clean
./configure \
	 $CONFIG_OPTIONS \
	  --enable-sse \
	  --enable-single
#
make -j 4 && make install
#
mkdir $(dirname $APP_MODULE)
#
#Generate Module file
cat > $APP_MODULE <<EOF
#%Module1.0
## $APP_NAME modulefile
##
proc ModulesHelp { } {
 puts stderr "\tAdds $APP_NAME ($APP_VER) to your environment."
}
module-whatis "Sets the environment for using $APP_NAME ($APP_VER)"

module load openmpi
module load gcc
set                 ver                   $APP_VER
set                 dir                   $APP_DEST

setenv              FFTW_DIR               \$dir
setenv              FFTW_VER               \$ver
prepend-path        PATH                   \$dir/bin
prepend-path        MANPATH                \$dir/share/man
prepend-path        LD_LIBRARY_PATH        \$dir/lib
prepend-path        PKG_CONFIG_PATH        \$dir/lib/pkgconfig
EOF

