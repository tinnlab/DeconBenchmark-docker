ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

ARG GPAT
ENV GITHUB_PAT=${GPAT}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libxml2-dev \
    r-cran-quadprog \
    r-cran-reshape \
    r-cran-e1071 \
    r-cran-seurat \
    r-cran-rocr \
    r-cran-magick \
    r-cran-gmp \
    r-cran-rcppparallel \
    r-cran-rcppgsl
    r-cran-r.methodss3 \
    r-cran-sass \
    r-cran-tinytex \
    r-cran-jquerylib \
    r-cran-rmarkdown \
    r-cran-systemfonts \
    r-cran-tweenr \
    r-cran-iterators \
    r-cran-foreach \
    r-cran-globaloptions \
    r-cran-rjson \
    r-cran-shape \
    r-cran-r.oo \
    r-cran-statmod \
    r-cran-corpcor \
    r-cran-graphlayouts \
    r-cran-tidygraph \
    r-cran-viridis \
    r-cran-ggforce \
    r-cran-doparallel \
    r-cran-clue \
    r-cran-getoptlong \
    r-cran-circlize \
    r-cran-r.utils \
    r-bioc-qvalue \
    r-bioc-limma \
    r-cran-ggraph \
    r-cran-ggdendro \
    r-cran-dbscan \
    r-bioc-complexheatmap && \
    apt-get clean

RUN R -e 'BiocManager::install(c("varhandle", "MAST", "ClusterR", "RcppArmadillo", "Rfast"))'
RUN R -e 'library("ClusterR")'
RUN R -e 'library("RcppArmadillo")'
RUN R -e 'library("Rfast")'
RUN R -e 'devtools::install_github("RubD/Giotto", upgrade = "never")'
RUN R -e 'Giotto::installGiottoEnvironment()'

COPY *.R /code/

CMD ["R", "--no-restore", "--no-save", "--quiet", "--slave", "--file=/code/run.R"]
