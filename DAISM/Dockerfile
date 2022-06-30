ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN pip3 install --no-cache-dir daism

COPY create_h5ad.py /code/
COPY run.sh /code/

CMD ["/bin/sh", "/code/run.sh"]