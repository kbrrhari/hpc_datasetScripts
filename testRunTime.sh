# grep -l -i successfully *fore*.output | xargs grep -l -i "Running cycle: 202105" | xargs grep -i "Run Time" | sort -t ":" -k 3 -n
grep -l -i successfully *gdas*.output | xargs ls -rt | xargs grep -l -i "Running cycle: 202105" | xargs grep -i "Run Time"
echo "<<===============================================================================================>>"
grep -l -i successfully *reloc*.output | xargs ls -rt | xargs grep -a -l -i "Running cycle: 202105" | xargs grep -a -i "Run Time"
echo "<<===============================================================================================>>"
grep -l -i successfully *fore*.output | xargs ls -rt | xargs grep -l -i "Running cycle: 202105" | xargs grep -i "Run Time"
