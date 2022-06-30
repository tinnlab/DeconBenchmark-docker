ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-mcmcpack \
    r-cran-quadprog \
    r-cran-mass \
    r-cran-tibble \
    r-cran-mvtnorm && \
    apt-get clean

RUN R -e 'install.packages("invgamma")'
RUN R -e 'devtools::install_github("AshTai/BayICE")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]