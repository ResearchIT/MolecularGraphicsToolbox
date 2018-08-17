#!/bin/bash -e

###############################################################################
# Scripti Name:  openbabel-2.3.2.bash
# Last update: 5-31-2018
#
#
# Revision:
#   2018-5-31 xfz Init
#
#
# Command to Run the app
# $ singularity exec demo.simg babel ...
# $ singularity exec demo.simg /usr/bin/babel  ...
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
#    
# 
# List Installed OS Container(s):
#     centos7-gcc4.8.5-py2.7-java1.8.0-perl-xwin-mpich-3.2
#  
#
###############################################################################

# Staging area:
#   /tmp/singularity/stage for packing and downloading  
#   /tmp/singularity/scripts.d for installation script(s).

TMP_STAGE=/tmp/singularity/stage
TMP_SCRIPTS_D=/tmp/singularity/scripts.d

#  this script has to be in /tmp/singularity/scripts.d
ME=$(basename "$0")
test -f $TMP_SCRIPTS_D/$ME            || exit "$ME has to be in $TMP_SCRIPTS_D"

# Installation destination: /usr/bin 
# Even the app is installed by yum, we still archive this installation script to 
# $OPT_RIT/$app_type/$app_name/$app_version for tracking the app in the sontainer.

OPT_RIT=/opt/rit
app_type=app
app_name=openbabel
app_version=2.3.2
app_install=$OPT_RIT/$app_type/$app_name/$app_version

# Archive if needed
test -d $app_install && mv $app_install $app_install.bak.$(date  +"%Y%m%d-%H%M")

# Installed the required packages if needed

# App Installation:

yum -y install openbabel

# Create link(s) in /opt/rit/bin if needed
ln -s -f  /usr/bin/babel /opt/rit/bin/babel

# Archive the pre-downloded file and this  script to the container for rebuilding
# and for tracing issues:

mkdir -p  $app_install/src
cp $TMP_SCRIPTS_D/$ME  $app_install/src

echo "$(date)--End of installing $app_name."


