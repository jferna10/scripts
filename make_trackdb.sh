#!/bin/bash


#make trackdb

track_name=imbeault2017Summits
shortLabel=Imbeault_Trono 2017
longLabel=Imbeault_Trono Zinc Finger ChIP-Seq
track_group=summits
track_type=bigBed
extra="\ncompositeTrack on\n visibility hide"

echo -e "track $track_name \n shortLabel $shortLabel \n longlabel $longLabel \ngroup $track_group\n type $track_type \n $extra" > $1

ls ../hg38reps/wgEncodeUwHistone/*.bb | cut -f 4 -d"/" | cut -f 1 -d"."| sed 's/\([^[:blank:]]\)\([[:upper:]]\)/\1*\2/g' | awk '{split($1,t,"*"); print "\n\ttrack "$1"_cov\n\tparent ENCODE_UW_Histone\n\tshortLabel "t[5]" "t[6]"\n\tlongLabel ENCODE_UW_Histone "t[5]" "t[6]" "t[7]" "t[8]" "t[9]"\n\tvisibility dense\n\ttype bigWig\n\tbigDataUrl wgEncodeUwHistone/"$1".bw" }' >> trackDb.uw_histone.txt

echo -e "\ntrack ENCODE_UW_HistoneSummits\nshortLabel ENCODE_UW_HistoneSummits\nlongLabel ENCODE_UW_HistoneSummits\ngroup histone\ntype bigBed\ncompositeTrack on\nvisibility hide\n" >> trackDb.uw_histone.txt

ls ../hg38reps/wgEncodeUwHistone/*.bb | cut -f 4 -d"/" | cut -f 1 -d"." | sed 's/\([^[:blank:]]\)\([[:upper:]]\)/\1*\2/g'| awk '{split($1,t,"_"); print "\n\ttrack "$1"_sum\n\tparent ENCODE_UW_HistoneSummits\n\tshortLabel "t[5]" "t[6]"\n\tlongLabel ENCODE_UW_HistoneSummits "t[5]" "t[6]" "t[7]" "t[8]" "t[9]"\n\tvisibility dense\n\ttype bigBed\n\tbigDataUrl wgEncodeUwHistone/"$1".bb" }' >> trackDb.uw_histone.txt


sed 's/\*//g' trackDb.uw_histone.txt > temp.txt


