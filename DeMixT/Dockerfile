ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE


RUN apt-get remove -y --auto-remove r-base-core

RUN rm /etc/apt/sources.list.d/r-project.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends  \
    r-base \
    r-cran-dplyr \
    r-cran-devtools \
    r-bioc-rhdf5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY R /code/R
RUN R -e "install.packages('/code/R/DeconUtils/', type='source', repos=NULL)"

RUN R -e "install.packages('BiocManager')"

RUN R -e 'BiocManager::install("DeMixT", update=F)'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]