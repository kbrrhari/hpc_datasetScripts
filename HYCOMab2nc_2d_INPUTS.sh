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
  init="$1"
  sid="$2"
  input="/incois_ncmrwfx/incois_tccsym/FORCING"
  SORC="$input/vayu_IMD/incois_hycom_analysis"
  DEST="$SORC/NetCDF"

  #---optional title and institution---#
  export CDF_TITLE="INCOIS HYCOM"
  export CDF_INST="INCOIS,Hyderabad"
  #------------------------------------#

  if [[ -d $DEST ]]
  then
    echo "DEST dir exists and will be overwritten"
  else
    echo "DEST dir does not exists; creating one"
    mkdir -p $DEST
  fi

  for af in $SORC/incois_archv*.a
  do
    ydh=$(echo ${af#*archv.*} | cut -d '.' -f 1)
    export CDF023=${DEST}/incois_archs.${ydh}_2d_EminusP.nc
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
  23    'empio ' = surf. evap-pcip  I/O unit (0 no I/O) 
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
   0    'temio ' = layer k   temp   I/O unit (0 no I/O) 
   0    'salio ' = layer k   saln.  I/O unit (0 no I/O) 
   0    'tthio ' = layer k   dens,  I/O unit (0 no I/O) 
   0    'sfnio ' = layer k  strmfn. I/O unit (0 no I/O) 
   0    'kf    ' = first output layer (=0 end output; <0 label with layer #)
E-o-D
  done
  echo "<------Merging files along time dimension------>"
  cdo mergetime $DEST/incois_arch*.nc $DEST/hycom_TS_.nc
  if [[ $? -eq 0 ]]; then
    echo "<------Deleting all single netCDF files------>"
    rm -rf $DEST/incois_arch*.nc
    echo "<------Setting the attributes correct------>"
    cdo setattribute,source="Incois_Hycom",initialized="$init",SID="$sid",history="processed using HYCOMab2nc_3z_INPUTS.sh" $DEST/hycom_TS_.nc $DEST/hycom_EminusP.nc
    if [[ $? -eq 0 ]]; then
      rm -rf $DEST/hycom_TS_.nc
    else
      echo "<------Global attribute not set------->"
    fi
  fi
}


gen_netCDF "analysis_collectn" "vayu"

# idt="2019-06-12"
# dt="$idt"
# init_=$(date -d "${dt}" +"%Y%m%d")
# sid_="01A"
# gen_netCDF "$init_" "$sid_"

# while [[ ${dt} != ${fdt} ]]
# do
#   echo " <======selecting cycle: $dt======>"
#   init_=$(date -d "${dt}" +"%Y%m%d")
#   sid_="01A"
#   gen_netCDF "$init_" "$sid_"
#   dt=$(date -d "${dt} +1 day" +"%Y-%m-%d")
# done
