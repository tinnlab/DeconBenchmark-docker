ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-nnls \
    r-bioc-preprocesscore && \
    apt-get clean

RUN R -e "install.packages('https://github.com/YuningHao/FARDEEP/raw/master/Rpackage/FARDEEP_1.0.1.tar.gz', type='source', repos=NULL)"

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]