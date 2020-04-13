#!/usr/bin/bash
#psl2cov

if [ $# -eq 0 ]
  then
    echo "Usage is psl2cov target.psl chrom.sizes file.out"
    echo "Output is target.bw".
    exit 1
fi

prefix=$(echo $1 | cut -f 1 -d".")

#prefix=$(basename $1 .psl)	

pslToBed ${prefix}.psl temp_o_doodle.bed
bedtools sort -i temp_o_doodle.bed > temp_o_doodle_sort.bed
bedtools  genomecov -bg -split -i temp_o_doodle_sort.bed -g $2 > temp_o_doodle.bg
bedGraphToBigWig temp_o_doodle.bg $2 $3
rm temp_o_doodle*