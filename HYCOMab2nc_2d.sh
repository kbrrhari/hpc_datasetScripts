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

  for af in $SORC/archv*.a
  do
    ydh=$(echo ${af#*archv.*} | cut -d '.' -f 1)
    echo "<============${ydh}=============>"
    echo "<============${af}=============>"
    export CDF023=${DEST}/archv.${ydh}_2d_EminusP.nc
    /moes/home/hycom/bin/archv2ncdf2d << E-o-D
$af
netCDF
 062	  'iexpt ' = experiment number x10 (000=from archive file)
   3	  'yrflag' = days in year flag (0=360J16,1=366J16,2=366J01,3-actual)
 712 	  'idm   ' = longitudinal array size
 331 	  'jdm   ' = latitudinal  array size
  41	  'kdm   ' = number of layers
  34.0	'thbase' = reference density (sigma units)
   0    'smooth' = smooth fields before plotting (0=F,1=T)
   0    'mthin ' = mask thin layers from plots   (0=F,1=T)
   1    'iorign' = i-origin of plotted subregion
   1    'jorign' = j-origin of plotted subregion
   0    'idmp  ' = i-extent of plotted subregion (<=idm; 0 implies idm) 
   0    'jdmp  ' = j-extent of plotted subregion (<=jdm; 0 implies jdm) 
   0    'botio ' = bathymetry       I/O unit (0 no I/O) 
   0    'flxio ' = surf. heat flux  I/O unit (0 no I/O) 
   0    'empio ' = surf. evap-pcip  I/O unit (0 no I/O) 
   0    'ttrio ' = surf. temp trend I/O unit (0 no I/O) 
   0    'strio ' = surf. saln trend I/O unit (0 no I/O) 
   0    'icvio ' = ice coverage     I/O unit (0 no I/O) 
   0    'ithio ' = ice thickness    I/O unit (0 no I/O) 
   0    'ictio ' = ice temperature  I/O unit (0 no I/O) 
   0    'sshio ' = sea surf. height I/O unit (0 no I/O) 
   0    'bsfio ' = baro. strmfn.    I/O unit (0 no I/O) 
   0    'uvmio ' = mix. lay. u-vel. I/O unit (0 no I/O) 
   0    'vvmio ' = mix. lay. v-vel. I/O unit (0 no I/O) 
   0    'spmio ' = mix. lay. speed  I/O unit (0 no I/O) 
   0    'bltio ' = bnd. lay. thick. I/O unit (0 no I/O) 
   0    'mltio ' = mix. lay. thick. I/O unit (0 no I/O) 
   0    'sstio ' = mix. lay. temp.  I/O unit (0 no I/O) 
   0    'sssio ' = mix. lay. saln.  I/O unit (0 no I/O) 
   0    'ssdio ' = mix. lay. dens.  I/O unit (0 no I/O) 
   0    'kf    ' = first output layer (=0 end output; <0 label with layer #)
   0    'kl    ' = last  output layer
   0    'uvlio ' = layer k   u-vel. I/O unit (0 no I/O) 
   0    'vvlio ' = layer k   v-vel. I/O unit (0 no I/O) 
   0    'splio ' = layer k   speed. I/O unit (0 no I/O) 
   0    'wvlio ' = layer k   w-vel. I/O unit (0 no I/O) 
   0    'infio ' = layer k   i.dep. I/O unit (0 no I/O) 
   0    'thkio ' = layer k   thick. I/O unit (0 no I/O) 
  23    'temio ' = layer k   temp   I/O unit (0 no I/O) 
   0    'salio ' = layer k   saln.  I/O unit (0 no I/O) 
   0    'tthio ' = layer k   dens,  I/O unit (0 no I/O) 
   0    'sfnio ' = layer k  strmfn. I/O unit (0 no I/O) 
   0    'kf    ' = first output layer (=0 end output; <0 label with layer #)
E-o-D
  done
  echo "<------Merging files along time dimension------>"
  cdo mergetime $DEST/arch*.nc $DEST/hycom_TS_.nc
  if [[ $? -eq 0 ]]; then
    echo "<------Deleting all single netCDF files------>"
    rm -rf $DEST/arch*.nc
    echo "<------Setting the attributes correct------>"
    cdo setattribute,source="HWRFv3.9a",experiment="$expt",cycle="$cyc",SID="$sid",history="processed using HYCOMab2nc.sh" $DEST/hycom_TS_.nc $DEST/hycom_EminusP.nc
    if [[ $? -eq 0 ]]; then
      rm -rf $DEST/hycom_TS_.nc
    else
      echo "<------Global attribute not set------->"
    fi
  fi
}


# gen_netCDF "aaa_" "bbbb_" "bbbbbsd_"
idt="2019-06-13 00"
fdt="2019-06-13 06"
dt="$idt"
while [[ ${dt} != ${fdt} ]]
do
  echo " <======selecting cycle: $dt======>"
  cyc_=$(date -d "${dt}" +"%Y%m%d%H")
  expt_="incoisHYCOMcoupledIMD_gsi_IMDtcvitals"
  sid_="01A"
  gen_netCDF "$expt_" "$cyc_" "$sid_"
  dt=$(date -d "${dt} +6 hours" +"%Y-%m-%d %H")
done
