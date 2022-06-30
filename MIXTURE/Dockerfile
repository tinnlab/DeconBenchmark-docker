ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-e1071 \
    r-bioc-preprocesscore \
    r-cran-nnls \
    r-cran-plyr \
    r-cran-abind \
    r-cran-ggplot2 \
    r-cran-openxlsx && \
    apt-get clean

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]