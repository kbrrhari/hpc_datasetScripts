#! /bin/bash

##################Usage############################################
#
# Editing the following parameters:
#-------------------------------------
# source_dir ---> incois_hycom data directory with default names
# des_dir ---> directory where links will be placed after proper naming
# dt ---> date for which linking needs to be done
#############################################

source_dir="/incois_ncmrwfx/incois_tccsym/FORCING/hikaa_IMD/incois_hycom_raw" 
dt="2019-09-23"
yyyymmdd=$(date -d "$dt" +"%Y%m%d")

if [[ -d "$source_dir/$yyyymmdd" ]]
then
  echo "Yes! source dir: $source_dir/$yyyymmdd exists"
else
  echo "directory: $source_dir/$yyyymmdd does not exists" >&2
  exit 1
fi

dest_dir="/incois_ncmrwfx/incois_tccsym/FORCING/hikaa_IMD/incois_hycom"
mkdir -p ${dest_dir}/incois_hycom.${yyyymmdd}
cd ${dest_dir}/incois_hycom.${yyyymmdd}
echo "changing to directory: $(pwd)"

doy=$(date -d "$dt" +"%j")
yr=$(date -d "$dt" +"%Y")

###############################link n00 file############################################
ln -sf $source_dir/$yyyymmdd/incois_archv.${yr}_${doy}_00.a incois_hycom.t00z.n00.archv.a 
ln -sf $source_dir/$yyyymmdd/incois_archv.${yr}_${doy}_00.b incois_hycom.t00z.n00.archv.b 
#######################################################################################

##########################link restart file####################################
jday=$((($(date -d "$dt" +"%s")-$(date -d"1900-12-31" +"%s"))/(3600*24)))
ln -sf $source_dir/$yyyymmdd/restart_${jday}.a incois_hycom.t00z.n00.restart.a 
ln -sf $source_dir/$yyyymmdd/restart_${jday}.b incois_hycom.t00z.n00.restart.b 
###############################################################################
for hr in $(seq -f "%02g" 3 3 150)
do
  ahr=$(date -d "$dt +$hr hours" +"%H")
  doy=$(date -d "$dt +$hr hours" +"%j")
  if ((10#$hr % 6 == 0))
  then
    ln -sf $source_dir/$yyyymmdd/incois_archv.${yr}_${doy}_${ahr}.a incois_hycom.t00z.f${hr}.archv.a 
    ln -sf $source_dir/$yyyymmdd/incois_archv.${yr}_${doy}_${ahr}.b incois_hycom.t00z.f${hr}.archv.b

  else
    ln -sf $source_dir/$yyyymmdd/incois_archs.${yr}_${doy}_${ahr}.a incois_hycom.t00z.f${hr}.archs.a
    ln -sf $source_dir/$yyyymmdd/incois_archs.${yr}_${doy}_${ahr}.b incois_hycom.t00z.f${hr}.archs.b
  fi
  echo "day of the year is: $doy"
done

doy=$(date -d "$dt" +"%j")
doy=$((doy - 1))

for hr in $(seq -f "%02g" 3 3 24)
do
  bhr=$((24 - 10#$hr))
  pad_hr=$(date -d "$dt -1 day +$bhr hours" +"%H")
  if ((10#$hr % 6 == 0))
  then
    ln -sf $source_dir/$yyyymmdd/incois_archv.${yr}_${doy}_${pad_hr}.a incois_hycom.t00z.n-${hr}.archv.a 
    ln -sf $source_dir/$yyyymmdd/incois_archv.${yr}_${doy}_${pad_hr}.b incois_hycom.t00z.n-${hr}.archv.b

  else
    ln -sf $source_dir/$yyyymmdd/incois_archs.${yr}_${doy}_${pad_hr}.a incois_hycom.t00z.n-${hr}.archs.a
    ln -sf $source_dir/$yyyymmdd/incois_archs.${yr}_${doy}_${pad_hr}.b incois_hycom.t00z.n-${hr}.archs.b
  fi
done
