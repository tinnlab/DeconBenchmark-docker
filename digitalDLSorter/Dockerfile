ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-bioc-singlecellexperiment \
    r-bioc-summarizedexperiment \
    r-bioc-s4vectors \
    r-cran-reticulate \
    r-cran-remotes \
    r-cran-ggpubr \
    r-bioc-genefilter \
    r-cran-igraph \
    r-bioc-scran \
    r-cran-matrixstats \
    r-cran-matrix \
    r-bioc-biocneighbors \
    r-bioc-bluster \
    r-bioc-scuttle \
    python3-venv && \
    apt-get clean

RUN R -e 'BiocManager::install("zinbwave", update=F)'
RUN R -e 'library(zinbwave)'
RUN R -e 'remotes::install_version("digitalDLSorteR", version = "0.3.1")'
RUN R -e 'library(digitalDLSorteR)'
RUN R -e 'reticulate::install_miniconda("/r-miniconda")'
RUN /r-miniconda/bin/conda create --name digitaldlsorter-env python=3.7
RUN R -e 'tensorflow::install_tensorflow(method = "conda", conda = "/r-miniconda/bin/conda", envname = "digitaldlsorter-env", version = "2.5-cpu")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]
