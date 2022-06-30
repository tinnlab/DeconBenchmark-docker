ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]