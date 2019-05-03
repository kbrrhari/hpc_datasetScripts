#!/bin/sh
interp() {
  #####################################################################
  # use wgrib2 to interpolate to time interpolate two forecast files
  #
  # ASSUMPTION: THE TWO FORECAST FILES MUST HAVE THE RECORDS IN THE
  # SAME ORDER
  # 
  # $1 = 2 hour forecast
  # $2 = 3 hour forecast
  # $3 = output   (2:15, 2:30 and 2:45 hour forecasts)
  #
  # note: wgrib2 v2.0.5 is needed for the -set_scaling same same
  #    for older versions of wgrib2, remove the "-set_scaling same same"
  #    the output will be written in the default mode .. 12 bits
  #######################################################################

  in1=$1
  in2=$2
  out1=gdas_interp/${in1%?}$((${in1:(-1)}+1))
  out2=gdas_interp/${in2%?}$((${in2:(-1)}-1))

  b1=0.6667
  c1=0.3333
  d1="$((${in1:(-1)}+1)) hour fcst"

  b2=0.3333
  c2=0.6667
  d2="$((${in2:(-1)}-1)) hour fcst"

  wgrib2 $in1 -rpn sto_1 -import_grib $in2 -rpn sto_2 -set_grib_type same \
  -rpn "rcl_1:$b1:*:rcl_2:$c1:*:+" -set_ftime "$d1" -set_scaling same same -grib_out $out1 \
  -rpn "rcl_1:$b2:*:rcl_2:$c2:*:+" -set_ftime "$d2" -set_scaling same same -grib_out $out2
}

# slow-process
# should have done interp after extracting relevant fields

idt="20181214 00" # start date
fdt="20181215 06" # end date
dt=${idt}
while [[ ${dt} != ${fdt} ]]
do
  dest="/incois_ncmrwfx/incois_tccsym/FORCING/phethai_IMD/gdas.${dt/ /}"
  if [[ -d $dest ]];then
    echo "<======Entering $dest folder======>"
    cd $dest
    if [[ ! -d "gdas_interp" ]];then
      mkdir gdas_interp
    fi
    ## f000 and f003 have different fields, so interpolation does not make sense
    # interp gdas.t${dt:(-2)}z.pgrb2.0p25.f000 gdas.t${dt:(-2)}z.pgrb2.0p25.f003 

    # interp gdas.t${dt:(-2)}z.pgrb2.0p25.f000 gdas.t${dt:(-2)}z.pgrb2.0p25.f003 
    # interp gdas.t${dt:(-2)}z.pgrb2.0p25.f006 gdas.t${dt:(-2)}z.pgrb2.0p25.f009
    # ln -sf gdas_interp/gdas.* .
  else
    echo "<====folder $dest does not exists; skipping======>"
  fi
  cd ..
  dt=$(date -d "${dt} +6 hours" +"%Y%m%d %H")
done

