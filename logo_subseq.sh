#!/bin/bash

CONS_PATH="/hive/users/max/projects/kznf/browser/repeats2/seqs/cons"

ZNF=$1
TE=$2

if [ "$ZNF" = "" ] || [ "$TE" = "" ]; then
	echo -e "\nUsage: unbound_TE.sh <filename-no-extension-of-mapInfo> <TE-type> <coord start> <coord end>\n"
	exit
fi

blat -out=axt $CONS_PATH/$TE.fa $ZNF-$TE-bound-sample.fa $ZNF-$TE-bound-sample.axt

java -classpath ~/bin/scripts/ extract_aligned $ZNF-$TE-bound-sample.axt $3 $4