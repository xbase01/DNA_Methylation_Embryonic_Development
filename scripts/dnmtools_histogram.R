# Load required library
library(ggplot2)

# Read methylation data from the .symmetric_CpGs.meth file
file_path <- "SRR5836475/ICM_rep1_WGBS_symmetric_CpG_filtered.meth"
methylation_data <- read.table(file_path, header = FALSE, sep = '\t',
                               col.names = c('chromosome', 'position', 'strand',
                                             'sequence_context', 'methylation_level', 'read_count'))

# Filter out mutated CpG sites (CpGx)
methylation_data <- methylation_data[methylation_data$sequence_context != "CpGx", ]

# Calculate total number of CpGs
total_cpgs <- nrow(methylation_data)

# Calculate average CpG methylation in percentage
avg_methylation <- mean(methylation_data$methylation_level, na.rm = TRUE) * 100

# Create histogram plot
p <- ggplot(methylation_data, aes(x = methylation_level)) +
  geom_histogram(binwidth = 0.05, fill = 'skyblue', color = 'black') +
  labs(title = paste('CpG Methylation Histogram -', "ICM_rep1_WGBS_symmetric_CpG.meth"),
       x = 'Methylation Level', y = 'Frequency',
       caption = paste('n =', total_cpgs, '(chr18)\n',
                       'Average CpG Methylation =', round(avg_methylation, 2), '%')) +
  theme_minimal()

# Save plot as PNG using ggsave
ggsave("ICM_rep1_WGBS_methylation_histogram.png", plot = p, width = 8, height = 6, dpi = 300)

