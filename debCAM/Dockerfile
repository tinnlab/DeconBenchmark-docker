ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    r-cran-rjava \
    r-bioc-biocparallel \
    r-bioc-biobase \
    r-bioc-summarizedexperiment && \
    apt-get clean

RUN R -e 'install.packages("rJava")'
RUN R -e 'BiocManager::install("debCAM", update=F)'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]