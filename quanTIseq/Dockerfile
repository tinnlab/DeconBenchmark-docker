ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    r-cran-mass \
    r-bioc-preprocesscore && \
    apt-get clean

RUN R -e "install.packages(c('limSolve'))"

COPY source/DOCKER_codes.R /code/
COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]