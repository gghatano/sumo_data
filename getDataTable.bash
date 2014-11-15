#!/bin/bash

[ -e ./winLoseDataTable.dat ] && rm ./winLoseDataTable.dat

for file in `ls ./dataCorrected | grep txt `
do
  echo $file
  cat ./dataCorrected/$file | while read line 
    do
      ./makeDataTable.bash $line >> ./winLoseDataTable.dat
    done
done
