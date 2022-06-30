ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-rcpp \
    r-cran-rcpparmadillo \
    r-cran-combinat \
    r-cran-rcolorbrewer \
    r-cran-gplots && \
    apt-get clean

COPY Package /code/Package/

RUN R -e "install.packages('/code/Package', type='source', repos=NULL)"

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]