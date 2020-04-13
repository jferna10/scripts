#!/bin/sh

pslToBed ZNF649_Trono-L1PA4-bound.psl bob.bed
bedItemOverlapCount /hive/users/max/projects/kznf/browser/repeats2/seqs/cons/$TE.fa -chromSize=/hive/users/max/projects/kznf/browser/repeats2/chrom.sizes bob.bed > $ZNF-$TE.bedGraph
rm bob.bed