FROM rocker/rstudio
RUN R -e "install.packages(c('tidyverse','matlab','aricode','plotly','htmlwidgets','markdown'))"
RUN apt update && apt install -y python3 python3-pip
RUN pip3 install numpy scikit-learn pandas
