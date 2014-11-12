#!/bin/bash

for file in `ls ./winLoseLineData | grep tmp` 
do
  cat ./winLoseLineData/$file | while read line 
    do
      ./makeDataTable.bash $line
    done
done
