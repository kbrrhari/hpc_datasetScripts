for file in gfs.t18z.pgrb2.0p25.f{006..129..06}
do
  hr=$(echo ${file} | cut -d . -f 5 | cut -c 2-)
  hrminus3=$(echo "$hr-3" | bc -l)
  printf -v pad_hr "%03d" $hrminus3
  ln -sf $file  ${file%.f${hr}}.f${pad_hr}
done
