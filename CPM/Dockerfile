ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgdal-dev \
    r-cran-rtsne \
    r-cran-fields \
    r-cran-raster \
    r-cran-irlba \
    r-bioc-limma && \
    apt-get clean

RUN R -e "install.packages('scBio')"

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]