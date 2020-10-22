#! /bin/bash --login

clear
module load cdo/1.8.1_netcdf
cd /incois_ncmrwfx/incois_tccsym/scripts/
source setenv4_archv2nc_SJO.com

fix_dir="/incois_ncmrwfx/incois/hycom/HWRF_parent/hwrfrun/fix/hwrf-hycom"
ln -sf $fix_dir/hwrf_rtofs_hin40.basin.regional.depth.a regional.depth.a 
ln -sf $fix_dir/hwrf_rtofs_hin40.basin.regional.depth.b regional.depth.b 
ln -sf $fix_dir/hwrf_rtofs_hin40.basin.regional.grid.a regional.grid.a 
ln -sf $fix_dir/hwrf_rtofs_hin40.basin.regional.grid.b regional.grid.b 

gen_netCDF() {
  expt="$1"
  cyc="$2"
  sid="$3"
  jdate="$4"
  jday_hr=$(date -d"$jdate +12 hours" +"%j_%H")
  jday_yr=$(date -d"$jdate" +"%Y")
  pytmp="/incois_ncmrwfx/incois_tccsym/OUTPUTS/pytmp"
  SORC="$pytmp/$expt/$cyc/$sid/runwrf"
  DEST="$pytmp/$expt/com/$cyc/$sid/hycom_output"

  #---optional title and institution---#
  export CDF_TITLE="HYCOM INDHWRF0.08"
  export CDF_INST="INCOIS,Hyderabad"
  #------------------------------------#

  if [[ -d $DEST ]]
  then
    echo "DEST dir exists and will be overwritten"
  else
    echo "DEST dir does not exists; creating one"
    mkdir -p $DEST
  fi

  for af in $SORC/archv.${jday_yr}_${jday_hr}*.a
  do
    ydh=$(echo ${af#*archv.*} | cut -d '.' -f 1)
    export CDF051=${DEST}/archv.${ydh}_bot.nc
    export CDF021=${DEST}/archv.${ydh}_mlt.nc
    export CDF022=${DEST}/archv.${ydh}_3di.nc
    export CDF032=${DEST}/archv.${ydh}_3zts.nc
    export CDF033=${DEST}/archv.${ydh}_3zt.nc
    export CDF034=${DEST}/archv.${ydh}_3zs.nc
    export CDF035=${DEST}/archv.${ydh}_3zr.nc
    export CDF037=${DEST}/archv.${ydh}_3zu.nc
    export CDF038=${DEST}/archv.${ydh}_3zuvw.nc
    export CDF039=${DEST}/archv.${ydh}_3zc.nc
    export CDF040=${DEST}/archv.${ydh}_3zw.nc
    /moes/home/hycom/bin/archv2ncdf3z << E-o-D
$af
netCDF
 062	'iexpt ' = experiment number x10 (000=from archive file)
   3	'yrflag' = days in year flag (0=360J16,1=366J16,2=366J01,3-actual)
712 	'idm   ' = longitudinal array size
331  	'jdm   ' = latitudinal  array size
  41	'kdm   ' = number of layers
  34.0	'thbase' = reference density (sigma units)
   0	'smooth' = smooth the layered fields (0=F,1=T)
   1	'iorign' = i-origin of plotted subregion
   1	'jorign' = j-origin of plotted subregion
   0	'idmp  ' = i-extent of plotted subregion (<=idm; 0 implies idm)
   0	'jdmp  ' = j-extent of plotted subregion (<=jdm; 0 implies jdm)
   1	'itype ' = interpolation type (0=sample,1=linear)
  17	'kz    ' = number of depths to sample
  2.0  'z     ' = sample depth  1
  5.0  'z     ' = sample depth  2
 10.0  'z     ' = sample depth  3
 15.0  'z     ' = sample depth  4
 20.0  'z     ' = sample depth  5
 30.0  'z     ' = sample depth  6
 50.0  'z     ' = sample depth  7
 75.0  'z     ' = sample depth  8
100.0  'z     ' = sample depth  9
125.0  'z     ' = sample depth 10
150.0  'z     ' = sample depth 11
200.0  'z     ' = sample depth 12
250.0  'z     ' = sample depth 13
300.0  'z     ' = sample depth 14
400.0  'z     ' = sample depth 15
500.0  'z     ' = sample depth 16
600.0  'z     ' = sample depth 17
  00	'botio ' = bathymetry  I/O unit (0 no I/O)
   0	'mltio ' = mix.l.thk.  I/O unit (0 no I/O)
   0.0	'tempml' = temperature jump across mixed-layer (degC,  0 no I/O)
   0.0	'densml' =     density jump across mixed-layer (kg/m3, 0 no I/O)
  00	'infio ' = intf. depth I/O unit (0 no I/O, <0 label with layer #)
  38	'wvlio ' = w-velocity            I/O unit (0 no I/O)
  38	'uvlio ' = u-velocity            I/O unit (0 no I/O)
  38	'vvlio ' = v-velocity            I/O unit (0 no I/O)
  00	'splio ' = speed                 I/O unit (0 no I/O)
  32	'istio ' = in-situ   temperature I/O unit (0 no I/O)
  00	'temio ' = potential temperature I/O unit (0 no I/O)
  32	'salio ' = salinity              I/O unit (0 no I/O)
  00	'tthio ' = potential density     I/O unit (0 no I/O)
  00    'keio  ' = kinetic egy I/O unit (0 no I/O)42
E-o-D
  done

}


idt="2019-10-30 06"
fdt="2019-11-06 06"
dt="$idt"
while [[ ${dt} != ${fdt} ]]
do
  echo " <======selecting cycle: $dt======>"
  cyc_=$(date -d "${dt}" +"%Y%m%d%H")
  expt_="incoisHYCOMcoupled_gsi_DefaultPHY"
  sid_="04A"
  gen_netCDF "$expt_" "$cyc_" "$sid_" "$dt"
  dt=$(date -d "${dt} +6 hours" +"%Y-%m-%d %H")
done
