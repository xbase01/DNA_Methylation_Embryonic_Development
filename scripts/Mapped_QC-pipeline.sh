#!/bin/bash

# Define the basename
BASENAME="Epiblast_rep2"

# Step 1: Convert BAM file to DNMTools format
dnmtools format -f bismark -t 4 -B SRR5836479_1_val_1_1_bismark_bt2_pe.deduplicated.bam "${BASENAME}_WGBS_format.bam"

# Step 2: Sort the formatted BAM file
samtools sort -o "${BASENAME}_WGBS_sorted.bam" "${BASENAME}_WGBS_format.bam"

# Step 3: Calculate bisulfite conversion rates
dnmtools bsrate -c ~/bisulfite_WGBS/data/chr18.fa -o "${BASENAME}_WGBS_bsrate"

# Step 4: Generate methylation counts
dnmtools counts -c ~/bisulfite_WGBS/data/chr18.fa -o "${BASENAME}_WGBS_counts.meth" "${BASENAME}_WGBS_sorted.bam"

# Step 5: Perform methylation level analysis
dnmtools level -o "${BASENAME}_WGBS.levels" "${BASENAME}_WGBS_counts"

# Step 6: Generate methylation counts for CpG sites only
dnmtools counts -cpg-only -c ~/bisulfite_WGBS/data/chr18.fa -o "${BASENAME}_WGBS_CpG.meth" "${BASENAME}_WGBS_sorted.bam"

# Step 7: Generate symmetric CpG methylation
dnmtools sym -o "${BASENAME}_WGBS_symmetric_CpG.meth" "${BASENAME}_WGBS-CpG.meth"

# Step 8: Filter out CpGx sites
awk '$4 != "CpGx"' "${BASENAME}_WGBS_symmetric_CPG.meth" > "${BASENAME}_WGBS_symmetric_CPG_filtered.meth"

echo "Pipeline completed!"

