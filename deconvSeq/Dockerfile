ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    r-bioc-edger \
    r-cran-mass \
    r-cran-lme4 \
    r-bioc-biomart \
    r-cran-rsolnp \
    r-cran-psych \
    r-bioc-summarizedexperiment \
    r-bioc-singlecellexperiment \
    r-bioc-scater \
    r-bioc-scran && \
    apt-get clean

RUN R -e 'install.packages("Rmisc"); BiocManager::install("methylKit", update=F)'
RUN R -e 'devtools::install_github("rosedu1/deconvSeq", dependencies=F)'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]