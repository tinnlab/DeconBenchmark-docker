ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN R -e 'devtools::install_github("ctlab/linseed")'

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]