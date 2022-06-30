ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libxml2-dev \
    r-cran-quadprog \
    r-cran-reshape \
    r-cran-e1071 \
    r-cran-seurat \
    r-cran-rocr && \
    apt-get clean

RUN R -e 'BiocManager::install(c("varhandle", "MAST"))'

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]