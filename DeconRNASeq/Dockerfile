ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN R -e "BiocManager::install('DeconRNASeq', update=F)"

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]