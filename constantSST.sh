# run only if previous command was success
set -e

#################################################################
# Set SST same as of gfs.2019042700 for all gfs*.f000 grib file
#################################################################

changeSST() {
  dt="$1"
  hr=${dt:(-2):2}
  SORC_DIR="./gfs.$dt"
  echo "changing to $SORC_DIR"
  cd $SORC_DIR
  wgrib2 ../gfs2019042700SST.f000.grb2 -set_date $dt -grib SST.f000.grb2
  wgrib2 -not "TMP:surface:anl" gdas.t${hr}z.pgrb2.0p25.f000 -grib noSST.f000.grb2
  mv gdas.t${hr}z.pgrb2.0p25.f000 gdas.t${hr}z.pgrb2.0p25.f000_orgSST
  cat noSST.f000.grb2 SST.f000.grb2 > gdas.t${hr}z.pgrb2.0p25.f000_changedSST
  ln -sf gdas.t${hr}z.pgrb2.0p25.f000_changedSST gdas.t${hr}z.pgrb2.0p25.f000
  rm -rf noSST.f000.grb2 SST.f000.grb2
  echo "changed SST, deleted intermediate files"
  cd ..
}

for i in gfs.2019*
do
  changeSST ${i#gfs.} 
done

