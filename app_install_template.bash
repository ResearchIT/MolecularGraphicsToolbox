#!/bin/bash -e

###############################################################################
# Scripti Name:  app_install_template.bash
# Last update: 5-31-2018
#
#
# Revision:
#   2018-5-31 xfz Init
#
#
# Command to run the app
# $ singularity exec demo.simg babel ...
# $ singularity exec demo.simg /usr/bin/babel ...
#
#
# Short Description of App:
#   Open Babel: The Open Source Chemistry Toolbox
#   http://openbabel.org/wiki/Main_Page
# 
# Command for Installation 
# $ sudo $(which singularity) shell -w /to/the/demo.sandbox \
#                    /tmp/singularity/scripts.d/openbabel-2.3.2.bash
#
# Short Installation Instruction:
#   yum install openbabel to /usr/bin 
#   Reference to the online links if any.
# 
#
# List installed OS container(s):
#     centos7-gcc4.8.5-py2.7-java1.8.0-perl-xwin-mpich-3.2
#  
#
###############################################################################

# Staging area:
#   /tmp/singularity/stage for packing and downloading  
#   /tmp/singularity/scripts.d for installation script(s).

TMP_STAGE=/tmp/singularity/stage
TMP_SCRIPTS_D=/tmp/singularity/scripts.d

# For backup, this app_installation_script has to be in /tmp/singularity/scripts.d
ME=$(basename "$0")
test -f $TMP_SCRIPTS_D/$ME            || exit "$ME has to be in $TMP_SCRIPTS_D"

#### The pre-downloaded file(s) has to be in /tmp/singularity/stage
# pre_downloaded_file=pre_downloaded_file.rpm.tar.gz.bz2
# test -f $TMP_STAGE/$pre_downloaded_file  || exit "$pre_downloaded_file  has to be in $TMP_STAGE"
# src_4_bak=$pre_downloaded_file 
####

# Installation Destination:/opt/rit
#
# 1. For tracking and tracing issues in the container, all installation_scripts
# and the pre-downloaded file(s) will be archived to 
# /opt/rit/$app_type/$app_name/$app_version/src. 
#
# 2. All app is installed by a installation_script, like this template: openbabel is 
# simply installed by yum.
# 
# app_type=[app, lib, modules/perl or modules/python2.7]

OPT_RIT=/opt/rit
app_type=app
app_name=openbabel
app_version=2.3.2
app_install=$OPT_RIT/$app_type/$app_name/$app_version

# Archive if the same application of the same version exists
test -d $app_install && mv $app_install $app_install.bak.$(date  +"%Y%m%d-%H%M")

# Install the required packages
# Priority of the installation methods:
# yum > rpm > configure+make;  pip > conda > python setup.py

# yum -y     install required_package
# rpm -ivh   install required_package
# pip        install required_package
# conda      install required_package


# App Installation:
#   cd $TMP_STAGE 
#   unpacking the pre-downloaded file, and do the installation, or run the simple command:

yum -y install openbabel

# Create link(s) in /opt/rit/bin if needed
ln -s -f  /usr/bin/babel /opt/rit/bin/babel


# Archive the pre-downloded file and this installation script to the container for rebuilding
# and for tracing issues:

mkdir -p  $app_install/src
  cp $TMP_SCRIPTS_D/$ME              $app_install/src
# cp $TMP_STAGE/$src_4_bak           $app_install/src

echo "$(date)--End of installing $app_name."
