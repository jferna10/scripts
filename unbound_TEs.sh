#!/bin/bash

#RMSK="/hive/users/jferna10/rmsk/rmsk.txt" #local repeatmasker
CONS_PATH="/hive/users/max/projects/kznf/browser/repeats2/seqs/cons"
BED_PATH="/hive/users/max/projects/kznf/browser/repeats2/seqs/allBed"

ZNF=$1
TE=$2

if [ "$ZNF" = "" ] || [ "$TE" = "" ]; then
	echo -e "\nUsage: unbound_TE.sh <filename-no-extension-of-mapInfo> <TE-type> \n"
	exit
fi

awk -v OFS='\t' '{{print $5,$6-50,$7+50,$16}}'  $ZNF-$TE.mapInfo > $ZNF-$TE-bound-sample.bed # put TE summits from ChIP in ChIP.tmp, extend by 100 (140 total on average)


bedtools intersect -v -wa -a $BED_PATH/$TE.bed -b $ZNF-$TE-bound-sample.bed > $ZNF-$TE-unbound-sample.bed   #get unbound TEs annotated in RepeatMasker as categorized by Max. 

grep "chr*._" -v $ZNF-$TE-unbound-sample.bed > swap.tmp  #get rid of weird chromosomes
cat swap.tmp > $ZNF-$TE-unbound-sample.bed

grep "chr*._" -v $ZNF-$TE-bound-sample.bed > swap.tmp  #get rid of weird chromosomes
cat swap.tmp > $ZNF-$TE-bound-sample.bed

bedtools getfasta -s -fi /hive/groups/wet/illumina/bowtie2_genomes/hg19/hg19.fa -bed $ZNF-$TE-unbound-sample.bed -fo $ZNF-$TE-unbound-sample.fa  #get the unbound sequence
bedtools getfasta -s -fi /hive/groups/wet/illumina/bowtie2_genomes/hg19/hg19.fa -bed $ZNF-$TE-bound-sample.bed -fo $ZNF-$TE-bound-sample.fa  #get the bound sequence

blat $CONS_PATH/$TE.fa $ZNF-$TE-bound-sample.fa $ZNF-$TE-bound.psl  #blat it to the consensus.  I know this is stupid, Max already did this! Will replace this later on.

java -classpath ~/bin/scripts/ build_dreme_neg $ZNF-$TE-unbound-sample.fa #cuts the unbound TEs into 140 nt segments 

blat -out=pslx $CONS_PATH/$TE.fa chop-$ZNF-$TE-unbound-sample.fa chop-$ZNF-$TE-unbound-sample.pslx #blat the chopped segments so we can do strict dreme, save the sequence

java -classpath ~/bin/scripts/ strict_dreme_neg $ZNF-$TE-bound.psl chop-$ZNF-$TE-unbound-sample.pslx #generate a negative set that also maps to peak; this file is strict_map_chop-$ZNF-$TE-unbound-sample.fa

dremeZNF.sh $ZNF $TE #run dreme with pre-set parameters 

rm *.tmp #clean-up