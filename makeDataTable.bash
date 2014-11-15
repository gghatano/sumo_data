#!/bin/bash

dir=$(dirname $0)
process=$$
line=$1

[ $# -ne 1 ] && { echo "Usage: input win-lose line data" ; exit 0 ; }

## 勝敗 休みは除く

echo $line | 
tr ',' '\n' | 
grep -E "(W|L|E)"  > $dir/tmp/winlose.txt.$process

## 名前
name=$(echo $line | 
awk -F "," -v OFS="," '{print $1,$2,$3,$4}')
#echo $name

## 対戦相手
echo $line | 
tr ',' '\n' | 
grep -v -E '^ *$' | 
awk '{if(NR>4) print $0}' | 
grep -v -E "(W|L|R|E)" > $dir/tmp/opponent.txt.$process

## 結合
paste -d"," $dir/tmp/opponent.txt.$process $dir/tmp/winlose.txt.$process | 
sed "s/^/$name,/"

rm $dir/tmp/*.$process

