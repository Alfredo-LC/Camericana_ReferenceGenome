#!/bin/bash

findRestSite -f hap1.29chr.fa -p GATC  -o DpnII.bed
findRestSite -f hap1.29chr.fa -p CT.AG -o DdeI.bed
findRestSite -f hap1.29chr.fa -p GA.TC -o HinfI.bed
findRestSite -f hap1.29chr.fa -p TTAA  -o MseI.bed

cat DpnII.bed DdeI.bed HinfI.bed MseI.bed \
  | sort -k1,1 -k2,2n \
  > cut_sites.bed

rm DdeI.bed DpnII.bed HinfI.bed MseI.bed