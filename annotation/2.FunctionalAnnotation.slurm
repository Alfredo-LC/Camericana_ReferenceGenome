#!/bin/bash

#SBATCH -A lfg_lab
#SBATCH -p standard
#SBATCH -c 32
#SBATCH --mem=120G
#SBATCH -t 48:00:00


# homology-based annotation from BLAST searches against the UniProt/Swiss-Prot database
# tabular output with useful fields
module load diamond

FAA=braker.aa
DB=swissProt_hits/uniprot_plants.dmnd
OUT=swissprot.diamond.tsv

diamond blastp \
  -d ${DB} \
  -q ${FAA} \
  -o ${OUT} \
  -p ${SLURM_CPUS_PER_TASK} \
  -e 1e-5 \
  --max-target-seqs 1 \
  --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle


# orthology-based annotation using eggNOG
module purge
module load miniforge
conda activate eggnog-mapper

FAA=braker.aa
OUTPREFIX=eggnog

emapper.py \
  -i ${FAA} \
  --itype proteins \
  -m diamond \
  --data_dir eggnog_data \
  --cpu ${SLURM_CPUS_PER_TASK} \
  --output ${OUTPREFIX} \
  --output_dir eggnog_out \
  --decorate_gff no 


# protein domain annotation using Pfam
module purge
module load java
module load gcc/11.4.0  openmpi/4.1.4 python/3.11.4

cd my_interproscan/interproscan-5.77-108.0 # note: download interproscan in working directory

FAA=../../braker.aa
OUTDIR=../../interproscan_out
mkdir -p ${OUTDIR}

./interproscan.sh \
  -i ${FAA} \
  -f tsv \
  -goterms \
  -iprlookup \
  -pa \ #annotate pathway annotation where available
  -cpu ${SLURM_CPUS_PER_TASK} \
  -o ${OUTDIR}/interproscan.tsv
