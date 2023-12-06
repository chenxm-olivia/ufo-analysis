.PHONY: clean

clean:
	rm -rf figures/*
	rm -rf derived_data/*
	rm -rf summary.html
	rm -rf analysis_report.html
	mkdir -p figures
	mkdir -p derived_data

# PCA
derived_data/embeddings_output_clean.csv derived_data/pca_result_x.csv derived_data/pca_result_x_50pcs.csv figures/ufo_imagesc_summary_embeddings.png figures/ufo_imagesc_pca.png figures/explained_variance.png: \
 source_data/embeddings_output_clean.csv.gz ufo_imagesc_pca.R
	Rscript ufo_imagesc_pca.R

figures/scatter_pc1_pc2.png figures/scatter_pc1_pc2_note.png figures/scatter_pc1_pc2_objects.png figures/scatter_pc1_pc2_content.png figures/scatter_pc1_pc2_length.png: \
 derived_data/pca_result_x.csv source_data/ufo_data.csv ufo_pcs_plot.R
	Rscript ufo_pcs_plot.R

# t-SNE projection
derived_data/tsne-projection.csv: derived_data/embeddings_output_clean.csv tsne_projection.py
	python3 tsne_projection.py

figures/scatter_tsne.png figures/scatter_tsne_length.png figures/scatter_tsne_content.png figures/scatter_tsne_objects.png figures/scatter_tsne_pronouns.png: \
 derived_data/tsne-projection.csv source_data/ufo_data.csv ufo_tsne.R
	Rscript ufo_tsne.R

# Plotly visualization
figures/pc1_pc2_length_cat.html figures/tsne_length_cat.html: source_data/ufo_data.csv derived_data/pca_result_x.csv derived_data/tsne-projection.csv plotly_pcs_tsne.R
	Rscript plotly_pcs_tsne.R

# K-means clustering
figures/kmeans_cluster_tsne.png figures/kmeans_cluster_pca.png: \
 derived_data/tsne-projection.csv derived_data/pca_result_x_50pcs.csv ufo_kmeans.R
	Rscript ufo_kmeans.R
	
# Generate summary of the analysis
summary.html: \
 figures/explained_variance.png figures/scatter_pc1_pc2.png figures/scatter_pc1_pc2_length.png\
 figures/pc1_pc2_length_cat.html\
 figures/scatter_pc1_pc2_note.png figures/scatter_pc1_pc2_objects.png figures/scatter_pc1_pc2_content.png\
 figures/scatter_tsne.png figures/scatter_tsne_length.png\
 figures/tsne_length_cat.html\
 figures/scatter_tsne_content.png figures/scatter_tsne_objects.png figures/scatter_tsne_pronouns.png\
 figures/kmeans_cluster_tsne.png figures/kmeans_cluster_pca.png\
 summary.Rmd
	R -e "rmarkdown::render(\"summary.Rmd\", output_format=\"html_document\")"

# Generate detailed results with embedded codes
analysis_report.html: source_data/embeddings_output_clean.csv.gz source_data/ufo_data.csv derived_data/tsne-projection.csv analysis_report.Rmd
	R -e "rmarkdown::render(\"analysis_report.Rmd\", output_format=\"html_document\")"