#!/bin/bash

#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH -t 12:00:00
#SBATCH --mem=50G
#SBATCH -p standard
#SBATCH -A lfg_lab

# Here, genes flagged as paralogs and single-copy should have been identified previously using hybpiper's 
# paralog_retriever.py script

module load miniforge
conda activate mafft

mkdir -p ../mafft_alignments ../mafft_logs

while read gene
do
    infile="../hybpiper_SCgenes/${gene}.FNA"
    outfile="../mafft_alignments/${gene}.aln.fasta"
    logfile="../mafft_logs/${gene}.mafft.log"

    if [[ -s "$infile" ]]; then
        mafft --auto --thread 4 "$infile" > "$outfile" 2> "$logfile"
    fi
done < ../hybpiper_paralogs/single_copy_complete_genes.txt
