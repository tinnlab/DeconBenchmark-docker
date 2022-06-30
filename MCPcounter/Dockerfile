ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

COPY Source /code/MCPcounter

RUN R -e "install.packages('/code/MCPcounter', repos=NULL, type='source')"

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]