#!/bin/bash

#this script takes a mapInfo file (representing ChIP-SEQ data of a KZNF) from the repeat browser and splits it up into smaller files containing only TEs.
#TEs with instances less than 10 in the ChIP-SEQ are put in a $ZNF-split/minor folder.  Requires a mapInfo of a single KZNF as input.


ZNF=$1

if [ "$ZNF" = "" ]; then
	echo -e "\nUsage: splitTE.sh <filename-no-extension-of-mapInfo>\n"
	exit
fi

mkdir -p $ZNF-split
mkdir -p $ZNF-split/minor

awk -v OFS='\t' '{if($10==""){print $0}}'  $ZNF.mapInfo >  $ZNF-split/$ZNF-noTE.mapInfo # prints peak summits not associated with TE

TE="bob"

awk -v OFS='\t' '{if($10!=""){print $0}}'  $ZNF.mapInfo >  $ZNF-split/$ZNF-allTE.mapInfo # prints peak summits associated with TE


cp $ZNF-split/$ZNF-allTE.mapInfo tmp.mapInfo #holder to subdivide TE

i=$(grep "" -c tmp.mapInfo) # how many TE instances...

#do this loop while there are more than 10 TE instances to cut out
#echo "$i" #

while [ $i -gt 10 ]
do	
	TE=$(tail -n 1 tmp.mapInfo | awk -v OFS='\t' '{if($10!=""){print $13}}') # get a TE from the file
	grep "$TE" tmp.mapInfo > $ZNF-split/$ZNF-$TE.mapInfo
	grep -v "$TE" tmp.mapInfo > tmp2.mapInfo
	cat tmp2.mapInfo > tmp.mapInfo
	
	f=$(grep "" -c $ZNF-split/$ZNF-$TE.mapInfo)
	
	if [ $f -lt 10 ]  
	then
		mv $ZNF-split/$ZNF-$TE.mapInfo $ZNF-split/minor/$ZNF-$TE.mapInfo #if very few instances of TE put it in a minor folder
	fi
	
	i=$(grep "" -c tmp.mapInfo) #i is in the number of lines
done

cat tmp2.mapInfo > $ZNF-split/minor/$ZNF-$TE-leftovers.mapInfo #anything left over? could happen if there are minor TEs (<10) that weren't looked at yet. Rather than giving them their own file that will never be looked at we leave them here.

	
rm tmp.mapInfo  #clean-up
rm tmp2.mapInfo #clean-up

echo "TE specific mapInfo created"