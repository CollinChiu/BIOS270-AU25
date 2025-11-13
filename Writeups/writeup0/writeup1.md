# Write-up 1:

**Name:** Collin Chiu
**Student ID:** cochiu9
**Date:** 11/11/2025  

---

## Overview

This captures me setting up an efficient computing environment
---

## Content

# Setup

This document helps you set up an efficient computing environment for this course, including command-line shortcuts and tools to manage your environment, data, and workflow.

>*“Yet another Duo push…” - when authentication takes longer than the job itself.*
---

## Resources

- [**tmux cheatsheet**](https://tmuxai.dev/tmux-cheat-sheet/)



> **Instruction:** Include **screenshots** and **code snippets** in your Write-up to document your work.

---

## Set Up Your `~/.bashrc` (or `~/.bash_profile`)

Customize your Bash profile with shortcuts and environment variables.  
Your Bash profile automatically runs every time you log in.

Below is an example setup, feel free to modify or add your favorite shortcuts.

```bash
# Example custom bash profile

# -----------------------------
# Functions
# -----------------------------
# Example: print numbers from 1 to N (default = 5)
count() {
  local limit=${1:-5}
  for ((i=1; i<=limit; i++)); do
    echo "Count is: $i"
    sleep 1
  done
}

# -----------------------------
# Environment variables
# -----------------------------
export CLASS="/farmshare/home/classes/bios/270"

# -----------------------------
# Basic shortcuts
# -----------------------------
alias reload="source ~/.bashrc"
alias l='ls -ltrh'
alias ..="cd .."

# -----------------------------
# Quick navigation
# -----------------------------
alias cdc="cd $CLASS"

# -----------------------------
# Git and file utilities
# -----------------------------
alias gs="git status"
alias usage='du -h -d1'
alias space='df -h'

# -----------------------------
# SLURM queue and job utilities
# -----------------------------
alias qu='squeue -u $USER'

checkstatus() {
   sacct -j "$1" --format=JobID,JobName,State,Elapsed,MaxRSS,MaxVMSize,CPUTime,NodeList%20
}

# -----------------------------
# Interactive job launchers
# -----------------------------
alias small='srun --pty -p normal --mem=12G --cpus-per-task=2 --time=2:00:00 bash'
alias med='srun --pty -p normal --mem=32G --cpus-per-task=4 --time=2:00:00 bash'
alias large='srun --pty -p normal --mem=64G --cpus-per-task=8 --time=4:00:00 bash'
alias gpu='srun --pty -p gpu --gres=gpu:1 --mem=32G --cpus-per-task=4 --time=2:00:00 bash'
```

---

## Tools for Setting Up Your Environment

### 1. Install **Micromamba**

When installing, choose a prefix location on a disk with plenty of storage (i.e. usually not `$HOME`), since this is where packages will be installed.

```bash
"${SHELL}" <(curl -L https://micro.mamba.pm/install.sh)
# Prefix location? [~/micromamba] $SCRATCH/envs/micromamba
source ~/.bashrc
# Test your installation
micromamba --version
```

---

### 2. Install **Docker Desktop**

Download [Docker Desktop](https://www.docker.com/products/docker-desktop/) to your laptop.  We’ll use it to build and push container images in later exercises.

You’ll also need a place to store your container images. We'll practice pushing images to `Docker Hub` for public images and Stanford Gitlab Container Registry, where you can store your private images. Complete the following steps:   
- [**Stanford GitLab**](https://gitlab.stanford.edu/): sign-in and create a new project named `containers`.  
- [**Docker Hub**](https://hub.docker.com/signup): create an account.

---

## Tools for Managing Your Data

Set up [**Google Cloud Platform (GCP)**](https://cloud.google.com/) using your **personal email** (as Stanford requires approval to create new projects with Stanford email).

- New users receive $300 in free credits.
- You should have also received an email about redeeming a $50 credit coupon. Please use your Stanford email to redeem but apply the coupon to your **personal email account**
- Create a new project named `BIOS270`


---

## Tools for Pipeline Development

- Install [**Nextflow**](https://www.nextflow.io/) on Farmshare for pipeline developement.

```bash
curl -s https://get.nextflow.io | bash
# To confirm it's installed correctly
nextflow info
```
---

## Tools for Machine Learning Projects

You’ll need access to **GPUs** for training your ML models.

### Option 1: Google Cloud Platform (Recommended)
- Use [**Vertex AI Workbench**](https://cloud.google.com/vertex-ai/docs/workbench) for Jupyter-based GPU training.  
- Request increased GPU quota under **`metric: compute.googleapis.com/gpus_all_regions`** in `IAM & Admin` -> `Quotas & System limits`.  
- When approved, create and test a new gpu instance.

### Option 2: **Google Colab Pro**
Sign up with your Stanford email, it’s free for students. [Sign up here](https://colab.research.google.com/signup).  
Save Colab compute units for Project 2.

>For your future GPU usage after this course, Stanford offers 5,000 GPU hours for free on [Marlowe](https://datascience.stanford.edu/marlowe/marlowe-access), talk to your PI to apply! 

### (Optional) **Weights & Biases**

Create a [Weights & Biases account](https://wandb.ai/site/) to track your ML training metrics and experiment logs.

---
## Warm-up: SLURM exercise

Given a `data.txt` with the content below
```
12
7
91
8
27
30
```

Below is a common and useful logic one may use to submit a slurm array job

```bash
#SBATCH --job-name=warmup
#SBATCH --output=logs/%x_%A_%a.out
#SBATCH --error=logs/%x_%A_%a.err
#SBATCH --array=0-2
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:10:00

i=0
# loop through each line in data.txt, `value` store line content
while read -r value; do
    if (( i % SLURM_ARRAY_TASK_COUNT == SLURM_ARRAY_TASK_ID )); then
        echo "$i: $value"
    fi
    # increment
    ((i++))
done < data.txt
```


My inputs:
Last login: Fri Oct 31 22:38:22 on ttys001
(base) cochiu9@DNa1c23a3 ~ % ssh cochiu9@login.farmshare.stanford.edu
The authenticity of host 'login.farmshare.stanford.edu (171.67.96.122)' can't be established.
ED25519 key fingerprint is SHA256:bKb1Znir/1tOg+TMyALDYWeK0lclsulriDN8aOvWteU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'login.farmshare.stanford.edu' (ED25519) to the list of known hosts.
cochiu9@login.farmshare.stanford.edu's password:
(cochiu9@login.farmshare.stanford.edu) Duo two-factor login for cochiu9

Enter a passcode or select one of the following options:

1. Duo Push to XXX-XXX-9579
2. Phone call to XXX-XXX-9579
3. SMS passcodes to XXX-XXX-9579

Passcode or option (1-3): 1
Success. Logging you in...
Welcome to Ubuntu 24.04.2 LTS (GNU/Linux 6.14.0-27-generic x86_64)

Stanford Research Computing (https://srcc.stanford.edu/) -----------------------

FarmShare (https://docs.farmshare.stanford.edu/)

For use in coursework and unsponsored research by authorized persons only, and
subject to University policies on acceptable use and standards of behavior.
FarmShare is NOT approved for use with high-risk data, including protected
health information and personally identifiable information.

For support contact srcc-support@stanford.edu,
or join #farmshare-users (https://srcc.slack.com/)

--------------------------------------------------------------------------------

 System information as of Tue Nov 11 08:40:04 PST 2025

  System load:  0.57                Swap usage:  3%       Users logged in: 4
  Usage of /:   16.2% of 108.98GB   Temperature: 72.0 C
  Memory usage: 16%                 Processes:   1372

  => There is 1 zombie process.

cochiu9@rice-04:~$ ssh-keygen -t ed25519 -C "cochiu9@stanford.edu"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/users/cochiu9/.ssh/id_ed25519): ~/.ssh/id_ed25519_farmshare_CollinChiu
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Saving key "~/.ssh/id_ed25519_farmshare_CollinChiu" failed: No such file or directory
cochiu9@rice-04:~$ # Start the agent (if not already running)
eval "$(ssh-agent -s)"
# Add your private key to the agent
ssh-add ~/.ssh/id_ed25519_farmshare_[Your_Github_Username]
Agent pid 3641235
/home/users/cochiu9/.ssh/id_ed25519_farmshare_[Your_Github_Username]: No such file or directory
cochiu9@rice-04:~$ ssh-add ~/.ssh/id_ed25519_farmshare_CollinChiu
/home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu: No such file or directory
cochiu9@rice-04:~$ # 1. Create the SSH directory if it doesn't exist
mkdir -p ~/.ssh

# 2. Restrict its permissions (SSH requires this)
chmod 700 ~/.ssh

# 3. Generate a new ed25519 keypair for Farmshare
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_farmshare_CollinChiu -C "cochiu9@stanford.edu"
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu
Your public key has been saved in /home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu.pub
The key fingerprint is:
SHA256:RzyZl8iExx8oFZfiw2290lZcRiGzkF5WHS+X8ElQd4w cochiu9@stanford.edu
The key's randomart image is:
+--[ED25519 256]--+
|         +++o*+XB|
|        o+=*++E @|
|         =X+=+.*+|
|         .+++ .oo|
|        S .o . o |
|         .  . +  |
|             o   |
|                 |
|                 |
+----[SHA256]-----+
cochiu9@rice-04:~$ ssh-keygen -t ed25519 -C "SUNetID@stanford.edu"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/users/cochiu9/.ssh/id_ed25519): ~/.ssh/id_ed25519_farmshare_CollinChiu
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Saving key "~/.ssh/id_ed25519_farmshare_CollinChiu" failed: No such file or directory
cochiu9@rice-04:~$ ssh-keygen -t ed25519 -C "SUNetID@stanford.edu"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/users/cochiu9/.ssh/id_ed25519): ^C
cochiu9@rice-04:~$ ssh-keygen -t ed25519 -C "cochiu9@stanford.edu"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/users/cochiu9/.ssh/id_ed25519): /home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu
/home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu
Your public key has been saved in /home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu.pub
The key fingerprint is:
SHA256:qbF0qM9f5WSxIhl7gwt7CX46w6ksupW3doKbaEve/xA cochiu9@stanford.edu
The key's randomart image is:
+--[ED25519 256]--+
|                 |
|                 |
|        .   .    |
|       . *   o   |
|     E* S + =    |
|   . +.O = B     |
| .o.oo=.= . .    |
|o+++o+B+ .       |
|==+=====.        |
+----[SHA256]-----+
cochiu9@rice-04:~$ # Start the agent (if not already running)
eval "$(ssh-agent -s)"
# Add your private key to the agent
ssh-add ~/.ssh/id_ed25519_farmshare_CollinChiu]
Agent pid 3648503
/home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu]: No such file or directory
cochiu9@rice-04:~$ ssh-add ~/.ssh/id_ed25519_farmshare_CollinChiu
Identity added: /home/users/cochiu9/.ssh/id_ed25519_farmshare_CollinChiu (cochiu9@stanford.edu)
cochiu9@rice-04:~$ cat ~/.ssh/id_ed25519_farmshare_CollinChiu.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/gBOXNVpUqbU/3Giiz1DqwdUwNUnO89NQy5hHeZ2zM cochiu9@stanford.edu
cochiu9@rice-04:~$ ssh -T git@github.com
The authenticity of host 'github.com (140.82.116.3)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Hi CollinChiu! You've successfully authenticated, but GitHub does not provide shell access.
cochiu9@rice-04:~$ echo $SCRATCH

cochiu9@rice-04:~$ cd $SCRATCH
cochiu9@rice-04:~$ export SCRATCH=/farmshare/user_data/cochiu9
cochiu9@rice-04:~$ cd $SCRATCH
cochiu9@rice-04:/farmshare/user_data/cochiu9$ cd $SCRATCH
mkdir repos
cd repos
git clone git@github.com:[your-user-name]/BIOS270-AU25.git
cd BIOS270-AU25
Cloning into 'BIOS270-AU25'...
fatal: remote error:
  is not a valid repository name
Visit https://support.github.com/ for help
-bash: cd: BIOS270-AU25: No such file or directory
cochiu9@rice-04:/farmshare/user_data/cochiu9/repos$ pwd
/farmshare/user_data/cochiu9/repos
cochiu9@rice-04:/farmshare/user_data/cochiu9/repos$ git clone git@github.com: CollinChiu/BIOS270-AU25.git
Cloning into 'CollinChiu/BIOS270-AU25.git'...
fatal: remote error:
  is not a valid repository name
Visit https://support.github.com/ for help
cochiu9@rice-04:/farmshare/user_data/cochiu9/repos$ pwd
/farmshare/user_data/cochiu9/repos
cochiu9@rice-04:/farmshare/user_data/cochiu9/repos$ git clone git@github.com:CollinChiu/BIOS270-AU25.git
Cloning into 'BIOS270-AU25'...
ERROR: Repository not found.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
cochiu9@rice-04:/farmshare/user_data/cochiu9/repos$ git clone git@github.com:CollinChiu/BIOS270-AU25.git
Cloning into 'BIOS270-AU25'...
remote: Enumerating objects: 125, done.
remote: Counting objects: 100% (20/20), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 125 (delta 7), reused 3 (delta 3), pack-reused 105 (from 2)
Receiving objects: 100% (125/125), 573.78 KiB | 2.21 MiB/s, done.
Resolving deltas: 100% (16/16), done.
cochiu9@rice-04:/farmshare/user_data/cochiu9/repos$ cd BIOS270-AU25
cochiu9@rice-04:/farmshare/user_data/cochiu9/repos/BIOS270-AU25$ Connection to login.farmshare.stanford.edu closed by remote host.
Connection to login.farmshare.stanford.edu closed.
client_loop: send disconnect: Broken pipe
(base) cochiu9@DNa1c23a3 ~ % ssh cochiu9@login.farmshare.stanford.edu
cochiu9@login.farmshare.stanford.edu's password:
(cochiu9@login.farmshare.stanford.edu) Duo two-factor login for cochiu9

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-9579
 2. Phone call to XXX-XXX-9579
 3. SMS passcodes to XXX-XXX-9579

Passcode or option (1-3): 1
Success. Logging you in...
Welcome to Ubuntu 24.04.2 LTS (GNU/Linux 6.14.0-32-generic x86_64)

Stanford Research Computing (https://srcc.stanford.edu/) -----------------------

FarmShare (https://docs.farmshare.stanford.edu/)

For use in coursework and unsponsored research by authorized persons only, and
subject to University policies on acceptable use and standards of behavior.
FarmShare is NOT approved for use with high-risk data, including protected
health information and personally identifiable information.

For support contact srcc-support@stanford.edu,
or join #farmshare-users (https://srcc.slack.com/)

--------------------------------------------------------------------------------

 System information as of Tue Nov 11 14:10:59 PST 2025

  System load:  2.21                Swap usage:  30%      Users logged in: 0
  Usage of /:   16.8% of 108.98GB   Temperature: 84.0 C
  Memory usage: 18%                 Processes:   1844

  => There are 400 zombie processes.

cochiu9@rice-02:~$ # Example custom bash profile

# -----------------------------
# Functions
# -----------------------------
# Example: print numbers from 1 to N (default = 5)
count() {
  local limit=${1:-5}
  for ((i=1; i<=limit; i++)); do
    echo "Count is: $i"
    sleep 1
  done
}

# -----------------------------
# Environment variables
# -----------------------------
export CLASS="/farmshare/home/classes/bios/270"

# -----------------------------
# Basic shortcuts
# -----------------------------
alias reload="source ~/.bashrc"
alias l='ls -ltrh'
0:00 bash''srun --pty -p gpu --gres=gpu:1 --mem=32G --cpus-per-task=4 --time=2:0
cochiu9@rice-02:~$ pwd
/home/users/cochiu9
cochiu9@rice-02:~$ ls
L6.hmm                     go                    metabat_subset
S3.gpkg                    graftm_contigs        protein_predictions.fa
afs-home                   graftm_reads          reactor_subset.tar.gz
binning_visualization.png  infant_subset.tar.gz  visualize_binning.py
biosd_latest.sif           lake_subset
checkm_output              metabat_output
cochiu9@rice-02:~$ "${SHELL}" <(curl -L https://micro.mamba.pm/install.sh)
# Prefix location? [~/micromamba] $SCRATCH/envs/micromamba
source ~/.bashrc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  3059  100  3059    0     0   5756      0 --:--:-- --:--:-- --:--:--  5756
Micromamba binary folder? [~/.local/bin]
Init shell (bash)? [Y/n] y
Configure conda-forge? [Y/n] y
Prefix location? [~/micromamba]
Running `shell init`, which:
 - modifies RC file: "/home/users/cochiu9/.bashrc"
 - generates config for root prefix: "/home/users/cochiu9/micromamba"
 - sets mamba executable to: "/home/users/cochiu9/.local/bin/micromamba"
The following has been added in your "/home/users/cochiu9/.bashrc" file

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/users/cochiu9/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/users/cochiu9/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

Please restart your shell to activate micromamba or run the following:\n
  source ~/.bashrc (or ~/.zshrc, ~/.xonshrc, ~/.config/fish/config.fish, ...)
cochiu9@rice-02:~$ micromamba --version
2.3.3
cochiu9@rice-02:~$ micromamba --version
2.3.3
cochiu9@rice-02:~$ "${SHELL}" <(curl -L https://micro.mamba.pm/install.sh)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  3059  100  3059    0     0   5951      0 --:--:-- --:--:-- --:--:--  5951
Micromamba binary folder? [~/.local/bin] $SCRATCH/envs/micromamba
Init shell (bash)? [Y/n]
Configure conda-forge? [Y/n] y
Prefix location? [~/micromamba] $SCRATCH/envs/micromamba
Running `shell init`, which:
 - modifies RC file: "/home/users/cochiu9/.bashrc"
 - generates config for root prefix: "/home/users/cochiu9/$SCRATCH/envs/micromamba"
 - sets mamba executable to: "/home/users/cochiu9/$SCRATCH/envs/micromamba/micromamba"
The following has been added in your "/home/users/cochiu9/.bashrc" file

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/users/cochiu9/$SCRATCH/envs/micromamba/micromamba';
export MAMBA_ROOT_PREFIX='/home/users/cochiu9/$SCRATCH/envs/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

Please restart your shell to activate micromamba or run the following:\n
  source ~/.bashrc (or ~/.zshrc, ~/.xonshrc, ~/.config/fish/config.fish, ...)
cochiu9@rice-02:~$ source ~/.bashrc (or ~/.zshrc, ~/.xonshrc, ~/.config/fish/config.fish, ...)
-bash: syntax error near unexpected token `('
cochiu9@rice-02:~$ \n
  source ~/.bashrc (or ~/.zshrc, ~/.xonshrc, ~/.config/fish/config.fish, ...)
n: command not found
-bash: syntax error near unexpected token `('
cochiu9@rice-02:~$  source ~/.bashrc
cochiu9@rice-02:~$ micromamba --version
-bash: /home/users/cochiu9//envs/micromamba/micromamba: No such file or directory
cochiu9@rice-02:~$ micromamba --version
-bash: /home/users/cochiu9//envs/micromamba/micromamba: No such file or directory
cochiu9@rice-02:~$ micromamba --version
-bash: /home/users/cochiu9//envs/micromamba/micromamba: No such file or directory
cochiu9@rice-02:~$ micromamba --version
-bash: /home/users/cochiu9//envs/micromamba/micromamba: No such file or directory
cochiu9@rice-02:~$ pwd
/home/users/cochiu9
cochiu9@rice-02:~$ curl -s https://get.nextflow.io | bash

      N E X T F L O W
      version 25.10.0 build 10289
      created 22-10-2025 16:26 UTC
      cite doi:10.1038/nbt.3820
      http://nextflow.io


Nextflow installation completed. Please note:
- the executable file `nextflow` has been created in the folder: /home/users/cochiu9
- you may complete the installation by moving it to a directory in your $PATH

cochiu9@rice-02:~$ nextflow info
nextflow: command not found
cochiu9@rice-02:~$ pwd
/home/users/cochiu9
cochiu9@rice-02:~$ curl -s https://get.nextflow.io | bash

      N E X T F L O W
      version 25.10.0 build 10289
      created 22-10-2025 16:26 UTC
      cite doi:10.1038/nbt.3820
      http://nextflow.io


Nextflow installation completed. Please note:
- the executable file `nextflow` has been created in the folder: /home/users/cochiu9
- you may complete the installation by moving it to a directory in your $PATH

cochiu9@rice-02:~$ nextflow info
nextflow: command not found
cochiu9@rice-02:~$ ls
'$SCRATCH'                   go                     micromamba
 L6.hmm                      graftm_contigs         nextflow
 S3.gpkg                     graftm_reads           protein_predictions.fa
 afs-home                    infant_subset.tar.gz   reactor_subset.tar.gz
 binning_visualization.png   lake_subset            visualize_binning.py
 biosd_latest.sif            metabat_output
 checkm_output               metabat_subset
cochiu9@rice-02:~$ cd next
-bash: cd: next: No such file or directory
cochiu9@rice-02:~$ cd nextflow
-bash: cd: nextflow: Not a directory
cochiu9@rice-02:~$ echo $PATH
/home/users/cochiu9/micromamba/condabin:/home/users/cochiu9/bin:/home/users/cochiu9/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
cochiu9@rice-02:~$ mkdir -p ~/bin
mv ~/nextflow ~/bin/
cochiu9@rice-02:~$ nextflow info
  Version: 25.10.0 build 10289
  Created: 22-10-2025 16:26 UTC
  System: Linux 6.14.0-32-generic
  Runtime: Groovy 4.0.28 on OpenJDK 64-Bit Server VM 21.0.8+9-Ubuntu-0ubuntu124.04.1
  Encoding: UTF-8 (UTF-8)

cochiu9@rice-02:~$ pwd
/home/users/cochiu9
cochiu9@rice-02:~$ ls
'$SCRATCH'                   checkm_output          metabat_subset
 L6.hmm                      go                     micromamba
 S3.gpkg                     graftm_contigs         protein_predictions.fa
 afs-home                    graftm_reads           reactor_subset.tar.gz
 bin                         infant_subset.tar.gz   visualize_binning.py
 binning_visualization.png   lake_subset
 biosd_latest.sif            metabat_output
cochiu9@rice-02:~$ pwd
/home/users/cochiu9
cochiu9@rice-02:~$ pwd
/home/users/cochiu9
cochiu9@rice-02:~$ cd $scratch
cochiu9@rice-02:~$ ls
'$SCRATCH'                   checkm_output          metabat_subset
 L6.hmm                      go                     micromamba
 S3.gpkg                     graftm_contigs         protein_predictions.fa
 afs-home                    graftm_reads           reactor_subset.tar.gz
 bin                         infant_subset.tar.gz   visualize_binning.py
 binning_visualization.png   lake_subset
 biosd_latest.sif            metabat_output
cochiu9@rice-02:~$ # Example custom bash profile

# -----------------------------
# Functions
# -----------------------------
# Example: print numbers from 1 to N (default = 5)
count() {
  local limit=${1:-5}
  for ((i=1; i<=limit; i++)); do
    echo "Count is: $i"
    sleep 1
  done
}

# -----------------------------
# Environment variables
# -----------------------------
export CLASS="/farmshare/home/classes/bios/270"

# -----------------------------
# Basic shortcuts
# -----------------------------
alias reload="source ~/.bashrc"
alias l='ls -ltrh'
0:00 bash''srun --pty -p gpu --gres=gpu:1 --mem=32G --cpus-per-task=4 --time=2:0
cochiu9@rice-02:~$ "${SHELL}" <(curl -L https://micro.mamba.pm/install.sh)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  3059  100  3059    0     0   3145      0 --:--:-- --:--:-- --:--:--  3145
Micromamba binary folder? [~/.local/bin] $SCRATCH/envs/micromamba
Init shell (bash)? [Y/n]
Configure conda-forge? [Y/n]
Prefix location? [~/micromamba] $SCRATCH/envs/micromamba
Running `shell init`, which:
 - modifies RC file: "/home/users/cochiu9/.bashrc"
 - generates config for root prefix: "/home/users/cochiu9/$SCRATCH/envs/micromamba"
 - sets mamba executable to: "/home/users/cochiu9/$SCRATCH/envs/micromamba/micromamba"
The following has been added in your "/home/users/cochiu9/.bashrc" file

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/users/cochiu9/$SCRATCH/envs/micromamba/micromamba';
export MAMBA_ROOT_PREFIX='/home/users/cochiu9/$SCRATCH/envs/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

Please restart your shell to activate micromamba or run the following:\n
  source ~/.bashrc (or ~/.zshrc, ~/.xonshrc, ~/.config/fish/config.fish, ...)
cochiu9@rice-02:~$ source ~/.bashrc
cochiu9@rice-02:~$ micromamba --version
-bash: /home/users/cochiu9//envs/micromamba/micromamba: No such file or directory
cochiu9@rice-02:~$ "${SHELL}" <(curl -L https://micro.mamba.pm/install.sh)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  3059  100  3059    0     0   6042      0 --:--:-- --:--:-- --:--:--  6042
Micromamba binary folder? [~/.local/bin]
Init shell (bash)? [Y/n]
Configure conda-forge? [Y/n]
Prefix location? [~/micromamba]
Running `shell init`, which:
 - modifies RC file: "/home/users/cochiu9/.bashrc"
 - generates config for root prefix: "/home/users/cochiu9/micromamba"
 - sets mamba executable to: "/home/users/cochiu9/.local/bin/micromamba"
The following has been added in your "/home/users/cochiu9/.bashrc" file

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/users/cochiu9/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/users/cochiu9/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

Please restart your shell to activate micromamba or run the following:\n
  source ~/.bashrc (or ~/.zshrc, ~/.xonshrc, ~/.config/fish/config.fish, ...)
cochiu9@rice-02:~$  source ~/.bashrc
cochiu9@rice-02:~$ micromamba --version
2.3.3
