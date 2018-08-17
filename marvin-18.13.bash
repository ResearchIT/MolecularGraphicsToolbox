#!/bin/bash -e

###############################################################################
# script: marvin-18.13.bash
# last update: 5-31-2018
#
# Revision:
#   2018-5-31 xfz Init
#
# Command to Run marvin:
# $ singularity exec demo.simg msketch   or
# $ singularity exec demo.simg /usr/bin/msketch   
#
# Short Description of App:
#   Marvin suite is a chemically intelligent desktop toolkit built to help you draw, 
#   edit, publish, render, import and export your chemical structures and as well 
#   as allowing you to convert between various chemical and graphical file formats.
#   https://chemaxon.com/products/marvin
#
# Command to Install:
# $ sudo $(which singularity) shell -w /to/the/demo.sandbox \
#                    /tmp/singularity/scripts.d/marvin-18.13.bash
#
#  Short Installation Instruction:
#   rpm -ivh marvin_linux_18.13.rpm 
#   rpm file : https://chemaxon.com/products/marvin/download
#
# List installed OS container(s):
#     centos7-gcc4.8.5-py2.7-java1.8.0-perl-xwin-mpich-3.2
#  
###############################################################################
# Staging area:
#   /tmp/singularity/stage for packing and downloading  
#   /tmp/singularity/scripts.d for installation script(s)

TMP_STAGE=/tmp/singularity/stage
TMP_SCRIPTS_D=/tmp/singularity/scripts.d

# Installation bash file
ME=$(basename "$0")
test -f $TMP_SCRIPTS_D/$ME  || exit "$ME has to be in $TMP_SCRIPTS_D"

#Pre-downloaed rpm file
rpm_install_file=marvin_linux_18.13.rpm
test -f $TMP_STAGE/$rpm_install_file  || exit "$rpm_install_file has to be in $TMP_STAGE"
src_4_bak=$rpm_install_file

# App Installation
app_name=marvin
app_type=app
app_version=18.13
app_install=/opt/rit/$app_type/$app_name/$app_version

# Backup the existing installation if needed
test -d $app_install && mv $app_install $app_install.bak.$(date  +"%Y%m%d-%H%M")

#Require: java
yum -y install java

cd $TMP_STAGE
rpm -ivh ./$rpm_install_file

# Create link in /opt/rit/bin
ln -s -f /usr/bin/msketch /opt/rit/bin/msketch

#Archive the download
mkdir -p  $app_install/src
cp  $TMP_STAGE/$src_4_bak  $app_install/src
cp  $TMP_SCRIPTS_D/$ME     $app_install/src

echo "$(date)--End of installing $app_name."



