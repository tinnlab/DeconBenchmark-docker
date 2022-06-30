ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    r-bioc-preprocesscore \
    r-bioc-edger \
    r-bioc-deseq2 \
    r-bioc-hdf5array && \
    apt-get clean

RUN R -e 'BiocManager::install("metaseqR2", update=F)'
RUN R -e 'devtools::install_github("lihuamei/LinDeconSeq")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]