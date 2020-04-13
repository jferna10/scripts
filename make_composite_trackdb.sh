#!/bin/bash


#make trackdb

track_name="theunissen2016Summits"
shortLabel="Theunissen 2016"
longLabel="Theunissen 2016 Primed Naive ChIP-SEQ"
track_group="RepeatBrowser"
track_type="bigBed"
extra="compositeTrack on\nvisibility hide"

echo -e "track $track_name \nshortLabel $shortLabel \nlongLabel $longLabel \ngroup $track_group \ntype $track_type \n$extra" > trackDb.theunissen2016.txt

ls theunissen2016/*.bb | cut -f 2 -d"/" | cut -f 1 -d"." | awk -v a="$track_name" '{print "\n\ttrack "$track_name"_sum\n\tparent " a "\n\tshortLabel "$track_name"\n\tlongLabel " $track_name "\n\tvisibility hide\n\ttype bigBed\n\tbigDataUrl theunissen2016/"$track_name".bb" }' >> trackDb.theunissen2016.txt



ls *.bed | cut -f 1 -d"." | while read i; do bedSort ${i}.bed ${i}.bed; bedToBigBed ${i}.bed ../hg38.chrom.sizes ${i}.bb; done 