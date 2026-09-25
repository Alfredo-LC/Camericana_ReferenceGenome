#!/bin/bash

#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH -t 24:00:00
#SBATCH --mem=300G
#SBATCH -p standard
#SBATCH -A lfg_lab

## use fastp to trim raw reads downloaded from the SRA
sample=$1 # include the name of sample along with the sbatch sript

mkdir ../fastq_clean
dir=../fastq_clean

# define input and output filenames
read1="../raw_fastq/${sample}_1.fastq.gz"
read2="../raw_fastq/${sample}_2.fastq.gz"

output_read1="$dir/${sample}_clean_1.fastq.gz"
output_read2="$dir/${sample}_clean_2.fastq.gz"
html_report="$dir/fastp_report_${sample}.html"

module load miniforge
conda activate fastp

# Run fastp
fastp \
  -i $read1 \
  -I $read2 \
  -o $output_read1 \
  -O $output_read2 \
  -h $html_report \
  --detect_adapter_for_pe \
  --thread 8 \
  --length_required 50 \
  --qualified_quality_phred 20 \
  --unqualified_percent_limit 40 \
  --n_base_limit 5

## assemble genes from clean reads using hybpiper and the 659 SCN genes from Adenophora polyantha
conda deactivate
conda activate HybPiper

sample=$1
ref=../659-ref.fasta
readDir=../fastq_clean

hybpiper assemble \
  -r $readDir/${sample}_clean_1.fastq.gz $readDir/${sample}_clean_2.fastq.gz \
  -t_dna $ref \
  --prefix $sample \
  --bwa


  
  --unqualified_percent_limit 40 \
  --n_base_limit 5
