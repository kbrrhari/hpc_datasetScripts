getData() {
  date="$1" # pass dates through loop
  DIR="/incois_ncmrwfx/incois_tccsym/FORCING/yaas_IMD"
  for hr in {00..18..06}
  do
    DEST="${DIR}/gdas.${date}${hr}"
    if [[ -d "$DEST" ]]
    then
      echo "folder exists"
    else
      echo "create gdas folder"
      mkdir -p "$DEST"
    fi
    echo "copying file from Mihir ==========> gdas.${date}${hr}"
  
    if [[ $2 = "True" ]]
    then
      SORC="/home/gfsprod/data/gdasv14/gdas/prod"
      # prepbufr
      rsync -auvhP mihir:${SORC}/gdas.${date}/*t${hr}z*prepbufr $DEST/
      # bias
      rsync -auvhP mihir:${SORC}/gdas.${date}/*t${hr}z*bias* $DEST/
    
      # bufr_d
      for f in gpsro goesnd goesfv 1bhrs2 1bamua 1bamub 1bhrs3 1bhrs4 1bmhs airsev \
        sevcsr mtiasi esamua esamub.eshrs3 ssmisu amsre atms cris saphir gmi ssmit \
        avcsam avcspm
      do
        rsync -auvhP mihir:${SORC}/gdas.${date}/*t${hr}*${f}*.bufr_d $DEST/
      done
      # nemsio
      rsync -auvhP mihir:${SORC}/gdas.${date}/gdas1.t${hr}z.sfcanl.nemsio $DEST/
      rsync -auvhP mihir:${SORC}/gdas.${date}/gdas.t${hr}z.atmf000.nemsio $DEST/
      rsync -auvhP mihir:${SORC}/gdas.${date}/gdas.t${hr}z.atmf{003..009..003}.nemsio $DEST/
    else
      # SORC="/home/hycom/IMD_GFS"
      SORC="/scratch/akhil/GDAS"
      # grib
      rsync -auvhP mihir:${SORC}/gdas.${date}/gdas.t${hr}z.pgrb2.0p25.f{000..009..01} $DEST/
    fi
  done
}

dt="20210525"
fdt="20210528"
while [[ ${dt} != ${fdt} ]]
do
  echo "<======Downloading for date : ${dt}======>"
  # arg2 to select the set of files to download
  getData ${dt} "True"
  dt=$(date -d "${dt} +1 day" +"%Y%m%d")
done
