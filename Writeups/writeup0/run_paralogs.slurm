#!/bin/bash
#SBATCH --job-name=paralog_analysis
#SBATCH --output=paralog_%j.out
#SBATCH --error=paralog_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

# Paths
SCRIPT="/farmshare/user_data/cochiu9/repos/BIOS270-AU25/Writeups/writeup0/summarize_paralogs.py"
SIF="/farmshare/home/classes/bios/270/envs/bioinformatics_latest.sif"

# E. coli paths
E_FAA="/farmshare/home/classes/bios/270/data/project1/ecoli_bakta_out/assembly.faa"
E_CLUST="/farmshare/home/classes/bios/270/data/project1/ecoli_mmseqs_out/ecoli_prot90_cluster.tsv"
E_OUT_TSV="ecoli_paralogs.tsv"
E_OUT_PNG="ecoli_top10_paralogs.png"

# K. pneumoniae paths
K_FAA="/farmshare/home/classes/bios/270/data/project1/kpneumo_bakta_out/assembly.faa"
K_CLUST="/farmshare/home/classes/bios/270/data/project1/kpneumo_mmseqs_out/kpneumo_prot90_cluster.tsv"
K_OUT_TSV="kpneumo_paralogs.tsv"
K_OUT_PNG="kpneumo_top10_paralogs.png"

echo "Running E. coli paralog analysis..."
singularity exec $SIF python3 $SCRIPT \
    --faa $E_FAA \
    --clusters $E_CLUST \
    --out_tsv $E_OUT_TSV \
    --out_png $E_OUT_PNG

echo "Running K. pneumoniae paralog analysis..."
singularity exec $SIF python3 $SCRIPT \
    --faa $K_FAA \
    --clusters $K_CLUST \
    --out_tsv $K_OUT_TSV \
    --out_png $K_OUT_PNG

echo "All analyses complete."
