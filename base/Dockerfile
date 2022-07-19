FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends  \
    software-properties-common \
    build-essential \
    liblapack-dev  \
    libopenblas-dev \
    gfortran \
    wget \
    python3 \
    python3-pip && \
    apt-get clean

RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor -o /usr/share/keyrings/r-project.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | tee -a /etc/apt/sources.list.d/r-project.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends  \
    r-base \
    r-cran-dplyr \
    r-cran-devtools \
    r-bioc-rhdf5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('BiocManager')"

COPY Python /code/Python
RUN pip3 install --no-cache-dir /code/Python/

COPY R /code/R
RUN R -e "install.packages('/code/R/DeconUtils/', type='source', repos=NULL)"

CMD ["echo", "Welcome to DeconBenchmark!" ]