
BIOS 611 Homework: Clustering and Dimensionality Reduction
============================================================

### Data Source
The source data of this homework include: 

1) the compressed CSV file containing vectors that represent the 'Summary' field of the UFO dataset `embeddings_output_clean.csv.gz` 
2) the original UFO dataset `ufo_data.csv`.

Both files are saved in a `source_data/` folder in the working directory.

### Using This Repository
It is recommended to use this repository via Docker. One Docker container is provided for this project. To build the Docker container, you need to run:

```
docker build . -t ufo_project
```

This will create a docker container. Then, you should be able to start an Rstudio server by running:

```
docker run -v $(pwd):/home/rstudio/work -p 8787:8787 -it ufo_project
```

You can access the machine and development environment via http://localhost:8787 in a browser.


### Project Organization

The project is organized using the Makefile. It allows for the automatic reproduction of artifacts by running the command.

A Makefile is a textual description of the relationships between artifacts (like data, figures, source files, etc). In particular, it documents for each artifact of interest in the project:

1) what is needed to construct that artifact
2) how to construct it

You can construct a specific artifact by invoking Make like:

```
make figures/kmeans_cluster_pca.png
```

The summary of this analysis will be built by running:

```
make summary.html
```

The detailed results with embedded codes will be built by running:

```
make analysis_report.html
```

You can run the following line to clean up all intermediate artifacts if needed. It will also create sub-directories in your working directory.

```
make clean
```
