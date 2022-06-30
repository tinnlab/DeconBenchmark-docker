ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    r-cran-e1071 \
    r-cran-pracma \
    r-cran-quadprog \
    r-bioc-singlecellexperiment \
    r-bioc-annotate \
    r-bioc-hdf5array && \
    apt-get clean

RUN R -e 'BiocManager::install("GSVA")'

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]