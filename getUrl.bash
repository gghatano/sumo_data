#!/bin/bash

dir=$(dirname $0)

for file in `ls $dir/tmp`
do
  echo $file 
  cat $dir/tmp/$file | 
  grep "href" |
  grep -E "[0-9].html" | 
  awk -F"href=" '{print $2}' | 
  awk -F"target" '{print $1}' | 
  awk -F"\"" '{print $2}' >> url_list
done
