ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

ARG GPAT
ENV GITHUB_PAT=${GPAT}

RUN apt-get update && \
    apt-get remove -y libopenblas* && \
    apt-get install -y --no-install-recommends \
    r-cran-e1071 \
    r-cran-nmf \
    r-bioc-preprocesscore \
    r-bioc-biobase \
    r-bioc-annotationdbi && \
    apt-get clean

RUN R -e 'devtools::install_github("shenorrlab/bseq-sc")'

COPY CIBERSORT /code/CIBERSORT

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]