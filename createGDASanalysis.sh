#!/bin/bash

DIR="/incois_ncmrwfx/incois_tccsym/FORCING/ockhi_full"
dest="$DIR/gdas_analysis"
if [[ -d $dest ]]
then
  echo "directory exists"
else
  echo "directory does not exists;creating one"
  mkdir ${dest}
fi
cd $dest 

link_files() {

  src_date=$(date -d "$1" +"%Y%m%d%H")
  src_hr=$(date -d "$1" +"%H")
  src_date_plus_6hr=$(date -d "$1 +6 hour" +"%Y%m%d%H")
  ln -sf $DIR/gdas_hourly_files/${src_date}/gdas.t${src_hr}z.pgrb2.0p25.f006 gdas.pgrb2.0p25.${src_date_plus_6hr}
}

idt="2017-11-28 00"
fdt="2017-12-06 00" # end date exclusive

# start loop
#=============#
dt="$idt"
while [[ ${dt} != ${fdt} ]]
do
  echo " <======Processing for date: $dt======>"
  link_files "$dt"
  dt=$(date -d "${dt} +6 hour" +"%Y-%m-%d %H")
done

