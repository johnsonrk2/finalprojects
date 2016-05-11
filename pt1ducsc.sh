#! /usr/bin/env bash

dmr='/vol3/home/johnsonr/finalproject'
data='/vol3/home/johnsonr/data-sets/genome'

bedGraphToBigWig $dmr/dmrfinalsort.bed $data/hg19.genome $dmr/pt1d.bw


