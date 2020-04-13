#!/bin/bash

ONE=`echo "$1" | cut -d'.' -f1`
TWO=`echo "$2" | cut -d'.' -f1`

mapInfoToBed.sh $1 > $ONE.bed
mapInfoToBed.sh $2 > $TWO.bed

bedtools intersect -u -b $ONE.bed -a ~/tracks/HumanL1PA7toHS_full.bed -wa > ${ONE}_L1PA7_HS_full.bed 
bedtools intersect -u -b $TWO.bed -a ~/tracks/HumanL1PA7toHS_full.bed -wa > ${TWO}_L1PA7_HS_full.bed
bedtools intersect -u -b ${ONE}_L1PA7_HS_full.bed -a ${TWO}_L1PA7_HS_full.bed > ${ONE}_${TWO}_L1PA7_HS_full_union.bed
bedtools intersect -v -b ${ONE}_L1PA7_HS_full.bed -a ${TWO}_L1PA7_HS_full.bed -wa > ${ONE}_${TWO}_L1PA7_HS_full_v${TWO}.bed
bedtools intersect -v -a ${ONE}_L1PA7_HS_full.bed -b ${TWO}_L1PA7_HS_full.bed -wa > ${ONE}_${TWO}_L1PA7_HS_full_v${ONE}.bed

ONE_TOTAL=`wc -l ${ONE}_L1PA7_HS_full.bed | cut -d' ' -f1`
TWO_TOTAL=`grep "" -c ${TWO}_L1PA7_HS_full.bed`
UNION=`grep "" -c ${ONE}_${TWO}_L1PA7_HS_full_union.bed`
ONE_ONLY=`grep "" -c ${ONE}_${TWO}_L1PA7_HS_full_v${ONE}.bed`
TWO_ONLY=`grep "" -c ${ONE}_${TWO}_L1PA7_HS_full_v${TWO}.bed`

echo -e "Bound by (total) $ONE:\t $ONE_TOTAL \nBound by (total) $TWO:\t $TWO_TOTAL \nBound by Both:\t $UNION \nBound by only $ONE:\t $ONE_ONLY \nBound by only $TWO:\t $TWO_ONLY"
