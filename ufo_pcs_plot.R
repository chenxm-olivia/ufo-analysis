library(tidyverse)
library(plotly)
library(htmlwidgets)

# Load PCA result and the original UFO data
pca_result_x <- read_csv("derived_data/pca_result_x.csv")
ufo_data <- read_csv("source_data/ufo_data.csv")

# Merge the PCA result with the UFO data
ufo_pca_x <- cbind(ufo_data, pca_result_x)
ufo_pca_x$summary <- iconv(ufo_pca_x$Summary, to = "UTF-8")

# Scatter plot for PC1 vs. PC2
ggplot(pca_result_x, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.5) +
  xlab("PC1") +
  ylab("PC2") +
  ggtitle("Figure 2.1. Scatter Plot of PC1 vs. PC2")
ggsave("figures/scatter_pc1_pc2.png")

# Scatter plot for PC1 vs. PC2 by the Summary field length
ggplot(ufo_pca_x, aes(PC1, PC2)) +
  geom_point(aes(color = factor(ntile(str_length(summary),5))), alpha = 0.5) +
  xlab("PC1") +
  ylab("PC2") +
  labs(color = "Quintile of field length") +
  ggtitle("Figure 2.2. Scatter Plot of PC1 vs. PC2 by Field Length")
ggsave("figures/scatter_pc1_pc2_length.png")


# Cluster 1 analysis
### Cluster analysis - NUFORC notes
note <- paste(c("NUFORC", "PD", "note", "anon", "report"), collapse = "|")

ufo_pca_x$incl_note <- ifelse(grepl(note, ufo_pca_x$summary, ignore.case = TRUE), "Presence", "Absence")

ggplot(ufo_pca_x, aes(PC1, PC2)) +
  geom_point(aes(color = incl_note), alpha = 0.5) +
  xlab("PC1") +
  ylab("PC2") +
  labs(color = "NUFROC Note") +
  ggtitle("Figure 2.3. Scatter Plot of PC1 vs. PC2 by NUFROC Note")
ggsave("figures/scatter_pc1_pc2_note.png")

### Cluster analysis - objects
object_astron <- paste(c("a star", "a \"twinkling\" star", "twinkling star", "planet", "Venus", "meteor", "celestial", "Sirius", "Jupiter"), collapse = "|")
object_aircraft <- paste(c("plane", "contrail", "craft", "Satellite", "Space Station"), collapse = "|")
object_other <- paste(c("balloon", "lantern", "advertising lights"), collapse = "|")

ufo_pca_x$objects <- ifelse(grepl(object_astron, ufo_pca_x$summary, ignore.case = TRUE), "Space object", 
                            ifelse(grepl(object_aircraft, ufo_pca_x$summary, ignore.case = TRUE), "Aircraft", 
                                   ifelse(grepl(object_other, ufo_pca_x$summary, ignore.case = TRUE), "Other", "Unknown")))

ggplot(ufo_pca_x, aes(PC1, PC2)) +
  geom_point(aes(color = objects), alpha = 0.5) +
  xlab("PC1") +
  ylab("PC2") +
  labs(color = "Objects") +
  ggtitle("Figure 2.4. Scatter Plot of PC1 vs. PC2 by Objects")
ggsave("figures/scatter_pc1_pc2_objects.png")


# Cluster 2 analysis
### Cluster analysis - content
object <- paste(c("star", "planet", "Venus", "meteor", "celestial", "Sirius", "Jupiter",
                  "plane", "contrail", "craft", "Satellite", "Station", "object", "Space debris",
                  "balloon", "lantern", "advertising lights", "pilot"), collapse = "|")

ufo_pca_x$content <- ifelse(grepl(object, ufo_pca_x$summary, ignore.case = TRUE), "Any object", 
                            ifelse(grepl("light", ufo_pca_x$summary, ignore.case = TRUE), "Just lights", "Other"))

ggplot(ufo_pca_x, aes(PC1, PC2)) +
  geom_point(aes(color = content), alpha = 0.5) +
  xlab("PC1") +
  ylab("PC2") +
  labs(color = "Content") +
  ggtitle("Figure 2.5. Scatter Plot of PC1 vs. PC2 by Content")
ggsave("figures/scatter_pc1_pc2_content.png")
