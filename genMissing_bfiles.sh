#! /bin/bash
#############assumes that on each day only 00th hour archv files are available############
#
# Copying .b files to 6hr interval won't work with HWRF coupled run as
#hycom.py reads date from .b files while linking files to nest directory
#
##########################################################################################

root_dir="/incois_ncmrwfx/incois/hycom/dataset/rtofsINCOISarch_remapped" 
dt="2018-12-17"
yyyymmdd=$(date -d "$dt" +"%Y%m%d")
doy=$(date -d "$dt" +"%j")

if [[ -d "$root_dir/$yyyymmdd" ]]
then
  echo "changing to dir: $root_dir/$yyyymmdd"
  cd "$root_dir/$yyyymmdd"
else
  echo "directory: $root_dir/$yyyymmdd does not exists" >&2
  exit 1
fi

hycom_epoch="1900-12-31"
start_day=$(ls *archv*.b | sort -t _ -k 3 | head -1 | cut -f 3 -d "_")
end_day=$(ls *archv*.b | sort -t _ -k 3 | tail -1 | cut -f 3 -d "_")

for d in $(seq $start_day 1 $end_day)
do
  delta_day=$(( $d - $doy ))
  model_sec=$(( $(date -d"$dt $delta_day days" +"%s") - $(date -d"$hycom_epoch" +"%s") ))
  model_day=$(( $model_sec/(24*60*60) ))
  model_day_f=$(echo "scale=3;$model_day+0.00" | bc -l)
  echo "day is $d model day is: $model_day"
  for hr in {00..18..6}
  do
    model_dayhr=$( echo "scale=2;$model_day+$hr/24" | bc -l)
    echo "new model day: $model_dayhr"
    if [[ -f "022_archv.2018_${d}_$hr.b" ]]
    then
      echo "file exists"
    else
      cp "022_archv.2018_${d}_00.b" "022_archv.2018_${d}_${hr}.b"
      echo "new val:$model_day_f old_val:$model_dayhr"
      sed -i "s/$model_day_f/$model_dayhr/g" "022_archv.2018_${d}_${hr}.b"
    fi
  done
done

