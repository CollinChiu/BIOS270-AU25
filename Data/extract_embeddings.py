#!/usr/bin/env python3
import h5py
import numpy as np
import argparse
import os
from query_bacteria_db import BacteriaDatabase

def parse_args():
    parser = argparse.ArgumentParser(description="Extract protein embeddings for a given record.")
    parser.add_argument("--database_path", type=str, required=True,
                        help="Path to bacteria.db SQLite database")
    parser.add_argument("--record_id", type=str, required=True, help="Record ID to extract embeddings for")
    parser.add_argument("--metric", type=str, choices=["mean", "mean_mid"], required=True,
                        help="Which metric to use from HDF5 ('mean' or 'mean_mid')")
    parser.add_argument("--h5_path", type=str,
                        default="/farmshare/home/classes/bios/270/data/processed_bacteria_data/protein_embeddings.h5",
                        help="Path to protein embeddings HDF5 file")
    parser.add_argument("--output_path", type=str, default=None,
                        help="Path to save resulting embeddings (.npy). Default: <record_id>_embeddings.npy")
    args = parser.parse_args()
    return args

def main():
    args = parse_args()

    # Determine output path
    if args.output_path is None:
        args.output_path = f"{args.record_id}_embeddings.npy"

    # Open HDF5 file
    if not os.path.exists(args.h5_path):
        raise FileNotFoundError(f"HDF5 file not found at {args.h5_path}")
    h5f = h5py.File(args.h5_path, "r")

    if args.metric not in h5f:
        raise ValueError(f"Metric '{args.metric}' not found in HDF5 file. Available metrics: {list(h5f.keys())}")

    metric_data = h5f[args.metric]
    protein_ids_dataset = h5f["protein_ids"]  # assuming a dataset of all protein IDs exists
    protein_ids_list = [pid.decode("utf-8") if isinstance(pid, bytes) else pid for pid in protein_ids_dataset[:]]

    # Create fast lookup dictionary: protein_id -> index
    protein_id_to_index = {pid: idx for idx, pid in enumerate(protein_ids_list)}

    # Load protein IDs for the requested record
    db = BacteriaDatabase(args.database_path)
    record_protein_ids = db.get_protein_ids_from_record_id(args.record_id)
    db.close()

    if len(record_protein_ids) == 0:
        raise ValueError(f"No protein IDs found for record {args.record_id}")

    # Retrieve embeddings
    embedding_list = []
    missing_proteins = []
    for pid in record_protein_ids:
        idx = protein_id_to_index.get(pid)
        if idx is not None:
            embedding_list.append(metric_data[idx])
        else:
            missing_proteins.append(pid)

    if missing_proteins:
        print(f"Warning: {len(missing_proteins)} proteins not found in HDF5 and will be skipped")

    embeddings_matrix = np.vstack(embedding_list)  # shape (N, D)
    print(f"Saving embeddings matrix of shape {embeddings_matrix.shape} to {args.output_path}")
    np.save(args.output_path, embeddings_matrix)
    h5f.close()

if __name__ == "__main__":
    main()
