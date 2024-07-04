# download wigToBigWig
wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v369/wigToBigWig

# download fetchChromSizes
wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v369/fetchChromSizes

# make both file executable using
chmod +x 

# fetchChromSizes mm10.chromSizes. Note the "." is to specify directory
./fetchChromSizes mm10 > mm10.chromSizes

# download bedGraphToBigWig
wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v369/bedGraphToBigWig

# unzip bedgraph file
gunzip SRR3824222/SRR3824222_1_val_1_bismark_bt2_pe.deduplicated.bedGraph.gz

# convert bedgraph file to bigWig
./bedGraphToBigWig SRR3824222/SRR3824222_1_val_1_bismark_bt2_pe.deduplicated.bedGraph mm10.chromSizes Epiblast_rep1_WGBS_1.methylation.bigWig

# get coverage
bedtools genomecov -ibam SRR3824222/SRR3824222_1_val_1_bismark_bt2_pe.deduplicated.bam -bg > Epiblast_rep1_genome_coverage.bedgraph

# convert to .bigWig 
./bedGraphToBigWig Epiblast_rep1_genome_coverage.bedgraph mm10.chromSizes Epiblast_rep1_genome_coverage.bigWig


