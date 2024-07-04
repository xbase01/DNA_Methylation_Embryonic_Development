#!/bin/bash

# Set basename for the sample
basename="ICM"

# Merge methylation files
dnmtools merge -o "${basename}_WGBS.meth" SRR5836475/ICM_rep1_WGBS_symmetric_CpG_filtered.meth SRR5836476/ICM_rep2_WGBS_symmetric_CpG_filtered.meth

# Perform methylation difference probabilities
dnmtools diff -o "${basename}_vs_Epiblast.diff" "${basename}_WGBS.meth" Epiblast_WGBS.meth

# Generate hypomethylated methylation region (HMR) file
dnmtools hmr -p params.txt -o Epiblast_merge_WGBS.hmr Epiblast_merge_WGBS.meth

# Perform differentially methylated regions analysis
dnmtools dmr "${basename}_vs_Epiblast.diff" "${basename}_merge_WGBS.hmr" Epiblast_merge_WGBS.hmr dmr-${basename}-lt-Epiblast.bed dmr-Epiblast_lt_${basename}.bed

# Find intersection between DMR output
bedtools intersect -a dmr-${basename}-lt-Epiblast.bed -b dmr-Epiblast_lt_${basename}.bed > common.bed

# Filter DMR BED file based on criteria
awk -F '[:\t]' '$5 >= 5 && $6/$5 >= 0.8' dmr-${basename}-lt-Epiblast.bed > dmr-${basename}-lt-Epiblast-filtered.bed

# Download gene gencode .gff, sort and convert to .bed using bedtools
sort -k1, 1-k4, 4n gencode.vM10.annotation.bed > gencode.vM10.annotation.sorted.bed

# Find closest genes to DMRs
closestBed -a dmr-${basename}-lt-Epiblast.bed -b gencode.vM10.annotation.sorted.bed > dmr-ICM-lt-Epiblast_closest_genes.txt

# closestBed alternative
# closest-features --closest -no-ref dmr-ICM-lt-Epiblast.bed gencode.vM10.annotation.sorted.bed | cut -F4 -> annotation.txt

# Subset relevant columns from closest genes file
awk '{print $2, $3, $5, $8, $9, $10}' dmr-ICM-lt-Epiblast_closest_genes.txt > dmr-ICM-lt-Epiblast_gene_ids.txt

exit
