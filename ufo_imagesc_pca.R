library(tidyverse)
library(matlab)

# Load data
ufo_embed <- read_csv(gzfile("source_data/embeddings_output_clean.csv.gz"), col_names = F)
ufo_embed %>% write_csv("derived_data/embeddings_output_clean.csv", col_names = FALSE)

png("figures/ufo_imagesc_summary_embeddings.png")
imagesc(ufo_embed %>% as.matrix())
dev.off()

# PCA
pca_result <- prcomp(ufo_embed %>% as.matrix())
as.data.frame(pca_result$x) %>% write_csv("derived_data/pca_result_x.csv")
as.data.frame(pca_result$x[,1:50]) %>% write_csv("derived_data/pca_result_x_50pcs.csv")

png("figures/ufo_imagesc_pca.png")
imagesc(pca_result$x)
dev.off()

# Create ggplot
variance <- (pca_result$sdev)^2
cumulative_variance <- cumsum(variance) / sum(variance)

df <- data.frame(Dimension = 1:length(cumulative_variance), CumulativeVariance = cumulative_variance)

ggplot(df, aes(x = Dimension, y = CumulativeVariance)) +
  geom_line() +
  geom_point() +
  geom_hline(yintercept = 0.85) +
  xlab("Principal Component") +
  ylab("Cumulative Proportion of Variance Explained") +
  ggtitle("Figure 1. PCA Cumulative Variance Plot")
ggsave("figures/explained_variance.png")
