#!/bin/bash

# Set timer
SECONDS=0

# Define paths
sample_id="SRR5836475"  # Sample ID hardcoded for this run
external_dir="/data/aneke/WGBS"
internal_dir="./data"
qc_reports_dir="./QC_Reports"

# Prefetch
prefetch --output-directory $external_dir $sample_id

# Fasterq-dump
fasterq-dump --outdir $external_dir --threads 4 $external_dir/$sample_id

# Gzip only the _1.fastq and _2.fastq files in the external directory
gzip $external_dir/*_1.fastq
gzip $external_dir/*_2.fastq

# FastQC
fastqc --threads 4 --outdir $qc_reports_dir $external_dir/*.fastq.gz

# Trim Galore (assuming paired-end reads)
trim_galore --paired --fastqc --cores 4 --output_dir $internal_dir $external_dir/$sample_id"_1.fastq.gz" $external_dir/$sample_id"_2.fastq.gz"

# Preparation Genome (Indexing) ( gzip -d chr18.fa.gz in .)
bismark_genome_preparation mouse .

# Bismark (assuming Bisulfite genome reference is already indexed)
bismark -p 4 --gzip ./data $internal_dir/$sample_id"_1_val_1.fq.gz" $internal_dir/$sample_id"_2_val_2.fq.gz" --output_dir $internal_dir

# Remove reads that are not uniquely mapped
deduplicate_bismark $internal_dir/$sample_id"_1_val_1_bismark_bt2_pe.bam"

# Methylation extraction (calling) 
bismark_methylation_extractor --bedGraph --gzip -p --comprehensive $internal_dir/$sample_id"_1_val_1_bismark_bt2_pe.bam"

# Bismark report and Summary
bismark2report
bismark2summary

# Calculate and display the elapsed time
duration=$SECONDS
time_summary="Analysis completed in $(($duration / 60)) minutes and $(($duration % 60)) seconds."

# Echo the time summary to a file
echo "$time_summary" > time_summary.txt

exit
