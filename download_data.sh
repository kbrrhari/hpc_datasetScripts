#! /bin/bash
init_date="$1"
idate=$(date -d "$init_date" +"%Y%m%d")
hr=$(date -d "$init_date" +"%H")
opts="--no-check-certificate -N -np -nH -R "index.html*" --cut-dirs=6"

#TC vitals
# wget $opts http://ftp.emc.ncep.noaa.gov/wd20vxt/hwrf-init/syndat/syndat_tcvitals.2019

#prep bufr and bufr_d
wget $opts -P ./gfs.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.$idate$hr/gfs.t${hr}z.prepbufr.nr
wget $opts -P ./gfs.$idate$hr -l 1 -r -A .bufr_d http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.$idate$hr/

# gfs 

# spectral files
 # wget $opts -P ./gfs.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.$idate$hr/gfs.t${hr}z.atmf000.nemsio 
 # wget $opts -P ./gfs.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.$idate$hr/gfs.t${hr}z.sfcanl.nemsio 

 # grib files [3hrly for HYCOM]
 for i in {000..126..003}; do wget $opts -P ./gfs.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.$idate$hr/gfs.t${hr}z.pgrb2.0p25.f$i; done

 # gdas files

 # HYCOM needs f001-f006 files and gfs init needs f003,f006 and f009
 for i in {01..06..01}; do wget $opts -P ./gdas.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.$idate/gdas.t${hr}z.pgrb2.0p25.f0$i; done
 wget $opts -P ./gdas.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.$idate/gdas.t${hr}z.pgrb2.0p25.f009
 wget $opts -P ./gdas.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.$idate/gdas.t${hr}z.abias_air
 wget $opts -P ./gdas.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.$idate/gdas.t${hr}z.abias_pc
 wget $opts -P ./gdas.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.$idate/gdas.t${hr}z.abias

 # spectral files:
 # for i in {03..09..03}; do wget $opts -P ./gdas.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.$idate/gdas.t${hr}z.atmf0$i.nemsio; done

# enkf 80 member
# for i in {01..80};do wget $opts -P ./enkf.$idate$hr http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/enkf$idate/$hr/gdas.t${hr}z.atmf0${hr}s.mem0$i.nemsio ;done

