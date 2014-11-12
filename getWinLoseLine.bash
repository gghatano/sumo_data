#!/bin/bash

dir=$(dirname $0)

./get_table.bash |
./replaceCircles.bash |
grep -v "google" | 
grep -v "javascript" | 
grep -v "大相撲" | 
grep -v "//" | 
grep -v "href" | 
sed -e 's/<[^>]*>//g' |
grep -v "幕下上位" |
grep -v -E "^ *$"  |
tr '[０-９]' '[0-9]' |
sed 's/^.*[0-9][勝敗休].*$/%/g' |
sed 's/^.*全休.*$/%/g' |
sed 's/^.*廃業.*$/%/g' |
grep -v "nbsp" |
tr '\n' ',' |
tr '%' '\n' |
sed 's/　,//g' | 
sed -e 's/^,//' -e 's/,$//'

