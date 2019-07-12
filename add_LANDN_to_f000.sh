###########################################
# Add LANDN variable to IMD *.f000 grib file
############################################
#
# HWRF looks for LANDN variable, which some files
# fetched from IMD_GFS mihir folder does not have
#
# This script adds LANDN extracted from a previous files
# and appends to the given *.f000 with proper datestamp
#########################################################

add_land() {
  dt="$1"
  hr=${dt:(-2):2}
  SORC_DIR="./gfs.$dt"
  echo "changing to $SORC_DIR"
  cd $SORC_DIR
  wgrib2 ../LANDN_extractFrom_gfs.2018121506.grb2 -set_date $dt -grib LANDN_dateset.grb2
  mv gdas.t${hr}z.pgrb2.0p25.f000 gdas.t${hr}z.pgrb2.0p25.f000_org
  cat gdas.t${hr}z.pgrb2.0p25.f000_org LANDN_dateset.grb2 > gdas.t${hr}z.pgrb2.0p25.f000
  cd ..
}

for i in gfs.*
do
  flag=$(wgrib2 $i/*.f000 | grep LAND | wc -l)
  if [[ $flag -eq 1 ]]
  then
    add_land ${i#gfs.} 
  fi
done
