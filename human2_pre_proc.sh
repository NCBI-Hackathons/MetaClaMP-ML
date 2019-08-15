#!/bin/bash


#create temp submit file 1
ls *.fasta > temp_submission

#create temp submit file2
awk '{print "humann2 --input " $0 "--threads 56 --output humann_out_"$0}' temp_submission > temp_submission_2 #humann2_submission.swarm

#clean for final swarm submit file
sed 's/......$//' temp_submission_2 > humann2_submission.swarm

#remove temp files
rm -r temp_submission

rm -r temp_submission_2
