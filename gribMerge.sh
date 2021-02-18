cat *2019061200*storm* > test.grb2
wgrib2 test.grb2 -match '(UGRD:10 m|VGRD:10 m)' -grib winds.grb2
wgrib2 winds.grb2 -match 'above ground' -grib windsA.grb2 
wgrib2 winds.grb2 -not ':anl:' -grib finalwinds.grb2
wgrib2 winds.grb2 -new_grid_winds earth -new_grid latlon 10.5:5500:0.02 -17.7:4500:0.02 windsItp.grb

# some other grib tricks
wgrib2 -match '(:(TMP|RH):(\b([1-9]|[1-9][0-9]|[1-9][0-9][0-9]|1000)\b) mb)' gdas.pgrb2.0p25.2017112918
wgrib2 -match '(:PRMSL:)' gdas.pgrb2.0p25.2017120118
wgrib2 gdas.mergedTMPnRH.grb2 -nc_nlev 31 -netcdf gdasMergedTMPnRHnew.nc # 31 is the max number of vertical levels

use gdasMergedTMPnRH.nc
set mem/size=80000
set region/x=40:120/y=-30:30 # set region as GDAS is global
save/file="gdasMergedTMPnRH_IO.nc" tmp,rh
