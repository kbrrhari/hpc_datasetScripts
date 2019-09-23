getData() {
  date="$1" # pass dates through loop
  DEST="/incois_ncmrwfx/incois_tccsym/FORCING/hikaa_IMD/incois_hycom_raw"
  SORC="/home/hycom/WRITE_HYCOM"
  if [[ -d "$DEST" ]]
  then
    echo "folder exists"
  else
    echo "creating incois_hycom_raw folder"
    mkdir -p "$DEST"
  fi
  echo "copying file from Mihir ==========> ${date}"

  rsync -atuvPh mihir:${SORC}/${date} $DEST/
  
}

#User defined ---> dt,fdt and storm folder name
dt="20190923"
fdt="20190924"
while [[ ${dt} != ${fdt} ]]
do
  echo "<======Downloading for date : ${dt}======>"
  getData ${dt}
  dt=$(date -d "${dt} +1 day" +"%Y%m%d")
done
