ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends\
    r-cran-pls \
    r-cran-mass && \
    apt-get clean

RUN R -e "install.packages(c('colorRamps', 'transport'))"

RUN pip3 install --no-cache-dir numexpr numpy scipy pandas bx-python matplotlib rpy2 seaborn pysam

COPY DeconPeaker /code/DeconPeaker
COPY run.sh /code/

CMD ["/bin/sh", "/code/run.sh"]