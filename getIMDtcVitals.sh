getData() {
  date="$1" # pass dates through loop
  DEST="/incois_ncmrwfx/incois_tccsym/FORCING/kyarr_IMD/TCvitals"

  USERNAME=rsmcnd
  PASSWORD=rsmcnd
  IP=103.215.208.49

  if [[ -d "$DEST" ]]
  then
    echo "folder exists"
  else
    echo "creating TCvitals folder"
    mkdir -p "$DEST"
  fi
  echo "Downloading file for date ${date}"
  dthr=$(date -d "$date" +"%d%H")
  wget -t 3 --user=$USERNAME --password="$PASSWORD" -P $DEST ftp://${IP}/gdas1.t${dthr}z.syndata.tcvital.txt  
}

#User defined ---> dt,fdt and storm folder name
dt="20191030 00"
fdt="20191102 00"
while [[ ${dt} != ${fdt} ]]
do
  echo "<======Downloading for date : ${dt}======>"
  getData "${dt}"
  dt=$(date -d "${dt} +06 hour" +"%Y%m%d %H")
done
