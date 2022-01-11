DIR="/incois_ncmrwfx/incois_tccsym/FORCING/vayu_IMD"

link_files() {
  dest="$DIR/incois_hycom_analysis"
  src_p="$DIR/incois_hycom_raw"
  if [[ -d $dest ]]
  then
    echo "directory exists"
  else
    echo "directory does not exists;creating one"
    mkdir ${dest}
  fi

  for i in {4..1..1}
  do
    src_date=$(date -d "$1 +${i} day" +"%Y%m%d")
    src_s="$src_p/$src_date"
    if [[ -d $src_s ]]
    then
      lead=$i
      break
    else
      lead=0
    fi
  done
  
  if [[ lead -eq 0 ]]
  then
    echo "no lead time found"
    exit 1
  fi

  src_date=$(date -d "$1 +${lead} day" +"%Y%m%d")
  src_s="$src_p/$src_date"
  yyyy=$(date -d "$1" +"%Y")
  yday=$(date -d "$1" +"%j")

  cd $dest 
  ln -sf $src_s/incois_archv.${yyyy}_${yday}_* .
}


idt="2019-06-09"
fdt="2019-06-17" # end date exclusive

# start loop
#=============#
dt="$idt"
while [[ ${dt} != ${fdt} ]]
do
  echo " <======Processing for date: $dt======>"
  link_files "$dt"
  dt=$(date -d "${dt} +1 day" +"%Y-%m-%d")
done

