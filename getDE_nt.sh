#!/bin/bash

grep $1 condition_znf649n_vs_znf649d_sig.csv | cut -d'"' -f2 > tmp.tmp
grep -f tmp.tmp ~/tracks/hg19_rmsk_TE.gtf | cut -d$'\t' -f1,4,5 > tmp.bed
bedtools getfasta -fi /public/groups/wet/illumina/bowtie2_genomes/hg19/hg19.fa -bed tmp.bed -fo tmp.fa
blat -out=axt tmp.fa ~/public_html/webdata/L1PAFiles/Human.Tp/RepBroCons/L1PA4_cons.fa tmp.axt
java -cp ~/bin/scripts/ extract_aligned tmp.axt $2 $3

#grep "L1PA3" condition_znf649n_vs_znf649d_sig.csv | cut -d'"' -f2 > tmp.tmp