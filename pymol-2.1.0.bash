#!/bin/bash -e

##################################################################################
# script: pymol-2.1.0.bash
# last update: 5-31-2018
#
# Revision:
#   2018-5-31 xfz Init
#
# Command to run pymol: 
# $ singularity exec demo.simg pymol   or 
# $ singularity exec demo.simg /opt/miniconda2/bin/pymol
#
# Short Description of App:
#   PyMOL is a Python-enhanced molecular graphics tool.
#   https://sourceforge.net/projects/pymol/
# 
# Command for Installation:
# $ sudo $(which singularity) shell -w /to/the/demo.sandbox \
#                    /tmp/singularity/scripts.d/pymol-2.1.0.bash
#
# Short Installation Instruction:
#   1. Download https://sourceforge.net/projects/pymol/files/pymol/2/pymol-v2.1.0.tar.bz2
#   to $TMP_STAGE, which was released on 2018-03-19
#   2. Need to answer "yes" while installing simplemmtf-python, pyqt, pysip2
#
# Ref:  "PyMolWiKi: Linux install"
#   https://pymolwiki.org/index.php/Linux_Install
#
# List installed OS container(s):
#     centos7-gcc4.8.5-py2.7-java1.8.0-xwin-perl-mpich-3.2
#  
##################################################################################

# Requirment:
#   Not check the required packages exist or not, just DO it.
#   Install "X window", "Fonts" and OpenGL.  
#   W/O "X window", pymol crashes and log out the user automatically, not displays 
#   any error message.

yum -y groupinstall  "X Window System"  "Fonts"
yum -y install  libGL libGLU qt5-qtbase-gui

# apbs: the numerical solution of the Poisson-Boltzmann equation (PBE) used in PyMol
yum -y install  apbs 

# the pymol tar file is tar.bz2
yum -y install bzip2                   

# installed required packages listed in  "PyMolWiKi: Linux install"
yum -y install  subversion gcc gcc-c++ kernel-devel   
yum -y install  python python-devel python-pmw tkinter   
yum -y install  glew-devel  freeglut-devel                       
yum -y install  libpng-devel freetype-devel libxml2-devel        

# PyMolWiKi: msgpack-c 1.0+ (optional, for fast MMTF loading, new in SVN r4167, disable with --use-msgpackc=no)
yum -y install msgpack-devel.x86_64

# PyMolWiki: PyQt5, PyQt4, or PySide (optional, will fall back to Tk interface)
# Use conda to install as pip3 works for pyqt5 and pyside, but not pip (py2.7)
conda config --add channels conda-forge
conda install pyside2 python=2.7 
conda install pyqt    python=2.7

# PyMolWiki:  simplemmtf (optional, for MMTF export) 
# simplemmtf: https://github.com/schrodinger/simplemmtf-python
conda install -c schrodinger simplemmtf-python 

#Staging area:
#   /tmp/singularity/stage for packing and downloading  
#   /tmp/singularity/scripts.d for installation script(s).

TMP_STAGE=/tmp/singularity/stage
TMP_SCRIPTS_D=/tmp/singularity/scripts.d

# App installation bash file
ME=$(basename "$0")
test -f $TMP_SCRIPTS_D/$ME || exit "$ME has to be in $TMP_SCRIPTS_D"

# Pre-downloaded tar file
# https://downloads.sourceforge.net/project/pymol/pymol/2/pymol-v2.1.0.tar.bz2
# released on  2018-03-19, no rpm yet
tar_file=pymol-v2.1.0.tar.bz2
src_4_bak=$tar_file
app_name=pymol
app_type="modules/python2.7"
app_version=2.1.0
app_install=/opt/rit/$app_type/$app_name/$app_version

cd $TMP_STAGE
test -f $TMP_STAGE/$tar_file && mv $TMP_STAGE/$tar_file  $TMP_STAGE/$tar_file.bak.$(date +"%Y%m%d-%H%M")
test -d $TMP_STAGE/pymol     && mv $TMP_STAGE/pymol      $TMP_STAGE/pymol.bak.$(date +"%Y%m%d-%H%M")
wget https://downloads.sourceforge.net/project/pymol/pymol/2/pymol-v2.1.0.tar.bz2

# Archive the old installation if exists.
test -d $app_install  && mv $app_install  $app_install.bak.$(date +"%Y%m%d-%H%M")

# App Installation:
# pymol will be installed in /opt/miniconda2/.
# Source will be archived to /opt/rit/modules/python2.7/pymol/2.1.0/src
# *** after "python2.7 setup build", the following error message can be ignored .
# *** this is related to how the ./pymol dir was tracked by svn.
# **
# *** fatal: Not a git repository (or any parent up to mount point /tmp)
# *** Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
# *** svn: E155007: '/tmp/singularity/stage/pymol' is not a working copy
# ***

cd $TMP_STAGE
#wget https://downloads.sourceforge.net/project/pymol/pymol/2/pymol-v2.1.0.tar.bz2
tar jxvf ./pymol-v2.1.0.tar.bz2
cd  ./pymol
python2.7 setup.py build 
python2.7 setup.py install


# Create link(s) in /opt/rit/bin if needed
ln -s -f /opt/miniconda2/pymol /opt/rit/bin/pymol

# Archive the source code to $app_install/src/
mkdir -p  $app_install/src 
cp  $TMP_STAGE/$src_4_bak  $app_install/src/
cp  $TMP_SCRIPTS_D/$ME     $app_install/src/

echo "$(date) -- End of installing $app_name"
