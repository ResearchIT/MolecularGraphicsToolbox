#!/bin/bash -e

###############################################################################
# Script: chimera-1.13.bash
# last update: 5-31-2018
#
## Revision:
#   2018-5-31 xfz Init
#
# Command to Run chimera:
# $ singularity exec demo.simg chimera   or
# $ singularity exec demo.simg /opt/rit/bin/chimera   
#
# Short Description of App:
#   Chimera: An Extensible Molecular Modeling System
#   https://www.cgl.ucsf.edu/chimera/
# 
# Command to install:
# $ sudo $(which singularity) shell -w /to/the/demo.sandbox \
#                    /tmp/singularity/scripts.d/chimera-1.13.bash
# 
# Short Installation Instruction:
#   1. Need to accept license to download chimera-1.13-linux_x86_64.bin
#   from https://www.cgl.ucsf.edu/chimera/download.html
#   2. *** Need user's inputs during the installation. *****
#   Installation location: /opt/rit/app/chimera/1.13rc.
#   Links in /opt/rit/bin. 
# 
# Ref:
# "Chimera on x86 64-bit Linux Platforms"
# https://www.cgl.ucsf.edu/chimera/data/downloads/1.13/linux_x86_64.html
# https://www.cgl.ucsf.edu/chimera/data/downloads/1.12/linux.html
# (As of 6/6/2018, https://www.cgl.ucsf.edu/chimera/data/downloads/1.13/linux.html is broken.)
#
#
# List installed OS container(s):
#     centos7-gcc4.8.5-py2.7-java1.8.0-perl-xwin-mpich-3.2
#  
###############################################################################

# Staging area:
#   /tmp/singularity/stage for packing and downloading  
#   /tmp/singularity/scripts.d for installation script(s).

TMP_STAGE=/tmp/singularity/stage
TMP_SCRIPTS_D=/tmp/singularity/scripts.d

#Installation bash file
ME=$(basename "$0")
test -f $TMP_SCRIPTS_D/$ME    || exit "$ME has to be in $TMP_SCRIPTS_D"

# Pre-download chimera-1.13-linux_x86_64.bin to $TMP_STAGE
bin_install_file=chimera-1.13-linux_x86_64.bin
test -f $TMP_STAGE/$bin_install_file  || exit "$bin_install_file needs to be pre-downloaed to $TMP_STAGE."
src_4_bak=$bin_install_file

# App Installation in /opt/rit/app
app_name=chimera
app_type=app
app_version=1.13rc
app_install=/opt/rit/$app_type/$app_name/$app_version

# Rename the previous installation  if exists
test -d $app_install && mv $app_install $app_install.bak.$(date  +"%Y%m%d-%H%M")


# Required, even not listed in the installation instruction
yum -y install  tk tk-devel tkinter libXScrnSaver

# Run the chimera-1.13-linux_x86_64.bin to install, which needs USER's inputs
# during the installation. The output/input is displayed as following: 

cd $TMP_STAGE
chmod +x ./$bin_install_file
         ./$bin_install_file

###*****Interactive input/output on a term: ****************************************************
#** Enter install location:/opt/rit/app/chimera/1.13rc     (Default: /opt/UCSF/Chimera64-1.13rc)
#** Install desktop menu (icon has to be done by user)? no (Default: yes)
# Install symbolic link to chimera executable for command line use in which directory?
#    0 -- no link
#    1 -- /opt/rit/bin
#    2 -- /opt/miniconda2/bin
#    3 -- /usr/local/sbin
#    4 -- /usr/local/bin
#    5 -- /usr/sbin
#    6 -- /usr/bin
#    7 -- /sbin
#    8 -- /bin
#** [hit Enter for default (0)]: 1                           (1 -- /opt/rit/bin) 
# Create unversioned link to chimera executable in same directory? yes
# ......
# ......
####********************************************************************************************** 

mkdir -p  $app_install/src
cp  $TMP_STAGE/$src_4_bak  $app_install/src
cp  $TMP_SCRIPTS_D/$ME     $app_install/src


echo "$(date)--End of installing $app_name."
