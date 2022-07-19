ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-quadprog && \
    apt-get clean

RUN R -e "install.packages('https://github.com/zhandong/DSA/blob/master/Package/version_1.0/DSA_1.0.tar.gz?raw=true', type='source', repos=NULL)"

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R" ]