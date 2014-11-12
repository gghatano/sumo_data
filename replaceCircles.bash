#!/bin/bash

cat - | 
nkf -w8 | 
sed -e 's/○/W/g' -e 's/●/L/g' -e 's/や/R/g' -e 's/■/L/g' -e 's/□/W/g'

