#!/bin/bash

# Auto-detect directory where THIS script lives
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Path to your summarize script
SCRIPT="${SCRIPT_DIR}/summarize_paralogs.py"

# Auto-detect the directory you need to bind (one level up)
# This ensures Singularity sees everything in your repo
BIND_DIR="/farmshare/user_data/cochiu9"

# Path to Singularity container
SIF="/farmshare/home/classes/bios/270/envs/bioinformatics_latest.sif"

echo "Using script: ${SCRIPT}"
echo "Binding directory: ${BIND_DIR}"


### ---- FILE PATHS FOR INPUTS ---- ###

E_FAA="/farmshare/home/classes/bios/270/data/project1/ecoli_bakta_out/assembly.faa"
E_CLUST="/farmshare/home/classes/bios/270/data/project1/ecoli_mmseqs_out/ecoli_prot90_cluster.tsv"

K_FAA="/farmshare/home/classes/bios/270/data/project1/kpneumo_bakta_out/assembly.faa"
K_CLUST="/farmshare/home/classes/bios/270/data/project1/kpneumo_mmseqs_out/kpneumo_prot90_cluster.tsv"

### ---- OUTPUT FILES (written next to your script) ---- ###

E_OUT_TSV="${SCRIPT_DIR}/ecoli_paralogs.tsv"
E_OUT_PNG="${SCRIPT_DIR}/ecoli_top10_paralogs.png"

K_OUT_TSV="${SCRIPT_DIR}/kpneumo_paralogs.tsv"
K_OUT_PNG="${SCRIPT_DIR}/kpneumo_top10_paralogs.png"


echo "Running E. coli..."
singularity exec --bind ${BIND_DIR} ${SIF} \
    python3 ${SCRIPT} \
    --faa ${E_FAA} --clusters ${E_CLUST} \
    --out_tsv ${E_OUT_TSV} --out_png ${E_OUT_PNG}

echo "Running K. pneumoniae..."
singularity exec --bind ${BIND_DIR} ${SIF} \
    python3 ${SCRIPT} \
    --faa ${K_FAA} --clusters ${K_CLUST} \
    --out_tsv ${K_OUT_TSV} --out_png ${K_OUT_PNG}

echo "All done!"
