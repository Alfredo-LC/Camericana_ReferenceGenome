#!/bin/bash

#SBATCH -N 1
#SBATCH --ntasks-per-node=16
#SBATCH -t 24:00:00
#SBATCH --mem=375000
#SBATCH -p standard
#SBATCH -A lfg_lab

module load miniforge
conda activate hicexplorer

hicBuildMatrix \
  --samFiles HiC_R1.bam HiC_R2.bam \
  --binSize 50000 \
  --restrictionSequence GATC,CT.AG,GA.TC,TTAA \
  --danglingSequence GATC,CT.AG,GA.TC,TTAA \
  --minMappingQuality 10 \
  --threads 16 \
  --inputBufferSize 400000 \
  --outBam valid_pairs.bam \
  --QCfolder hicQC_50kb \
  --outFileName assembly_hic_50kb.h5
