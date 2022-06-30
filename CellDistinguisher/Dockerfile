ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y r-cran-gtools \
    r-cran-matrix && \
    apt-get clean

RUN R -e 'devtools::install_github("GeneralElectric/CellDistinguisher")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]