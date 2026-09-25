#!/bin/bash

#SBATCH -N 1
#SBATCH --ntasks-per-node=64
#SBATCH -t 48:00:00
#SBATCH --mem=120000
#SBATCH -p standard
#SBATCH -A lfg_lab

module load bwa
module load samtools

genome=hap1.29chr.fa
R1=/project/lfg_lab/ReferenceGenome/HiC/kubow-c-americana_R1_001.fastq.gz
R2=/project/lfg_lab/ReferenceGenome/HiC/kubow-c-americana_R2_001.fastq.gz

bwa index $genome

bwa mem -A1 -B4 -E50 -L0 -t 64 $genome $R1 | \
  samtools view -bS - > HiC_R1.bam

bwa mem -A1 -B4 -E50 -L0 -t 64 $genome $R2 | \
  samtools view -bS - > HiC_R2.bam
