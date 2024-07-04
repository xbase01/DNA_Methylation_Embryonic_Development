#!/bin/bash

# Define the filepath
filepath="SRR3824222/"

# Install dnmtools using conda environment
# Assuming conda is properly configured
# conda install -c bioconda dnmtools

# Prepare input .bam file for dnmtools
dnmtools format -f bismark -t 8 -B ${filepath}SRR3824222_1_val_1_bismark_bt2_pe.deduplicated.bam ${filepath}Epiblast_rep1_WGBS_format.bam

# Sort using samtools
samtools sort -o ${filepath}Epiblast_rep1_WGBS_sorted.bam ${filepath}Epiblast_rep1_WGBS_format.bam

# CpG, CHH, CHG
# Calculate methylation counts
# dnmtools counts -c ~/bisulfite_WGBS/data/chr18.fa -o Epiblast_rep2_WGBS.meth Epiblast_rep2_WGBS_sorted.bam
dnmtools counts -cpg-only -c ~/bisulfite_WGBS/data/chr18.fa -o ${filepath}Epiblast_rep1_WGBS_CpG.meth ${filepath}Epiblast_rep1_WGBS_sorted.bam
# Symmetrize CpG methylation data
dnmtools sym -o ${filepath}Epiblast_rep1_WGBS_symmetric_CpG.meth ${filepath}Epiblast_rep1_WGBS_CpG.meth

# Remove CpGx mutation sites since dnmtools failed to do so
awk '$4 != "CpGx"' ${filepath}Epiblast_rep1_WGBS_symmetric_CpG.meth > ${filepath}Epiblast_rep1_WGBS_symmetric_CpG_filtered.meth

exit

