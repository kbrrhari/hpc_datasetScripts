#!/bin/bash
idt="2018-12-15 00"
fdt="2018-12-17 06"
dt="$idt"
while [[ ${dt} != ${fdt} ]]
do
  echo " <======Downloading for date : $dt======>"
  ./download_data.sh "$dt"
  dt=$(date -d "${dt} +6 hours" +"%Y-%m-%d %H")
done
