#!/bin/bash

#converts mapInfo to bed

tail -n +2 $1 |awk '{ print $5"\t"$6"\t"$7"\t"$1"\t1\t"$8}' 