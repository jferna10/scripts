#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage is cons1 start_range_cons1 end_range_cons1 cons2 start_range_cons2 end_range_cons2 input_file.fa"
    echo "Example is L1PA4 300 400 L1PA5 300 400"
    echo "Output is in the output directory containing psls, fa, and bed with matched instances and not matches"
    echo "Dependencies are sequences in a file as well as consensus elements housed in directory"
    exit 1
fi

seqs = $(basename $7 .fa) # trim .fa from input_file.fa


blat -out=axt ~/hive/jferna10/RepeatBrowser/consensus/hg19/$1.fa $7  $seqs.axt
blat -out=axt ~/hive/jferna10/RepeatBrowser/consensus/hg19/$4.fa $7  $seqs.axt

