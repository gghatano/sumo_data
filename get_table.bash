#!/bin/bash

dir=$(dirname $0)

rowHtml="H24-5.html"
# rowHtml=$1

# [ $# -ne 1 ] && { echo "Usage: input the filepath for raw HTML." ; exit 1 ; }

length=$(cat $dir/$rowHtml | wc -l)

cat $dir/$rowHtml | nkf -w8 | 
grep -A $length "幕内" | 
grep -B $length "幕下上位" 


