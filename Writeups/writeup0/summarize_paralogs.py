#!/usr/bin/env python3

import argparse
import pandas as pd
from Bio import SeqIO
import matplotlib.pyplot as plt

def parse_faa(faa_path):
    """
    Extract protein_id and protein_name from FASTA headers.
    Example header format:
    >protein_id some description...
    """
    protein_names = {}
    for record in SeqIO.parse(faa_path, "fasta"):
        protein_id = record.id
        description = record.description.replace(record.id, "").strip()
        protein_names[protein_id] = description if description != "" else "unknown"
    return protein_names


def parse_clusters(cluster_tsv):
    """
    Read MMseqs2 cluster TSV: cluster_id, protein_id
    """
    df = pd.read_csv(cluster_tsv, sep="\t", header=None, names=["cluster_id","protein_id"])
    return df


def compute_paralogs(cluster_df):
    """
    Identify clusters with >1 member and compute copy number.
    """
    cluster_sizes = cluster_df.groupby("cluster_id")["protein_id"].count()
    paralog_clusters = cluster_sizes[cluster_sizes > 1].index

    df_paralogs = cluster_df[cluster_df["cluster_id"].isin(paralog_clusters)].copy()
    df_paralogs["copy_number"] = df_paralogs["cluster_id"].map(cluster_sizes)

    return df_paralogs


def plot_top10(df, out_png):
    """
    Bar plot for top 10 most frequent paralogs.
    """
    top10 = df.sort_values("copy_number", ascending=False).head(10)

    plt.figure(figsize=(12,6))
    plt.bar(top10["protein_id"], top10["copy_number"])
    plt.xticks(rotation=90)
    plt.xlabel("Protein ID")
    plt.ylabel("Copy Number")
    plt.title("Top 10 Paralogs")
    plt.tight_layout()
    plt.savefig(out_png, dpi=300)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--faa", required=True, help="Input assembly.faa file")
    parser.add_argument("--clusters", required=True, help="Input *_cluster.tsv file")
    parser.add_argument("--out_tsv", default="paralogs_summary.tsv")
    parser.add_argument("--out_png", default="top10_paralogs.png")

    args = parser.parse_args()

    print("Parsing protein FASTA...")
    protein_names = parse_faa(args.faa)

    print("Parsing cluster file...")
    cluster_df = parse_clusters(args.clusters)

    print("Computing paralogs...")
    paralog_df = compute_paralogs(cluster_df)

    print("Adding protein names...")
    paralog_df["protein_name"] = paralog_df["protein_id"].map(protein_names)

    print(f"Writing TSV to {args.out_tsv}")
    paralog_df[["protein_id","protein_name","copy_number"]].drop_duplicates().to_csv(
        args.out_tsv, sep="\t", index=False
    )

    print(f"Saving plot to {args.out_png}")
    plot_top10(paralog_df, args.out_png)

    print("Done.")


if __name__ == "__main__":
    main()
