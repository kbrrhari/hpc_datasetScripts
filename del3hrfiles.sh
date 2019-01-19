for hr in $(seq -f "%03g" 3 6 129)
do
  if [[ -f gfs.t00z.pgrb2.0p25.f${hr} ]]
  then
    echo "deleting gfs.t00z.pgrb2.0p25.f$hr"
    rm -rf "gfs.t00z.pgrb2.0p25.f${hr}"
  else
    echo "no file to delete"
  fi
done
