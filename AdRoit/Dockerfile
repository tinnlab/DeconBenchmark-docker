ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-seurat \
    r-cran-fitdistrplus \
    r-cran-nnls \
    r-cran-reshape2 \
    r-cran-data.table \
    r-cran-matrixstats \
    r-cran-doparallel \
    r-cran-foreach \
    r-cran-ggplot2 && \
    apt-get clean

COPY AdRoit_0.2.2.tar.gz /code/AdRoit_0.2.2.tar.gz

RUN R -e "install.packages('/code/AdRoit_0.2.2.tar.gz', type='source', repos=NULL)"
RUN rm /code/AdRoit_0.2.2.tar.gz

COPY run.R /code/
CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]