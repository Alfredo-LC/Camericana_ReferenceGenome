#!/bin/bash

#SBATCH -N 1
#SBATCH --ntasks-per-node=4
#SBATCH -t 4:00:00
#SBATCH --mem=64G
#SBATCH -p standard
#SBATCH -A lfg_lab

module load miniforge
conda activate hicexplorer

hicCorrectMatrix diagnostic_plot \
  -m assembly_hic_50kb.h5 \
  -o hic_correction_diagnostic.png

# Explore the diagnostics and use the filterThreshold accordingly
hicCorrectMatrix correct \
  -m assembly_hic_50kb.h5 \
  --filterThreshold -0.488619530435 4 \
  -o assembly_hic_50kb_corrected.h5

# Plot matrix
hicPlotMatrix \
  -m assembly_hic_50kb_corrected.h5 \
  -o assembly_hic_50kb_contact_map.png \
  --log1p \
  --dpi 300 \
  --clearMaskedBins
