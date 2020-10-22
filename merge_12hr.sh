#! /bin/bash --login

clear
module load cdo/1.8.1_netcdf
cd /incois_ncmrwfx/incois_tccsym/scripts/

gen_netCDF() {
  expt="$1"
  cyc="$2"
  sid="$3"
  SORC="$pytmp/$expt/com/$cyc/$sid/hycom_output"
  echo "<------link 12th hr nc files------>"
  ln -sf $SORC/archv*.nc .
}

pytmp="/incois_ncmrwfx/incois_tccsym/OUTPUTS/pytmp"
DEST="$pytmp/maha12hrConcat"

if [[ -d $DEST ]]
then
  echo "DEST dir exists and will be overwritten"
else
  echo "DEST dir does not exists; creating one"
  mkdir -p $DEST
fi

cd $DEST

idt="2019-10-30 06"
fdt="2019-11-06 06"
dt="$idt"

while [[ ${dt} != ${fdt} ]]
do
  echo " <======selecting cycle: $dt======>"
  cyc_=$(date -d "${dt}" +"%Y%m%d%H")
  expt_="incoisHYCOMcoupled_gsi_DefaultPHY"
  sid_="04A"
  gen_netCDF "$expt_" "$cyc_" "$sid_"
  dt=$(date -d "${dt} +6 hours" +"%Y-%m-%d %H")
done

echo "<------Merging files along time dimension------>"
cdo mergetime $DEST/*3zts.nc $DEST/hycom_TS.nc
cdo mergetime $DEST/*3zuvw.nc $DEST/hycom_UVW.nc
