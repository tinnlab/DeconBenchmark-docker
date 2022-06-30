ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    r-cran-dosnow \
    r-cran-snow \
    r-cran-robustbase \
    r-cran-foreach \
    r-cran-doparallel \
    r-cran-metrics \
    r-cran-randomforest && \
    apt-get clean

COPY ./Package /code/Package

RUN R -e 'install.packages("varhandle"); install.packages("/code/Package/", type="source", repos=NULL)'

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]