ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get remove -y libopenblas* && \
    apt-get install -y --no-install-recommends \
    r-cran-e1071  \
    r-bioc-preprocesscore && \
    apt-get clean

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R" ]