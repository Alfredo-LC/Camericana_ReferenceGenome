# Camericana_ReferenceGenome

Custom scripts used in the analyses reported in:

> **Genomic signatures of polyploid origin and diploidization in *Campanula americana***.
> Alfredo López-Caamal, Laura F. Galloway and Karen B. Barnard-Kubow. Submitted to *Genome Biology and Evolution*.

This repository contains the code used to process, analyze and summarize the
data presented in the manuscript. The scripts are specific to this dataset 
and are provided for transparency and reproducibility. Raw sequencing data 
are available from the NCBI Sequence Read Archive under BioProject PRJNA1363131,
and the genome assembly and annotation are available from PRJNA1365259 and PRJNA1365260.

## Repository structure

| Directory | Contents |
|---|---|
| `assembly/` | Evaluation of genome assembly using HiCExplorer and genome profiling |
| `annotation/` | Structural and functional annotation |
| `phylogenetics/` | Orthology, species tree inference, gene tree analyses, phylogenetic reconciliation |
| `synteny/` | Synteny detection, syntenic depth, Ks distributions |
| `diploidization/` | Gene retention and fractionation, subgenome analyses, LTR-RT insertion ages |

## Software

Analyses were run with the software and versions listed in the Methods section
of the manuscript. Scripts are written in Bash, Python 3 and R.
