getData() {
  # date="20181008" # for single date
  date="$1" # pass dates through loop
  DIR="/incois_ncmrwfx/incois_tccsym/FORCING/jawad_IMD"
  # SORC="/home/hycom/IMD_GFS"
  SORC="/home/imdgfs/shared/data/T1534/pgrb/0p25deg"
  for hr in {00..18..06}
  do
    DEST="${DIR}/gfs.${date}${hr}"
    if [[ -d "$DEST" ]]
    then
      echo "folder exists"
    else
      echo "create gdas folder"
      mkdir -p "$DEST"
    fi
    echo "copying file from Mihir ==========> gdas.${date}${hr}"
  
    # grib
    rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/gdas.t${hr}z.pgrb2.0p25.f{000..129..03} $DEST/
    # grib
    rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/gdas.t${hr}z.pgrb2.0p25.f{000..006..01} $DEST/

    ##########Commented as we are pulling below data using getGDASdataFromMihir.sh#############
    # nemsio
    # rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/gdas1.t${hr}z.sfcanl.nemsio $DEST/
    # rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/gdas.t${hr}z.atmf000.nemsio $DEST/
    # rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/gdas.t${hr}z.atmf{003..009..003}.nemsio $DEST/
    # prepbufr
    # rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/*t${hr}z*prepbufr* $DEST/
    # bias
    # rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/*t${hr}z*bias* $DEST/
  
    # bufr_d
    # for f in gpsro goesnd goesfv 1bhrs2 1bamua 1bamub 1bhrs3 1bhrs4 1bmhs airsev \
      # sevcsr mtiasi esamua esamub.eshrs3 ssmisu amsre atms cris saphir gmi ssmit \
      # avcsam avcspm
    # do
      # rsync -auvhP mihir:${SORC}/gdas.${date}${hr}/*t${hr}*${f}*.bufr_d $DEST/
    # done
    ######################################################
  done
}

dt="20211201"
fdt="20211205" # end date exclusive
while [[ ${dt} != ${fdt} ]]
do
  echo "<======Downloading for date : ${dt}======>"
  getData ${dt}
  dt=$(date -d "${dt} +1 day" +"%Y%m%d")
done
