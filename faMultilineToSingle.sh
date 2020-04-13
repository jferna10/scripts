#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage is faMultilineToSingle input output"
    exit 1
fi

perl -pe '$. > 1 and /^>/ ? print "\n" : chomp' $1 > $2
