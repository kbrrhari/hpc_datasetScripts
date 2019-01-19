for folder in $(find ./ -name *.tar | cut -d/ -f2)
do
  cd $folder
  echo "changing to folder===>$folder"
  tar -xvf *.tar
  rm -rf *.tar
  cd ..
done
