ARG BASE_IMAGE=deconbenchmark/base:v0.1
FROM $BASE_IMAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    r-cran-gtools \
    r-bioc-deseq2 \
    r-cran-rlist && \
    apt-get clean

RUN R -e 'devtools::install_github("GeneralElectric/CellDistinguisher")'
RUN R -e 'BiocManager::install("TOAST", update=F)'
RUN R -e 'devtools::install_github("ctlab/linseed")'
RUN R -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/csSAM/csSAM_1.2.4.tar.gz", type="source", repos=NULL)'
RUN R -e 'devtools::install_github("bhattacharya-a-bt/DeCompress")'

COPY DeCompress /code/DeCompress
RUN R -e 'install.packages("/code/DeCompress", type="source", repos=NULL)'

COPY run.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]