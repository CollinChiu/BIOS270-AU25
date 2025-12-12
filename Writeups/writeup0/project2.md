# Project 2: Machine Learning

In this project, you will write a proposal for your bioinformatics/ML project

> *“Wow, my model has 97% accuracy!” - a happy moment just before realizing the test set had unintentionally leaked into the training data.*

---

## Project Proposal

Your proposal should include the following sections.

### 1. Project Overview

- **Overarching goal**  
  Clearly state the primary objective of the project.

- **Rationale**  
  Explain why the project is important or interesting.  
  What problem does it address, and why is it worth solving?

- **Specific aims** (at least two)  
  For each aim, provide:
  - A clear **aim statement**  
  - **Expected outcomes** - what you hope to demonstrate or achieve  
  - **Potential challenges** and how you plan to address them  


### 2. Data

Describe the dataset you will work with and how you plan to manage it.

- **Dataset description**
  - **Source** (e.g., public repository, lab-generated, simulated, etc.)
  - **Size** (number of samples, features, storage)
  - **Format** (CSV, FASTQ, images, JSON, Parquet, etc.)

- **Data suitability**
  - Is the current format optimal for downstream processing?
  - What transformations or preprocessing steps will be necessary?

- **Storage and data management**
  - Where will you store the dataset?
  - How will you back it up?
  - How will you share it with collaborators if needed?


### 3. Environment

Document how your computational environment will be set up.

- **Coding environment**
  - Local machine? HPC? Jupyter notebook? code-server?

- **Dependencies**
  - Key packages, libraries, or tools required for your analysis.

- **Reproducibility**
  - How will you ensure others can rerun your analysis?
    - Version control  
    - Requirements file / environment.yml  
    - Containerization  


### 4. Pipeline

Describe the sequence of steps your analysis will follow.

- **Algorithms and methods**  
  What models, algorithms, or computational steps do you plan to run? Are there steps that depends on output of other steps?

- **Scalability and efficiency**  
  How will you ensure your pipeline runs efficiently on your dataset size, format, number of samples?


### 5. Machine Learning

Brainstorm an ML task that can be performed on your data

- **Task definition**  
  What is the supervised or unsupervised learning problem that appropriate for your data?

- **Feature representation**  
  How will you convert raw data into numerical form suitable for modeling?

- **Model selection**  
  Which model(s) will you apply and why?

- **Generalization strategy** (for supervised learning)  
  How will you ensure your model performs well on unseen data?

- **Evaluation metrics**  
  What metrics will you track? Why are they appropriate for your task?


Overall Goal: to bioinformatically identify STAND phage defense proteins
Rationale: STANDs are unique defense proteins, characterized by their tripartite structure: An effector domain, an ATPase, and a recognition domain. They function by binding conserved phage protein folds, leading to cell death. It is of great interest to understand which phage proteins these STANDs recognize. However, the diversity of STANDs is challenging to unravel due to their high diversity in sequence space, besides the ATPase domain.

Aims:
  computationally predict STANDs
  expect to find high model accuracy on the validation set

  Identify phage proteins that these novel STANDS sense in defense
  expect to find conserved, vital phage proteins (as makes most sense to prevent phages from avoiding detection)

Data:
  Source: lab-generated FASTA of all known characterized STANDs
  public repo of ESM metagenomic atlas embeddings
  format is already optimal

  store data on Sherlock
  back up and share on github

Environment:
  Sherlock
  key dependencies of numpy, pytorch
  reproducible to do containerization and yaml file environment

Pipeline / ML:
  take known metegnomic protein sequence embeddings for atalas, generate average residue embedding 
  split known STANDs into training and test set, as well as random selection of prokaryotic proteins (supervised, for generalization)
  embed known STANDs using ESM fold (feature representation)
  train neural network to classify STAND and non-stand (dependent on last step)
  Verify on the validation step the recall, as we want to test all potential STANDs experiementally
