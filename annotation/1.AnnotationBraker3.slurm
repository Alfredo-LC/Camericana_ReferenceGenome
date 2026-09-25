#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=12
#SBATCH -t 24:00:00
#SBATCH --mem=400000
#SBATCH -p standard
#SBATCH -A lfg_lab

module load miniforge
conda activate braker3
module load gcc bioperl

## This is when using both protein seq and RNAseq data in fastq format
RNAseqDir=RNAseq
ids=SK-Flower,SK-Leaf,SK-Root,SK-Stem,VA73-30-Leaf

braker.pl --gff3 --genome=genome/PGA_hap1_masked.fa --species=Camericana \
  --prot_seq=Viridiplantae.fa --rnaseq_sets_ids=$ids \
  --rnaseq_sets_dir=$RNAseqDir
