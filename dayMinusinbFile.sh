#! /bin/bash
###################################
#
# changes the model_day of all .b files in a
# folder containing next days files as todays
#
###################################

root_dir="/incois_ncmrwfx/incois/hycom/dataset/94B/incoisRTOFS" 
dt="2018-12-14"
yyyymmdd=$(date -d "$dt" +"%Y%m%d")
doy=$(date -d "$dt" +"%j")

if [[ -d "$root_dir/rtofs.${yyyymmdd}" ]]
then
  echo "changing to dir: $root_dir/rtofs.${yyyymmdd}"
  cd "$root_dir/rtofs.${yyyymmdd}"
else
  echo "directory: $root_dir/rtofs.${yyyymmdd} does not exists" >&2
  exit 1
fi

for file in rtofs_incois*arch?.b
do
  model_day=$(sed '11q;d' "$file" | cut -d " " -f 9)
  if [[ -z "$model_day" ]]
  then
    model_day=$(sed '11q;d' "$file" | cut -d " " -f 10)
  else
    echo "model day is at field 9 of line 11"
  fi
  new_day=$(echo "$model_day-1" | bc -l)
  echo "old day was:${model_day} =========> new day is:${new_day}"
  sed -i "s/$model_day/$new_day/g" "$file"
done
