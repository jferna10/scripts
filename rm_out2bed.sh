#!/bin/bash
#This script changes a repeatmasker output file into a nicely formatted bed file. 

if [ $# -eq 0 ]
  then
    echo "Usage is rm_out2bed  <repeatmasker outfile>"
    echo "Output is filename with bed extension".
    exit 1
fi

prefix=$(basename $1 .out)

cat $1 | tr -s " " "\t" | sed "s/^[ \t]*//" | cut -f1,5-10 | awk '{print $2"\t"$3"\t"$4"\t"$7"\t"$1"\t"$6}' | tail -n +4 | awk '{$6 = ($6=="C" ? "-": $6)} 1'| tr " " "\t" | tr -s "\t" > ${prefix}.bed