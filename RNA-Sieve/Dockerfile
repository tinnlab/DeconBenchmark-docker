ARG BASE_IMAGE=base:latest
FROM $BASE_IMAGE

RUN pip3 install --no-cache-dir rnasieve

COPY run.py /code/

CMD ["python3", "/code/run.py"]

