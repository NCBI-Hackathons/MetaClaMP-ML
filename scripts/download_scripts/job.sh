#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --array=1-100
#SBATCH --time=00:59:00
#SBATCH --mem=6g
#SBATCH --partition=norm

TASK_ID=$SLURM_ARRAY_TASK_ID

module load sratoolkit

sra=`sed -n ${TASK_ID}p samples.txt`
echo "Downloading " $sra
fasterq-dump $sra --skip-technical --split-3 --min-read-len 50 --outdir $sra
