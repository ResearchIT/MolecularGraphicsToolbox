#!/bin/bash
##
## Creat module file  /opt/rit/scif/lmod/modulefiles/app_nmae($1)/app_version($2)
##
## Revision:
## 2018-07-00 xfz init 
##

app_name=$1
app_version=$2

RIT_SCIF_MODULEFILE_D=/opt/rit/scif/lmod/modulefiles
SCIF_APP_ROOT=/scif/apps
test -d ${RIT_SCIF_MODULEFILE_D}/${app_name} || mkdir -p ${RIT_SCIF_MODULEFILE_D}/${app_name}

# Empty the module file if exists
module_f=${RIT_SCIF_MODULEFILE_D}/${app_name}/${app_version}
cat /dev/null >  ${module_f}

# 1st line: declare Modulefile 
echo "%Module1.0" >>  ${module_f}
echo "## Module file created by /opt/rit/bin/create_modulefile.sh" >> ${module_f}


# Line: prepend PATH
# scif does not manage the version of an app now.
echo "prepend-path PATH ${SCIF_APP_ROOT}/${app_name}/bin" >> ${module_f}



# line: prepend-path LD_LIBRARY_PATH
if [ -d  ${SCIF_APP_ROOT}/${app_name}/lib ] ;
then
echo "prepend-path LD_LIBRARY_PATH ${SCIF_APP_ROOT}/${app_name}/lib" >> ${module_f}
fi

