#!/bin/bash

dir=$(dirname $0)

for file in `ls winLoseLineData`
do
  echo $file
  yearMonth=$(echo $file | cut -d"." -f 1)
  cat $dir"/winLoseLineData/"$file | 
  grep -E "^(別席|前頭|十両|大関|小結|横綱|関脇|番付外|大関横綱|張出前頭|張出十両|張出大関|張出小結|張出横綱|張出関脇|横綱大関|欄外前頭|欄外十両)" | 
  sed 's/,$//' | 
  sed 's/,age=//g' | 
  sed 's/, //g' | 
  sed 's/ //g' | 
  sed 's/^\(十両[^,]*\),\([^,]*\),/\1,\2,,/' | 
  sed "s/^/$yearMonth,/"  > $dir"/dataCorrected/"$file.correct
done

