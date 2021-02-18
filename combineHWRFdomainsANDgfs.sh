set -e

sname="fani" #storm name
SRC="/moes/home/hycom/WW3_force/$sname" #HWRF data source
SRC_GFS="/incois_ncmrwfx/incois_tccsym/FORCING/${sname}_IMD" #GFS data source

start_date="2019042700"
end_date="2019050306"

res=0.06 #resolution of merged data

regrid() {
  datetime="$1"
  domain="$2"

  if [ ${domain} = 'gfs' ]; then

    echo "<======merging GFS files======>"
    ls ${SRC_GFS}/gfs.${datetime}/gdas.*f{000..126..3}
    cat ${SRC_GFS}/gfs.${datetime}/gdas.*f{000..126..3} > merged.grb2
    echo "<======Done======>"

  else

    echo "<======merging files======>"
    ls ${SRC}/*${datetime}*${domain}*.grb2
    cat ${SRC}/*${datetime}*${domain}*.grb2 > merged.grb2
    echo "<======Done======>"

  fi

  echo "<======extracting winds======>"
  wgrib2 merged.grb2 -match '(UGRD:10 m above ground|VGRD:10 m above ground)' -grib winds.grb2
  echo "<=====Now regridding to ${res} res for $datetime $domain======>"
  wgrib2 winds.grb2 -new_grid_winds earth -new_grid latlon 30:1850:${res} -30:1001:${res} $sname.$datetime.$domain.${res/./p}.grb2
  echo "<======deleting intermediate files======>"
  rm -rf merged.grb2 winds.grb2 
  echo "<======Done for domain $domain======>"
}


genPYscript() {
  cat << EOF > mergeDomains.py
#!/incois_ncmrwfx/incois/hycom/miniconda3/envs/XR/bin/python

import xarray as xr
import pathlib

path = pathlib.Path('/incois_ncmrwfx/incois_tccsym/HWRFwindsMerge/$sname')

dsGFS = xr.open_dataset('$sname.$datetime.gfs.${res/./p}.grb2',engine='cfgrib',backend_kwargs={'indexpath':''})
dsStorm = xr.open_dataset('$sname.$datetime.storm.${res/./p}.grb2',engine='cfgrib',backend_kwargs={'indexpath':''}).reindex(step=dsGFS.step)
dsSynoptic = xr.open_dataset('$sname.$datetime.synoptic.${res/./p}.grb2',engine='cfgrib',backend_kwargs={'indexpath':''}).reindex(step=dsGFS.step)


dsInner = dsStorm.where(dsStorm.notnull(),dsSynoptic)
dsFull = dsInner.where(dsInner.notnull(),dsGFS)

dsF = dsFull.drop_vars(['heightAboveGround','time']).rename_vars({'valid_time':'time'}).swap_dims({'step':'time'})
dsF.to_netcdf(path/'$sname.$datetime.windsMerged.${res/./p}.nc')
EOF
}

runTheScript() {
  tt="$1"
  regrid "$tt" "storm"
  regrid "$tt" "synoptic"
  regrid "$tt" "gfs"
  genPYscript
  chmod +x mergeDomains.py
  echo "<======combining domains using python======>"
  ./mergeDomains.py
  rm -rf ${sname}.${datetime}.*.${res/./p}.grb2
  rm -rf mergeDomains.py
}

dt="$start_date"
while [[ ${dt} != ${end_date} ]]
do
  echo "<======Processing for date : ${dt}======>"
  runTheScript ${dt}
  dt=$(date -d "${dt:0:8} ${dt:(-2)} +6 hour" +"%Y%m%d%H")
done
