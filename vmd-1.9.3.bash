#!/bin/bash -e

###############################################################################
# script: vmd-1.9.3.bash
# last update: 5-31-2018
#
# Revision:
#   2018-5-31 xfz Init
#
# Command to run vmd:
# $ singularity exec demo.simg vmd   or
# $ singularity exec demo.simg /opt/rit/bin/vmd   
#
#
# Short Description of App:
#    VMD is a molecular visualization program for displaying, animating, 
#    and analyzing large biomolecular systems using 3-D graphics and 
#    built-in scripting.
#    http://www.ks.uiuc.edu/Research/vmd/
# 
# Command for Installation 
# $ sudo $(which singularity) shell -w /to/the/demo.sandbox \
#                    /tmp/singularity/scripts.d/vmd-1.9.3.bash
#
# Short Installation Instruction:
#   Register to download vmd from http://www.ks.uiuc.edu/Research/vmd/ 
#   Ref:  "VMD Installation Guide" 
#   http://www.ks.uiuc.edu/Research/vmd/current/ig/ig.html
#
# List installed OS container(s):
#     centos7-gcc4.8.5-py2.7-java1.8.0-perl-xwin-mpich-3.2
#
###############################################################################

#Staging area:
#   /tmp/singularity/stage for packing and downloading  
#   /tmp/singularity/scripts.d for installation script(s)
TMP_STAGE=/tmp/singularity/stage
TMP_SCRIPTS_D=/tmp/singularity/scripts.d

# App installation bash file
ME=$(basename "$0")
test -f $TMP_SCRIPTS_D/$ME || exit "$ME has to be in $TMP_SCRIPTS_D"
 
# Pre-downloaded file in $TMP_STAGE. 
# vmd-1.9.3.bin.LINUXAMD64-CUDA8-OptiX4-OSPRay111p1.opengl.tar.gz
tar_gz_file=vmd-1.9.3.bin.LINUXAMD64-CUDA8-OptiX4-OSPRay111p1.opengl.tar.gz
test -f $TMP_STAGE/$tar_gz_file  || exit "$tar_gz_file needs to be pre-downloaed to $TMP_STAGE."
src_4_bak=$tar_gz_file

# App Installation: in /opt/rit/app/vmd/1.9.3
app_name=vmd
app_type=app
app_version=1.9.3
app_install=/opt/rit/$app_type/$app_name/$app_version

# Rename the previous installation  if exists
test -d $app_install && mv $app_install $app_install.bak.$(date  +"%Y%m%d-%H%M")

# Required packages: No matter installed or not, run it anyway.
yum -y install  libGL libGLU qt5-qtbase-gui

# Use VMDINSTALLBINDIR and  VMDINSTALLLIBRARYDIR
# to override the defauts: /usr/local/bin and /usr/local/lib/vmd

export VMDINSTALLBINDIR=$app_install/bin
export VMDINSTALLLIBRARYDIR=$app_install/lib
 
cd  $TMP_STAGE
tar zxvf ./$tar_gz_file
cd  ./vmd-1.9.3
    ./configure  LINUXAMD64 OPENGL
cd  ./src
make install

#create vmd link in /opt/rit/bin
ln -s -f  $app_install/bin/vmd   /opt/rit/bin/vmd

# Archive the source code in $app_install/src/
mkdir -p  $app_install/src
cp  $TMP_STAGE/$src_4_bak  $app_install/src
cp  $TMP_SCRIPTS_D/$ME     $app_install/src

echo "$(date)--End of installing $app_name."
