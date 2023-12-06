library(tidyverse)
library(plotly)
library(htmlwidgets)

# Define function
ggplotly_html <- function(ggplot_object, filename) {
  plotly_object <- ggplotly(ggplot_object)
  saveWidget(plotly_object, file = filename)
}

# Load data for PCA
ufo_data <- read_csv("source_data/ufo_data.csv")
pca_result_x <- read_csv("derived_data/pca_result_x.csv")
ufo_pca_x <- cbind(ufo_data, pca_result_x)
ufo_pca_x$summary <- iconv(ufo_pca_x$Summary, to = "UTF-8")

# PC1 & PC2
(ggplot(ufo_pca_x, aes(PC1, PC2)) +
    geom_point(aes(color = factor(ntile(str_length(summary),5))), alpha = 0.5) +
    aes(text = summary) +
    xlab("PC1") +
    ylab("PC2") +
    labs(color = "Quintile of field length") +
    ggtitle("Scatter Plot of PC1 vs. PC2 by Field Length")) %>%
  ggplotly_html("figures/pc1_pc2_length_cat.html")

# Load data for t-SNE
tsne_result <- read_csv("derived_data/tsne-projection.csv") %>% as_tibble() 
ufo_tsne <- cbind(ufo_data, tsne_result)
ufo_tsne$summary <- iconv(ufo_tsne$Summary, to = "UTF-8")

# t-SNE 2D projection
(ggplot(ufo_tsne, aes(TSNE1, TSNE2)) +
    geom_point(aes(color = factor(ntile(str_length(summary),5))), alpha = 0.5) +
    aes(text = summary) +
    xlab("V1") +
    ylab("V2") +
    labs(color = "Quintile of field length") +
    ggtitle("Scatter Plot of 2D t-SNE Projection by Field Length")) %>%
  ggplotly_html("figures/tsne_length_cat.html")