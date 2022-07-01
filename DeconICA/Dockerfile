ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends r-cran-hmisc && \
    apt-get clean

RUN R -e 'devtools::install_github("UrszulaCzerwinska/DeconICA")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]