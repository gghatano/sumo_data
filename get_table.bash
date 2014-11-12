#!/bin/bash

dir=$(dirname $0)

# rowHtml="H24-5.html"
rawHtml=$1

# [ $# -ne 1 ] && { echo "Usage: input the filepath for raw HTML." ; exit 1 ; }

length=$(cat $rawHtml | wc -l)

cat $rawHtml | nkf -w8 | 
grep -A $length "幕内" |
grep -B $length "作成済み" 


