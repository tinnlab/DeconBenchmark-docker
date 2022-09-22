ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && apt-get install -y \
    r-bioc-biobase

RUN R -e 'install.packages("BisqueRNA")'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]