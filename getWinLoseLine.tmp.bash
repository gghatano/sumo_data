#!/bin/bash

dir=$(dirname $0)
#file=$1
file="H18-1.html"
echo $file

fileName=$(basename $file .html)

./get_table.bash "htmls/"$file |
./replaceCircles.bash |
nkf -w8 | 
grep -v 'align="left"' | 
grep -v "google" | 
grep -v "javascript" | 
grep -v "//" | 
grep -v "href" | 
grep -A 10 "琴奨菊" | 
gsed 's/ //g' | 
gsed 's;^\([0-9][0-9]*\)</td>$;age=\1;'

