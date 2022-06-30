ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN R -e 'devtools::install_github("Hanyuz1996/EMeth")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]