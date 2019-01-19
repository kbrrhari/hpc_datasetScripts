#! /bin/bash
init_date="$1"
# init_date="20181216"
idate=$(date -d "$init_date" +"%Y%m%d")
hr=$(date -d "$init_date" +"%H")
opts="--no-check-certificate -N -np -nH -R "index.html*" --cut-dirs=6 -P ./rtofs.$idate"

##Restart files
#for link in "http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.n00.restart."{a.tgz,b}
#do
#  wget $opts $link
#done

#n00 files
for link in "http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.n00.archv."{a,b}
do
  wget $opts $link
done

#n- archs files
for link in "http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.n-"{03..24..06}".archs."{a.tgz,b}
do
  wget $opts $link
done

#n- archv files
for link in "http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.n-"{06..24..06}".archv."{a,b}
do
  wget $opts $link
done

##f archs files
#for hr in $(seq -f "%02g" 3 6 168)
#do
#  wget $opts http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.f$hr.archs.a.tgz
#  wget $opts http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.f$hr.archs.b
#done

##f archv files
#for hr in $(seq -f "%02g" 6 6 168)
#do
#  wget $opts http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.f$hr.archv.a
#  wget $opts http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.$idate/rtofs_glo.t00z.f$hr.archv.b
#done

