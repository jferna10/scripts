#!/bin/bash

ZNF=$1
TE=$2


dreme -n strict_map_chop-$ZNF-$TE-unbound-sample.fa -p $ZNF-$TE-bound-sample.fa -o ~/public_html/webdata/DREME-strict/$ZNF-$TE -m 5 #run dreme with the strict neg data set and output to public_html