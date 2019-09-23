idt="2019-04-27 00"
fdt="2019-05-03 00"
dt="$idt"
while [[ ${dt} != ${fdt} ]]
do
  echo " <======selecting cycle: $dt======>"
  cyc=$(date -d "${dt}" +"%Y%m%d%H")
  expt="incoisHYCOMcoupled_gsi_DefaultPHY"
  sid="02B"
  pytmp="/incois_ncmrwfx/incois_tccsym/OUTPUTS/pytmp"
  dir="$pytmp/$expt/com/$cyc/$sid"
  for i in $dir/*hwrfprs.storm.0p02.f{000..126..003}*.grb2
  do 
    wgrib2 $i -match "(^669:|^670:|^683:|^684:|^685:|^686)" -lon 90 12 -lon 90 8 >> $dir/heatflux_RAMAloc/data.txt
  done
  dt=$(date -d "${dt} +6 hours" +"%Y-%m-%d %H")
done
