ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN pip3 install --no-cache-dir scaden

COPY run.sh /code/

CMD ["/bin/sh", "/code/run.sh" ]