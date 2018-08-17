#!/bin/bash
##
## Create link names in /opt/rit/scif/bin for  all files in /scif/apps/your_app_name($0)/bin/
##
## Revision:
## 2018-07-00 xfz init 
##

app_name=$1
app_version=$2

RIT_SCIF_BIN=/opt/rit/scif/bin
test -d ${RIT_SCIF_BIN} || mkdir -p ${RIT_SCIF_BIN}


# scif does not manage the version now.
SCIF_APP_ROOT=/scif/apps
scif_app_bin=${SCIF_APP_ROOT}/${app_name}/bin

# Create link name in /opt/rit/scif/bin, which is exported in $PATH
for f_exe in ${scif_app_bin}/*
do
   ln -s ${f_exe} /opt/rit/scif/bin/

done
 


