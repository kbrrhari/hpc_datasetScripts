#!/bin/bash
idt="2018-11-11 00"
fdt="2018-11-19 00"
idate=$(date -d "$idt" +"%Y%m%d")
hr=$(date -d "$idt" +"%H")
dt="$idt"
while [[ ${dt} != ${fdt} ]]
do
  if [[ -e gfs.$idate$hr ]]
  then
    cd gfs.$idate$hr
    echo " <======Expanding folder: ${PWD##*/}======>"
    mv gfs/prod/gfs.$idate$hr/* .
    # find gfs.$idate$hr/ -empty -type d -delete
    cd ..
  else
    echo " <======gfs.$idate$hr folder does not exists======>"
  fi
  dt=$(date -d "${dt} +6 hours" +"%Y-%m-%d %H")
  idate=$(date -d "$dt" +"%Y%m%d")
  hr=$(date -d "$dt" +"%H")
done
