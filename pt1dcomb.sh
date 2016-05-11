#! /usr/bin/env bash

home='/home/linuxshared/vanderll/Norris/Reports/v1.processingAndQC/correctLabels/forAnalysis.v1'

dmp="$home/dmr.bed"

#sort by chrom, start
sort -k2,2 -k3,3n -f $dmp -o dmpsort.bed

dmpsort="$home/dmpsort.bed"

#keep only chrom, start, stop, pvalue
awk 'BEGIN {OFS="\t"} {print $2, $3, $4, $5}' $dmpsort > dmpanalysis.bed

dmpan="$home/dmpanalysis.bed"

#define autocorrelation windows and correlation values
comb-p acf -d 1:500:50 -c 4 $dmpan > dmrpt1d.acf.txt

acf="$home/dmrpt1d.acf.txt"

#correct p-values using slk method
comb-p slk --acf $acf -c 4 $dmpan > dmrpt1d.acf.bed

acfbed="$home/dmrpt1d.acf.bed"

#find regions
comb-p peaks --dist 500 --seed 0.001 $acfbed > dmrpt1d.regions.bed

regions="$home/dmrpt1d.regions.bed"

#assign single p-value for entire region
comb-p region_p -p $dmpan -r $regions -s 50 -c 4 > dmrpt1d.regionspval.bed

regpval="$home/dmrpt1d.regionspval.bed"

#keep only those regions with p < 0.01 and cpg GE 3
awk 'BEGIN{OFS="\t"} ($5 >= 3 && $6 < 0.01) {print $1, $2, $3, $6}' $regpval > dmrpt1dfinal.bed

dmrfinal="$home/dmrpt1dfinal.bed" 

#sort for bedtools/bigwig
sort -k1,1 -k2,2n -f $dmrfinal -o dmrfinalsort.bed


