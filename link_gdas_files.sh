#!/bin/bash

#-------------Creates link for provided folder in each subdirectory of gfs_grib_files--------------#
# Usage : Pass argumnet as name of the folder to be linked
# Date  : 13-Sep-2018 14:48:06
#
#--------------------------------------------------------------------------------------------------#

for folder in ./gfs_grib_files/2013*
do 
  cd $folder
  echo "changing to folder===>$folder"
  if [ -L "$1" ]
  then
    echo "===>link exists"
    echo "removing link"
    rm "$1"
  else
    echo "no such link;creating one"
    ln -sf ../../"$1" .
  fi
  cd ../..
done

