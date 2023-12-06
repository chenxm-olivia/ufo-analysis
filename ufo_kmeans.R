library(tidyverse)
library(matlab)
library(aricode)

set.seed(231030)

# Perform k-means clustering on the 2D projections
tsne_result <- read_csv("derived_data/tsne-projection.csv") %>% as.matrix()

kmeans_tsne_result <- kmeans(tsne_result, centers = 5)

tsne_kmeans_cluster <- cbind(tsne_result, as.data.frame(kmeans_tsne_result$cluster)) %>% 
  mutate(cluster = as.factor(kmeans_tsne_result$cluster)) %>% select(TSNE1, TSNE2, cluster)

ggplot(tsne_kmeans_cluster, aes(TSNE1, TSNE2)) +
  geom_point(aes(color = cluster), alpha = 0.5) +
  xlab("V1") +
  ylab("V2") +
  labs(color = "Cluster") +
  ggtitle("Figure 4.1. K-means clustering on t-SNE Projection")
ggsave("figures/kmeans_cluster_tsne.png")

# Perform k-means clustering on the first 50 dimensions of the PCA
pca_result_50pcs <- read_csv("derived_data/pca_result_x_50pcs.csv") %>% as.matrix()
kmeans_pca_result <- kmeans(pca_result_50pcs, centers = 5)

pca_kmeans_cluster <- cbind(pca_result_50pcs, as.data.frame(kmeans_pca_result$cluster)) %>% 
  mutate(cluster = as.factor(kmeans_pca_result$cluster)) %>% select(PC1, PC2, cluster)

ggplot(pca_kmeans_cluster, aes(PC1, PC2)) +
  geom_point(aes(color = cluster), alpha = 0.5) +
  labs(color = "Cluster") +
  ggtitle("Figure 4.2. K-means clustering on PCA dimensions")
ggsave("figures/kmeans_cluster_pca.png")

nmi <- NMI(tsne_kmeans_cluster$cluster, pca_kmeans_cluster$cluster)
print(nmi)
