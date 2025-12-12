#!/bin/bash
set -e

# Paths
SCRIPT="/farmshare/user_data/cochiu9/repos/BIOS270-AU25/Writeups/writeup0/summarize_paralogs.py"
SIF="/farmshare/home/classes/bios/270/envs/bioinformatics_latest.sif"

# E. coli
E_FAA="/farmshare/home/classes/bios/270/data/project1/ecoli_bakta_out/assembly.faa"
E_CLUST="/farmshare/home/classes/bios/270/data/project1/ecoli_mmseqs_out/ecoli_prot90_cluster.tsv"
E_OUT_TSV="ecoli_paralogs.tsv"
E_OUT_PNG="ecoli_top10_paralogs.png"

# K. pneumoniae
K_FAA="/farmshare/home/classes/bios/270/data/project1/kpneumo_bakta_out/assembly.faa"
K_CLUST="/farmshare/home/classes/bios/270/data/project1/kpneumo_mmseqs_out/kpneumo_prot90_cluster.tsv"
K_OUT_TSV="kpneumo_paralogs.tsv"
K_OUT_PNG="kpneumo_top10_paralogs.png"

echo "Running E. coli..."
singularity exec $SIF python3 $SCRIPT --faa $E_FAA --clusters $E_CLUST --out_tsv $E_OUT_TSV --out_png $E_OUT_PNG

echo "Running K. pneumoniae..."
singularity exec $SIF python3 $SCRIPT --faa $K_FAA --clusters $K_CLUST --out_tsv $K_OUT_TSV --out_png $K_OUT_PNG

echo "DONE!"
