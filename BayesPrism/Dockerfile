ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-snowfall \
    r-cran-nmf \
    r-cran-ggplot2 && \
    apt-get clean

RUN apt-get update && apt-get install -y \
    r-bioc-biobase \
    r-bioc-scran \
    r-bioc-biocparallel

RUN R -e 'devtools::install_github("Danko-Lab/BayesPrism/BayesPrism")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]
