#!/bin/bash

# -------------------------------------------
# Run summarize_paralogs.py for both genomes
# -------------------------------------------

# Path to Singularity container
SIF=/farmshare/home/classes/bios/270/envs/bioinformatics_latest.sif

# Absolute path to project1 data
DATA=/farmshare/home/classes/bios/270/data/project1

# Absolute path to your repo (where the script is)
REPO=/farmshare/user_data/cochiu9/repos/BIOS270-AU25/Writeups/writeup0

# Path to Python script
SCRIPT=$REPO/summarize_paralogs.py

# Run for E. coli
echo "Running E. coli..."
singularity exec -B $DATA:$DATA -B $REPO:$REPO $SIF \
    python3 $SCRIPT \
    --faa $DATA/ecoli_bakta_out/assembly.faa \
    --clusters $DATA/ecoli_mmseqs_out/ecoli_prot90_cluster.tsv \
    --out_tsv $REPO/ecoli_paralogs.tsv \
    --out_png $REPO/ecoli_top10_paralogs.png

# Run for K. pneumoniae
echo "Running K. pneumoniae..."
singularity exec -B $DATA:$DATA -B $REPO:$REPO $SIF \
    python3 $SCRIPT \
    --faa $DATA/kleb_bakta_out/assembly.faa \
    --clusters $DATA/kleb_mmseqs_out/kleb_prot90_cluster.tsv \
    --out_tsv $REPO/kpneumo_paralogs.tsv \
    --out_png $REPO/kpneumo_top10_paralogs.png

echo "All done!"
