#!/bin/bash

dir=$(dirname $0)
file=$1

echo $file

fileName=$(basename $file .html)

lines=$(cat $file | wc -l)

./get_table.bash.tmp $file |
./replaceCircles.bash  | 
nkf -w8 | 
sed 's/<[^>]*>//g' | 
grep -v '^ *$' | 
tr '[０-９]' '[0-9]' | 
sed 's/^.*[0-9][勝敗休].*$/%/g' |
sed 's/^.*全休.*$/%/g' |
sed 's/^.*廃業.*$/%/g' | 
sed 's/　//g' | 
sed 's/ //g' | 
gsed 's/\t//g' | 
grep -v "nbsp" | 
grep -v -E "^ *$" |
grep -v -E "[a-z]" | 
grep -v -E "(<|>|-|/)" | 
grep -v "十両へ" | 
grep -v "十両幕内" | 
tr '\n' ',' | 
tr '%' '\n' | 
grep -v -E "(S|O|A|D|P|）|（|、|：|[|])" | 
sed 's/^,//' | 
grep -v -E "^ *$" > $dir/$fileName.txt


