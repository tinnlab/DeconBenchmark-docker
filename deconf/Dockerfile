ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-corpcor && \
    apt-get clean

RUN R -e "install.packages('http://web.cbio.uct.ac.za/~renaud/CRAN/src/contrib/deconf_1.0.1.tar.gz')"

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]