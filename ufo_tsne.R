library(tidyverse)

# Load data
tsne_result <- read_csv("derived_data/tsne-projection.csv") %>% as_tibble() 
ufo_data <- read_csv("source_data/ufo_data.csv")

ufo_tsne <- cbind(ufo_data, tsne_result)
ufo_tsne$summary <- iconv(ufo_tsne$Summary, to = "UTF-8")

# Plot the t-SNE projection
ggplot(tsne_result, aes(TSNE1, TSNE2)) +
  geom_point(alpha = 0.5) +
  xlab("V1") +
  ylab("V2") +
  ggtitle("Figure 3.1. Scatter Plot of 2D t-SNE Projection")
ggsave("figures/scatter_tsne.png")

# Cluster analysis - length
ggplot(ufo_tsne, aes(TSNE1, TSNE2)) +
  geom_point(aes(color = factor(ntile(str_length(summary),5))), alpha = 0.5) +
  xlab("V1") +
  ylab("V2") +
  labs(color = "Quintile of field length") +
  ggtitle("Figure 3.2. Scatter Plot of 2D t-SNE Projection by Field Length")
ggsave("figures/scatter_tsne_length.png")

# Cluster 1
### Cluster analysis - content
object <- paste(c("star", "planet", "Venus", "meteor", "celestial", "Sirius", "Jupiter",
                  "plane", "contrail", "craft", "Satellite", "Station", "object", "Space debris",
                  "balloon", "lantern", "advertising lights"), collapse = "|")

ufo_tsne$content <- ifelse(grepl(object, ufo_tsne$summary, ignore.case = TRUE), "Any object", 
                           ifelse(grepl("light", ufo_tsne$summary, ignore.case = TRUE), "Just lights", "Other"))

ggplot(ufo_tsne, aes(TSNE1, TSNE2)) +
  geom_point(aes(color = content), alpha = 0.5) +
  xlab("V1") +
  ylab("V2") +
  labs(color = "Content") +
  ggtitle("Figure 3.3. Scatter Plot of 2D t-SNE Projection by Content")
ggsave("figures/scatter_tsne_content.png")

### Cluster analysis - objects
object_astron <- paste(c("a star", "a \"twinkling\" star", "twinkling star", "planet", "Venus", "meteor", "celestial", "Sirius", "Jupiter"), collapse = "|")
object_aircraft <- paste(c("plane", "contrail", "craft", "Satellite", "Space Station"), collapse = "|")
object_other <- paste(c("balloon", "lantern", "advertising lights"), collapse = "|")

ufo_tsne$objects <- ifelse(grepl(object_astron, ufo_tsne$summary, ignore.case = TRUE), "Space object", 
                           ifelse(grepl(object_aircraft, ufo_tsne$summary, ignore.case = TRUE), "Aircraft", 
                                  ifelse(grepl(object_other, ufo_tsne$summary, ignore.case = TRUE), "Other", "Unknown")))

ggplot(ufo_tsne, aes(TSNE1, TSNE2)) +
  geom_point(aes(color = objects), alpha = 0.5) +
  xlab("V1") +
  ylab("V2") +
  labs(color = "Objects") +
  ggtitle("Figure 3.4. Scatter Plot of 2D t-SNE Projection by Objects")
ggsave("figures/scatter_tsne_objects.png")

# Cluster 2
### Cluster analysis - context
pronouns <- paste(c(" I ", " I'", " my ", " me ", " we ", " us ", " our "), collapse = "|")

ufo_tsne$pronouns <- ifelse(grepl(pronouns, ufo_tsne$summary, ignore.case = TRUE), "Mentions", "No mentions")

ggplot(ufo_tsne, aes(TSNE1, TSNE2)) +
  geom_point(aes(color = pronouns), alpha = 0.5) +
  xlab("V1") +
  ylab("V2") +
  labs(color = "First-person pronouns") +
  ggtitle("Figure 3.5 Scatter Plot of 2D t-SNE Projection by First-Person Pronouns")
ggsave("figures/scatter_tsne_pronouns.png")


