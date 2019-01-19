for folder in 2017*
do
  cd $folder
  echo "changing to folder===>$folder"
  rm -rf *1p00*
  rm -rf *sflux*
  rm -rf *radstat
  rm -rf *sfcf*
  cd ..
done
