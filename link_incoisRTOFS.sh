#! /bin/bash

source_dir="/incois_ncmrwfx/incois/hycom/dataset/rtofsINCOISarch_remapped" 
dt="2018-12-14"
yyyymmdd=$(date -d "$dt" +"%Y%m%d")

if [[ -d "$source_dir/$yyyymmdd" ]]
then
  echo "Yes! source dir: $source_dir/$yyyymmdd exists"
else
  echo "directory: $source_dir/$yyyymmdd does not exists" >&2
  # exit 1
fi

dest_dir="/incois_ncmrwfx/incois/hycom/dataset/94B/incoisRTOFS"
mkdir -p ${dest_dir}/rtofs.${yyyymmdd}
cd ${dest_dir}/rtofs.${yyyymmdd}
echo "changing to directory: $(pwd)"

doy=$(date -d "$dt" +"%j")
yr=$(date -d "$dt" +"%Y")

###################from respective folders############################################
# link n00 file:
# ln -sf $source_dir/$yyyymmdd/022_archv.${yr}_${doy}_00.a rtofs_incois.t00z.n00.archv.a 
# ln -sf $source_dir/$yyyymmdd/022_archv.${yr}_${doy}_00.b rtofs_incois.t00z.n00.archv.b 
#######################################################################################

#####################from 20181217 folder, as it has 6hrly files from -5 days)#########
# link n00 file:
ln -sf $source_dir/20181217/022_archv.${yr}_${doy}_00.a rtofs_incois.t00z.n00.archv.a 
ln -sf $source_dir/20181217/022_archv.${yr}_${doy}_00.b rtofs_incois.t00z.n00.archv.b 
#######################################################################################

# link restart file:
jday=$((($(date -d "$dt" +"%s")-$(date -d"1900-12-31" +"%s"))/(3600*24)))
ln -sf $source_dir/restarts/restart_${jday}.a rtofs_incois.t00z.n00.restart.a 
ln -sf $source_dir/restarts/restart_${jday}.b rtofs_incois.t00z.n00.restart.b 

for hr in $(seq -f "%02g" 3 3 126)
do
  ahr=$(date -d "$dt +$hr hours" +"%H")
  doy=$(date -d "$dt +$hr hours" +"%j")
  if ((10#$hr % 6 == 0))
  then
    # ln -sf $source_dir/$yyyymmdd/022_archv.${yr}_${doy}_${ahr}.a rtofs_incois.t00z.f${hr}.archv.a 
    # ln -sf $source_dir/$yyyymmdd/022_archv.${yr}_${doy}_${ahr}.b rtofs_incois.t00z.f${hr}.archv.b #.b files generated from script

    ################################from 20181217 folder############################################
    ln -sf $source_dir/20181217/022_archv.${yr}_${doy}_${ahr}.a rtofs_incois.t00z.f${hr}.archv.a 
    ln -sf $source_dir/20181217/022_archv.${yr}_${doy}_${ahr}.b rtofs_incois.t00z.f${hr}.archv.b
    ################################################################################################
  else
    # ln -sf $source_dir/surf/$yyyymmdd/022_archs.${yr}_${doy}_${ahr}.a rtofs_incois.t00z.f${hr}.archs.a
    # ln -sf $source_dir/surf/$yyyymmdd/022_archs.${yr}_${doy}_${ahr}.b rtofs_incois.t00z.f${hr}.archs.b

    ################################from 20181217 folder############################################
    ln -sf $source_dir/surf/20181217/022_archs.${yr}_${doy}_${ahr}.a rtofs_incois.t00z.f${hr}.archs.a
    ln -sf $source_dir/surf/20181217/022_archs.${yr}_${doy}_${ahr}.b rtofs_incois.t00z.f${hr}.archs.b
    ################################################################################################
  fi
  echo "$doy"
done

doy=$(date -d "$dt" +"%j")
doy=$((doy - 1))

# for hr in {03..24..03}
for hr in $(seq -f "%02g" 3 3 24)
do
  bhr=$((24 - 10#$hr))
  pad_hr=$(date -d "$dt -1 day +$bhr hours" +"%H")
  if ((10#$hr % 6 == 0))
  then
    # ln -sf $source_dir/$yyyymmdd/022_archv.${yr}_${doy}_${pad_hr}.a rtofs_incois.t00z.n-${hr}.archv.a 
    # ln -sf $source_dir/$yyyymmdd/022_archv.${yr}_${doy}_${pad_hr}.b rtofs_incois.t00z.n-${hr}.archv.b #.b generated from script

    ################################from 20181217 folder############################################
    ln -sf $source_dir/20181217/022_archv.${yr}_${doy}_${pad_hr}.a rtofs_incois.t00z.n-${hr}.archv.a 
    ln -sf $source_dir/20181217/022_archv.${yr}_${doy}_${pad_hr}.b rtofs_incois.t00z.n-${hr}.archv.b #.b generated from script
    ##################################################################################################
  else
    # ln -sf $source_dir/surf/$yyyymmdd/022_archs.${yr}_${doy}_${pad_hr}.a rtofs_incois.t00z.n-${hr}.archs.a
    # ln -sf $source_dir/surf/$yyyymmdd/022_archs.${yr}_${doy}_${pad_hr}.b rtofs_incois.t00z.n-${hr}.archs.b

    ################################from 20181217 folder############################################
    ln -sf $source_dir/surf/20181217/022_archs.${yr}_${doy}_${pad_hr}.a rtofs_incois.t00z.n-${hr}.archs.a
    ln -sf $source_dir/surf/20181217/022_archs.${yr}_${doy}_${pad_hr}.b rtofs_incois.t00z.n-${hr}.archs.b
    ######################################################################################################
  fi
done
