ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-xtable \
    r-cran-mass \
    r-cran-rgl \
    r-cran-car && \
    apt-get clean

RUN R -e 'install.packages("matlib"); devtools::install_github("sqsun/MOMF")'

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]